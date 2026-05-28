from uaz_electro_scheme import *
from renderer import draw


drawList = [generator, starter, akb, m]

graph = uaz.getGraph()
#graph = uaz.getSubGraph(drawList)
#graph = uaz.getSNAPGraph()

draw(graph)
