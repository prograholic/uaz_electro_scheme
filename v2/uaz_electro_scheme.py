from networkx import Graph
from engine import PowerSource, Consumer, Pin, Connection, COLOR, Scheme

from elements.generic_car_elements import Akb, Light


uaz = Scheme(Graph())

akb = Akb(uaz, "Аккумулятор", 12.0)

light = Light(uaz, "подсветка салона", 5)


akb.plus().addConnectionTo(light.plus(), 3.0, 0.5, COLOR.Red)
light.minus().addConnectionTo(akb.minus(), 3.0, 0.5, COLOR.Black)
