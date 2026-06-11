import networkx as nx
import numpy as np
from scipy.sparse import lil_matrix
from scipy.sparse.linalg import spsolve
import scipy.sparse as sp

import engine

def solve_mna(scheme: engine.Scheme, ground_node: engine.GroundPin):
    graph = scheme.getGraph()

    ground_node_name = ground_node.getName()

    nodes = sorted(list(graph.nodes()))
    nodes_reduced = [n for n in nodes if n != ground_node_name]

    vdc_sources = [connection for u, v, connection in graph.edges(data=engine.CONNECTION_TAG) if connection.isPowerSourceConnection()]

    print(nodes)
    print(nodes_reduced)

    node_to_idx = {node: idx for idx, node in enumerate(nodes_reduced)}

    # 2. Строим базовую матрицу проводимостей Y
    Y_graph = nx.Graph()
    for u, v, connection in graph.edges(data=engine.CONNECTION_TAG):
        r = connection.getResistance()
        # Обработка бесконечного сопротивления (разомкнутый контакт)
        if r < engine.MAX_RESISTANCE:
            g = 1.0 / r
            if Y_graph.has_edge(u, v):
                Y_graph[u][v]['cond'] += g
            else:
                Y_graph.add_edge(u, v, cond=g)

    # Добавляем изолированные узлы, если они есть
    Y_graph.add_nodes_from(nodes)

    # Получаем матрицу Лапласа и редуцируем ее
    Y_full = nx.laplacian_matrix(Y_graph, weight='cond', nodelist=nodes).todense()
    # Индексы для удаления заземленного узла
    ground_idx = nodes.index(ground_node_name)
    Y_reduced = np.delete(Y_full, ground_idx, axis=0)
    Y_reduced = np.delete(Y_reduced, ground_idx, axis=1)

    # 3. Строим матрицу B для источников напряжения
    num_nodes_red = len(nodes_reduced)
    num_sources = len(vdc_sources)

    B = np.zeros((num_nodes_red, num_sources))
    E = np.zeros(num_sources)

    for psc_idx, connection in enumerate(vdc_sources):
        E[psc_idx] = connection.getPowerSourceVoltage()
        # Плюс источника (ток вытекает)
        if connection.plus().getName() in node_to_idx:
            B[node_to_idx[connection.plus().getName()], psc_idx] = 1.0
        # Минус источника (ток втекает)
        if connection.minus().getName() in node_to_idx:
            B[node_to_idx[connection.minus().getName()], psc_idx] = -1.0

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
    ground_node.setPotential(0.0)
    for node in nodes_reduced:
        pin = scheme.findPinByName(node)
        pin.setPotential(X[node_to_idx[node]])

    for u, v, connection in graph.edges(data=engine.CONNECTION_TAG):
        connection: engine.ConnectionBase

        r = connection.getResistance()
        if r >= engine.MAX_RESISTANCE:
            connection.setCurrent(0.0)
            continue

        edge_src = [connection for connection in vdc_sources if connection.hasEdge(u, v)]
        if edge_src and r == 0:
            k = vdc_sources.index(edge_src[0])
            i_src = X[len(nodes) + k]
            connection.setCurrent(abs(i_src))
        else:
            e_val = 0
            if edge_src:
                connection = edge_src[0]
                e_val = connection.getPowerSourceVoltage() if connection.plus().getName() == u else -connection.getPowerSourceVoltage()
            current = (scheme.findPinByName(u).getPotential() - scheme.findPinByName(v).getPotential() + e_val) / r
            connection.setCurrent(current)



# --- ФУНКЦИЯ ДИНАМИЧЕСКОЙ СИМУЛЯЦИИ РЕЛЕ ---
def simulate_circuit_with_relays(scheme: engine.Scheme, ground_node: engine.GroundPin, max_iterations=10):
    """
    relays: список словарей конфигурации реле, например:
    [{
        'coil': (node1, node2),      # ребро катушки
        'contacts': (node3, node4),  # ребро контактов
        'i_trigger': 0.02,           # ток срабатывания катушки (А)
        'type': 'NO'                 # NO - нормально разомкнутый, NC - нормально замкнутый
    }]
    """
    # 1. Задаем исходное состояние контактов реле
    #for r in relays:
    #    if r['type'] == 'NO':
    #        G[r['contacts'][0]][r['contacts'][1]]['R'] = 1e9  # Разомкнуто (1 ГОм)
    #    else:
    #        G[r['contacts'][0]][r['contacts'][1]]['R'] = 0.01 # Замкнуто (0.01 Ом)

    prev_states = []

    # Итерационный цикл логики реле
    for iteration in range(max_iterations):
        # Шаг А: Рассчитываем токи в текущей конфигурации
        #potentials, currents = solve_mna(scheme, ground_node=ground_node)
        solve_mna(scheme, ground_node=ground_node)

        current_states = []
        changed = False

        # Шаг Б: Проверяем катушки всех реле
        for autoConnection in scheme.findAutomaticSwitchConnections():
            if autoConnection.updateState():
                changed = True

        '''
        for r in relays:
            c_u, c_v = r['coil']
            # Находим ток через катушку (в любом направлении)
            i_coil = currents.get((c_u, c_v), currents.get((c_v, c_u), 0.0))

            # Определяем, должно ли реле сработать
            is_active = i_coil >= r['i_trigger']
            current_states.append(is_active)

            # Управляем контактами
            contact_u, contact_v = r['contacts']
            old_R = G[contact_u][contact_v]['R']

            if r['type'] == 'NO':
                new_R = 0.01 if is_active else 1e9
            else: # NC
                new_R = 1e9 if is_active else 0.01

            if old_R != new_R:
                G[contact_u][contact_v]['R'] = new_R
                changed = True

        '''

        # Если ни одно реле не изменило статус, схема стабилизировалась
        if not changed:
            print(f"Схема стабилизировалась за {iteration + 1} итераций.")
            return #potentials, currents

    print("Внимание: Превышено число итераций! Возможно зацикливание реле (осцилляция).")
    return #potentials, currents

'''

# --- ПРИМЕР СХЕМЫ ---
G = nx.Graph()

# Цепь 1: Управляющая (включает катушку)
G.add_edge('VCC1', 'coil_in', E=12.0, from='VCC1', to='coil_in', R=0.1) # Источник 12В
G.add_edge('coil_in', 'GND', R=300.0)                                  # Катушка реле (300 Ом)

# Цепь 2: Управляемая (силовая нагрузка, коммутируется контактами)
G.add_edge('VCC2', 'sw_in', E=24.0, from='VCC2', to='sw_in', R=0.1)   # Силовой источник 24В
G.add_edge('sw_in', 'load_in', R=1e9)                                  # Сюда запишем контакты реле
G.add_edge('load_in', 'GND', R=10.0)                                   # Мощная нагрузка (10 Ом)

# Конфигурация реле
relays_config = [{
    'coil': ('coil_in', 'GND'),
    'contacts': ('sw_in', 'load_in'),
    'i_trigger': 0.03, # 30 мА нужно для срабатывания
    'type': 'NO'
}]

# Запуск симуляции
potentials, currents = simulate_circuit_with_relays(G, relays_config, ground_node='GND')

print("\nКонечные токи в схеме:")
for (start, end), I in currents.items():
    if I > 1e-5: # убираем утечки разомкнутых контактов из вывода
        print(f"Ток: {start} -> {end} | {I:.3f} А")

'''