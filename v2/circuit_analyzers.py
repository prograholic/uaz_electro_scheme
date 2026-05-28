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
