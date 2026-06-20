import pytest

from networkx import Graph
from engine import *
from elements.generic_car_elements import *
from circuit_analyzers import *


def createScheme():
    graph = Graph()
    return Scheme(graph)


def printScheme(s):
    print('#######################################')
    for pinName, pin in s.getGraph().nodes(data=engine.PIN_TAG):
        print(f'PIN {pinName} -> {pin.getPotential()}')

    for u, v, connection in s.getGraph().edges(data=engine.CONNECTION_TAG):
        curr = connection.getCurrent()
        if curr >= 0:
            print(f'CONN {u} -> {v} : {curr}')
        else:
            print(f'CONN {v} -> {u} : {-curr}')

    print('\n')


def test_with_simple_light():
    s = createScheme()

    gnd = GroundPin(s, 'Земля')
    ps = PowerSource(s, 'АКБ', 12, gnd)
    l = Consumer(s, 'Свет', 5)

    ps.plus.addWireConnectionTo(l.plus, 1, 1, COLOR.Red)
    l.minus.addWireConnectionTo(gnd, 1, 1, COLOR.Black)

    simulate_circuit_with_relays(s, gnd)
    printScheme(s)

    assert(l.plus.getPotential() > 11)


def test_with_relay_light():
    s = createScheme()

    gnd = GroundPin(s, 'Земля')
    ps = PowerSource(s, 'АКБ', 12, gnd)
    l = Consumer(s, 'Свет', 5)
    relay = Relay(s, 'Реле')

    ps.plus.addWireConnectionTo(relay._30, 1, 1, COLOR.Green)
    ps.plus.addWireConnectionTo(relay._85, 1, 1, COLOR.Red)

    relay._86.addWireConnectionTo(gnd, 1, 1, COLOR.Black)
    relay._87.addWireConnectionTo(l.plus, 1,1, COLOR.Blue)

    l.minus.addWireConnectionTo(gnd, 1, 1, COLOR.Black)

    simulate_circuit_with_relays(s, gnd)
    printScheme(s)

    assert(l.plus.getPotential() > 11)
