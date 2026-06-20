from uaz_electro_scheme import *
from renderer import draw
from circuit_analyzers import *


simulate_circuit_with_relays(uaz, m)


drawList = [generator, starter, akb, m]

graph = uaz.getGraph()
#graph = uaz.getSubGraph(drawList)
#graph = uaz.getSNAPGraph()

draw(graph)
