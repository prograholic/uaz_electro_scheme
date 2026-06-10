import networkx as nx
import numpy as np
import scipy.sparse as sp
from scipy.sparse.linalg import spsolve

# 1. Создаем граф цепи
G = nx.Graph()

# Потребители (резисторы/проводимости)
G.add_edge(0, 1, type='R', value=4.0)  # Резистор 2 Ом между 0 и 1
G.add_edge(1, 2, type='R', value=4.0)  # Резистор 2 Ом между 0 и 1
#G.add_edge(1, 3, type='R', value=0.1)  # Резистор 5 Ом между 1 и 2
#G.add_edge(3, 2, type='R', value=5.0)  # Резистор 5 Ом между 1 и 2
#G.add_edge(0, 4, type='R', value=5.0)  # Резистор 5 Ом между 1 и 2
#G.add_edge(4, 5, type='R', value=5.0)  # Резистор 5 Ом между 1 и 2
#G.add_edge(5, 2, type='R', value=5.0)  # Резистор 5 Ом между 1 и 2
#G.add_edge(6, 2, type='R', value=5.0)  # Резистор 5 Ом между 1 и 2
#G.add_edge(0, 7, type='R', value=5.0)  # Резистор 5 Ом между 1 и 2

# Источник напряжения (ЭДС) между узлом 0 и 2 (пусть 0 - земля)
# Укажем полярность: от node_from к node_to
vdc_sources = [
    {'from': 0, 'to': 2, 'value': 12.0}  # ЭДС 12 Вольт
]

# Настраиваем список узлов и заземление
nodes = sorted(list(G.nodes()))
ground_node = 0
nodes_reduced = [n for n in nodes if n != ground_node]
node_to_idx = {node: idx for idx, node in enumerate(nodes_reduced)}

# 2. Строим базовую матрицу проводимостей Y для резисторов
Y_graph = nx.Graph()
for u, v, d in G.edges(data=True):
    if d['type'] == 'R':
        # Проводимость G = 1 / R
        cond = 1.0 / d['value']
        if Y_graph.has_edge(u, v):
            Y_graph[u][v]['cond'] += cond
        else:
            Y_graph.add_edge(u, v, cond=cond)

# Добавляем изолированные узлы, если они есть
Y_graph.add_nodes_from(nodes)

# Получаем матрицу Лапласа и редуцируем ее
Y_full = nx.laplacian_matrix(Y_graph, weight='cond', nodelist=nodes).todense()
# Индексы для удаления заземленного узла
ground_idx = nodes.index(ground_node)
Y_reduced = np.delete(Y_full, ground_idx, axis=0)
Y_reduced = np.delete(Y_reduced, ground_idx, axis=1)

# 3. Строим матрицу B для источников напряжения
num_nodes_red = len(nodes_reduced)
num_sources = len(vdc_sources)

B = np.zeros((num_nodes_red, num_sources))
E = np.zeros(num_sources)

for s_idx, src in enumerate(vdc_sources):
    E[s_idx] = src['value']
    # Плюс источника (ток вытекает)
    if src['to'] in node_to_idx:
        B[node_to_idx[src['to']], s_idx] = 1.0
    # Минус источника (ток втекает)
    if src['from'] in node_to_idx:
        B[node_to_idx[src['from']], s_idx] = -1.0

# 4. Собираем расширенную матрицу MNA
C = np.zeros((num_sources, num_sources))

# Блочная сборка матрицы
A_top = np.hstack((Y_reduced, B))
A_bottom = np.hstack((B.T, C))
A_mna = np.vstack((A_top, A_bottom))

# Преобразуем в разреженный формат для spsolve
A_sparse = sp.csr_matrix(A_mna)

# Вектор правой части (токи узлов от источников тока тут равны 0)
I_nodes = np.zeros(num_nodes_red)
RHS = np.concatenate((I_nodes, E))

# 5. Решение системы через spsolve
X = spsolve(A_sparse, RHS)

# Разбор результатов
V_dict = {ground_node: 0.0} # Земля
for n in nodes_reduced:
    V_dict[n] = X[node_to_idx[n]]

print("Узловые потенциалы:", V_dict)
print("Токи через источники ЭДС:", X[num_nodes_red:])
