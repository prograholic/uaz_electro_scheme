import engine
from networkx import Graph, bfs_edges

def _getPin(graph, pinId) -> engine.Pin:
    return graph.nodes[pinId][engine.PIN_TAG]

def _getConnection(graph, srcId, dstId) -> engine.Connection:
    return graph.edges[srcId, dstId][engine.CONNECTION_TAG]


def findPowerSourcesPlus(graph: Graph):
    return [node for node, pin in graph.nodes(data=engine.PIN_TAG) if pin.isPowerSourcePlus()]

def calculateCircuitFor(graph: Graph, node):
    for srcId, dstId in bfs_edges(graph, source=node):
        print(f'calculateCircuitFor: {node}, {srcId}, {dstId}')
        connection = _getConnection(graph, srcId, dstId)
        connection.updateVoltage()


def calculateCircuit(scheme: engine.Scheme):
    graph = scheme.getGraph()

    powerSources = findPowerSourcesPlus(graph)
    for powerSource in powerSources:
        calculateCircuitFor(graph, powerSource)





'''
import networkx as nx
import numpy as np
from scipy.sparse import lil_matrix
from scipy.sparse.linalg import spsolve

# Используем ранее написанную функцию MNA, немного адаптировав ее возвращаемые данные
def solve_mna(G, ground_node=0):
    nodes = list(G.nodes())
    node_to_idx = {node: i for i, node in enumerate(nodes)}
    num_nodes = len(nodes)

    voltage_sources = []
    for u, v, data in G.edges(data=True):
        if 'E' in data and data['E'] != 0:
            src = data.get('from', u)
            dst = data.get('to', v)
            voltage_sources.append({'from': src, 'to': dst, 'E': data['E'], 'edge': (u, v)})

    num_sources = len(voltage_sources)
    total_dim = num_nodes + num_sources
    A = lil_matrix((total_dim, total_dim))
    B = np.zeros(total_dim)

    for u, v, data in G.edges(data=True):
        r = data.get('R', 1.0)
        # Обработка бесконечного сопротивления (разомкнутый контакт реле)
        g = 1.0 / r if r < 1e9 else 0.0

        iu, iv = node_to_idx[u], node_to_idx[v]
        A[iu, iu] += g
        A[iv, iv] += g
        A[iu, iv] -= g
        A[iv, iu] -= g

    for k, src in enumerate(voltage_sources):
        idx_from = node_to_idx[src['from']]
        idx_to = node_to_idx[src['to']]
        idx_source_equation = num_nodes + k
        A[idx_from, idx_source_equation] += 1
        A[idx_to, idx_source_equation] -= 1
        A[idx_source_equation, idx_from] += 1
        A[idx_source_equation, idx_to] -= 1
        B[idx_source_equation] = src['E']

    idx_gnd = node_to_idx[ground_node]
    A[idx_gnd, :] = 0; A[:, idx_gnd] = 0; A[idx_gnd, idx_gnd] = 1.0; B[idx_gnd] = 0.0

    X = spsolve(A.tocsr(), B)
    potentials = {nodes[i]: X[i] for i in range(num_nodes)}

    circuit_currents = {}
    for u, v, data in G.edges(data=True):
        r = data.get('R', 1.0)
        if r >= 1e9:
            circuit_currents[(u, v)] = 0.0
            continue

        edge_src = [s for s in voltage_sources if s['edge'] == (u, v) or s['edge'] == (v, u)]
        if edge_src and r == 0:
            k = voltage_sources.index(edge_src[0])
            i_src = X[num_nodes + k]
            circuit_currents[(u, v)] = abs(i_src)
        else:
            e_val = 0
            if edge_src:
                e_val = edge_src[0]['E'] if edge_src[0]['from'] == u else -edge_src[0]['E']
            current = (potentials[u] - potentials[v] + e_val) / r
            if current >= 0:
                circuit_currents[(u, v)] = current
            else:
                circuit_currents[(v, u)] = abs(current)

    return potentials, circuit_currents

# --- ФУНКЦИЯ ДИНАМИЧЕСКОЙ СИМУЛЯЦИИ РЕЛЕ ---
def simulate_circuit_with_relays(G, relays, ground_node=0, max_iterations=10):
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
    for r in relays:
        if r['type'] == 'NO':
            G[r['contacts'][0]][r['contacts'][1]]['R'] = 1e9  # Разомкнуто (1 ГОм)
        else:
            G[r['contacts'][0]][r['contacts'][1]]['R'] = 0.01 # Замкнуто (0.01 Ом)

    prev_states = []

    # Итерационный цикл логики реле
    for iteration in range(max_iterations):
        # Шаг А: Рассчитываем токи в текущей конфигурации
        potentials, currents = solve_mna(G, ground_node=ground_node)

        current_states = []
        changed = False

        # Шаг Б: Проверяем катушки всех реле
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

        # Если ни одно реле не изменило статус, схема стабилизировалась
        if not changed:
            print(f"Схема стабилизировалась за {iteration + 1} итераций.")
            return potentials, currents

    print("Внимание: Превышено число итераций! Возможно зацикливание реле (осцилляция).")
    return potentials, currents

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