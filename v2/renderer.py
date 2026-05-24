import networkx as nx
import matplotlib.pyplot as plt

def draw(scheme):
    graph = scheme.getGraph()

    colors = [graph[u][v]['color'] for u, v in graph.edges()]
    nx.draw(graph, with_labels=True, node_size=2000, edge_color=colors)
    plt.show()
