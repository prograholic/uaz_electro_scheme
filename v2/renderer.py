import networkx as nx
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import math
import random
import engine

random.seed(100500)


DEFAULT_PIN_COLOR_MAP = {
    'PowerSource': 'green',
    'Consumer': 'red',
    'Light': 'yellow',
    'Winch': 'brown'
}

DEFAULT_NODE_SIZE_MAP = {
    'Pin': 10,
    'PowerSource': 20,
    'Light': 20,
    'Consumer': 30
}

DEFAULT_PADDING = 0.1
DEFAULT_GROUP_MARGIN = 2.0
DEFAULT_JITTER_AMOUNT = 0.15

def drawBoundingBox(groupName, pos, nodes, ax, padding=DEFAULT_PADDING):

    # Собираем все координаты X и Y для узлов текущей группы
    x_coords = [pos[n][0] for n in nodes]
    y_coords = [pos[n][1] for n in nodes]

    # Находим крайние точки (границы кластера)
    min_x, max_x = min(x_coords), max(x_coords)
    min_y, max_y = min(y_coords), max(y_coords)

    # Вычисляем ширину и высоту прямоугольника с учетом отступа
    width = (max_x - min_x) + 2 * padding
    height = (max_y - min_y) + 2 * padding

    # Левый нижний угол рамки
    rect_x = min_x - padding
    rect_y = min_y - padding

    # Создаем рамку (FancyBboxPatch делает углы скругленными)
    rect = patches.FancyBboxPatch(
        (rect_x, rect_y), width, height,
        boxstyle='round,pad=0.1',
        linewidth=2,
        edgecolor='gray',         # Цвет границы рамки
        facecolor='none',         # Цвет заливки (none — прозрачный)
        linestyle='--',           # Пунктирная линия
        alpha=0.7,
        zorder=-1                 # Отправляем рамку на задний план, под узлы
    )

    # Добавляем рамку на график
    ax.add_patch(rect)

    # (Опционально) Добавляем название группы прямо над рамкой
    ax.text(
        rect_x + width/2, max_y + padding + 0.1,
        groupName,
        fontsize=12, weight="bold", ha="center", va="bottom"
    )

def prepareGroups(graph: nx.Graph):
    groups = {}
    for node, pin in graph.nodes(data=engine.PIN_TAG):
        groups.setdefault(pin.getGroupName(), []).append(node)

    return groups

def prepareGroupPositions(graph, groups, padding=DEFAULT_PADDING, group_margin=DEFAULT_GROUP_MARGIN, jitter_amount=DEFAULT_JITTER_AMOUNT):
    group_graph = nx.cycle_graph(len(groups))
    local_positions = {}
    group_dimensions = {} # Здесь будем хранить [ширину, высоту] рамки для каждой группы

    for group_name, nodes in groups.items():
        sub_g = graph.subgraph(nodes)
        #loc_pos = nx.spring_layout(sub_g, center=(0, 0), scale=0.3, k=0.1, seed=42)
        loc_pos = nx.circular_layout(sub_g, center=(0, 0), scale=0.3)
        local_positions[group_name] = loc_pos

    # Вычисляем размеры рамки для этой группы
    x_coords = [p[0] for p in loc_pos.values()]
    y_coords = [p[1] for p in loc_pos.values()]

    # Ширина и высота рамки группы
    width = (max(x_coords) - min(x_coords)) + 2 * padding
    height = (max(y_coords) - min(y_coords)) + 2 * padding
    group_dimensions[group_name] = (width, height)

    # 4. Шаг Б: Расставляем центры групп по сетке, чтобы рамки не пересекались
    # Находим максимальные габариты среди всех групп, чтобы задать шаг сетки
    max_w = max(d[0] for d in group_dimensions.values())
    max_h = max(d[1] for d in group_dimensions.values())

    # Шаг сетки равен размеру самой большой группы + зазор между группами
    grid_step_x = max_w + group_margin
    grid_step_y = max_h + group_margin

    # Определяем количество колонок в сетке (например, квадратная сетка)
    num_groups = len(groups)
    cols = math.ceil(math.sqrt(num_groups))

    # Вычисляем глобальные координаты для каждого узла
    pos = {}
    group_centers = {} # Координаты центров для отрисовки текста

    for i, group_name in enumerate(groups.keys()):
        # Определяем ячейку в сетке (строка и колонка)
        row = i // cols
        col = i % cols

        # Центр текущей ячейки сетки
        center_x = col * grid_step_x
        center_y = -row * grid_step_y # Минус, чтобы сетка росла сверху вниз
        group_centers[group_name] = (center_x, center_y)

        # Генерируем небольшое случайное смещение для X и Y
        jitter_x = random.uniform(-jitter_amount, jitter_amount)
        jitter_y = random.uniform(-jitter_amount, jitter_amount)

        # Сдвигаем локальные координаты группы на этот центр
        for node in groups[group_name]:
            pos[node] = local_positions[group_name][node] + (center_x + jitter_x, center_y + jitter_y)

    return pos

def draw(graph: nx.Graph, pin_color_map: dict[str, str]=DEFAULT_PIN_COLOR_MAP, size_mapping: dict[str, int]=DEFAULT_NODE_SIZE_MAP):
    colors = [c.getColor().value for u, v, c in graph.edges(data=engine.CONNECTION_TAG)]

    groups = prepareGroups(graph)
    pos = prepareGroupPositions(graph, groups)

    node_colors = [pin_color_map.get(type(pin).__name__, 'blue') for _, pin in graph.nodes(data=engine.PIN_TAG)]
    node_sizes = [size_mapping.get(type(pin).__name__, 10) for _, pin in graph.nodes(data=engine.PIN_TAG)]
    labels = {node: node for node in graph.nodes()}

    fig, ax = plt.subplots(figsize=(10, 8))

    nx.draw(graph, pos,
        with_labels=False,
        edge_color=colors,
        node_color=node_colors,
        node_size=node_sizes,
        labels=labels,
        arrows=True,
        arrowsize=0,
        connectionstyle='angle,angleA=0,angleB=90,rad=0',
        ax=ax,
        width=0.8
    )

    for group_name, nodes in groups.items():
        drawBoundingBox(group_name, pos, nodes, ax)

    plt.axis('off')
    # Автоматически масштабируем оси Matplotlib, чтобы рамки не обрезались по краям
    ax.relim()
    ax.autoscale_view()
    plt.show()
