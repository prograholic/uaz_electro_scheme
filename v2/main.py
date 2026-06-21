from uaz_electro_scheme import *
from renderer import draw
from circuit_analyzers import *
from engine import *

simulate_circuit_with_relays(uaz, m)
printScheme(uaz)


drawList = [generator, starter, akb, m]

graph = uaz.getGraph()
#graph = uaz.getSubGraph(drawList)
#graph = uaz.getSNAPGraph()

draw(graph)
