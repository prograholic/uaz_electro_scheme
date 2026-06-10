import pytest

from networkx import Graph
from engine import *

from circuit_analyzers import *


def createScheme():
    graph = Graph()
    return Scheme(graph)


def test_with_simple_light():
    s = createScheme()

    ps = PowerSource(s, 'АКБ', 12)
    gnd = GroundPin(s, 'Земля')
    l = Consumer(s, 'Свет', 5)

    ps.minus.addWireConnectionTo(gnd, 1, 1, COLOR.Black)
    ps.plus.addWireConnectionTo(l.plus, 1, 1, COLOR.Red)
    l.minus.addWireConnectionTo(gnd, 1, 1, COLOR.Black)

    simulate_circuit_with_relays(s, gnd)


    for pinName, pin in s.getGraph().nodes(data=engine.PIN_TAG):
        print(f'PIN {pinName} -> {pin.getPotential()}')

    for u, v, connection in s.getGraph().edges(data=engine.CONNECTION_TAG):
        print(f'CONN {u} - {v} -> {connection.getCurrent()}')


    assert(l.plus.getPotential() > 5)
