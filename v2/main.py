from uaz_electro_scheme import *
from renderer import draw
from circuit_analyzers import *
from engine import *




# Обрабатываем переключатели
ground_switch.on()
#ignition_switch.on()




simulate_circuit_with_relays(uaz, m)
printScheme(uaz)


drawList = [generator, starter, akb, m]

graph = uaz.getGraph()
#graph = uaz.getSubGraph(drawList)
#graph = uaz.getSNAPGraph()

draw(graph)
