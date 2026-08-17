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

    zero_rows = np.where(np.diff(A_sparse.indptr) == 0)[0]
    print("Пустые строки (индексы узлов/ветвей):", zero_rows)
    for zr in zero_rows:
        found = False
        for node, idx in node_to_idx.items():
            if idx == zr:
                print(f'  node: {node}')
                found = True

        if not found:
            print(f'  cannot find node for index {zr}')

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

        # Если ни одно реле не изменило статус, схема стабилизировалась
        if not changed:
            print(f"Схема стабилизировалась за {iteration + 1} итераций.")
            return

    print("Внимание: Превышено число итераций! Возможно зацикливание реле (осцилляция).")
