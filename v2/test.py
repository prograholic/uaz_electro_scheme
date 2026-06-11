import pytest

from networkx import Graph
from engine import *

from circuit_analyzers import *


def createScheme():
    graph = Graph()
    return Scheme(graph)


def test_with_simple_light():
    s = createScheme()

    gnd = GroundPin(s, 'Земля')

    ps = PowerSource(s, 'АКБ', 12, gnd)

    l = Consumer(s, 'Свет', 5)

    ps.plus.addWireConnectionTo(l.plus, 1, 1, COLOR.Red)
    l.minus.addWireConnectionTo(gnd, 1, 1, COLOR.Black)

    simulate_circuit_with_relays(s, gnd)


    for pinName, pin in s.getGraph().nodes(data=engine.PIN_TAG):
        print(f'PIN {pinName} -> {pin.getPotential()}')

    for u, v, connection in s.getGraph().edges(data=engine.CONNECTION_TAG):
        curr = connection.getCurrent()
        if curr >= 0:
            print(f'CONN {u} -> {v} : {curr}')
        else:
            print(f'CONN {v} -> {u} : {-curr}')



    assert(l.plus.getPotential() > 11)
