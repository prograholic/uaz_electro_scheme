import pytest

from networkx import Graph
from engine import *
from elements.generic_car_elements import *
from circuit_analyzers import *


def createScheme():
    graph = Graph()
    return Scheme(graph)


def test_with_simple_light():
    s = createScheme()

    gnd = GroundPin(s, 'Земля')
    ps = PowerSource(s, 'АКБ', 12, 500, gnd)
    l = Consumer(s, 'Свет', 5)

    ps.plus.addWireConnectionTo(l.plus, 1, 1, COLOR.Red)
    l.minus.addWireConnectionTo(gnd, 1, 1, COLOR.Black)

    simulate_circuit_with_relays(s, gnd)
    printScheme(s)

    assert(l.plus.getPotential() > 11)


def test_with_relay_light():
    s = createScheme()

    gnd = GroundPin(s, 'Земля')
    ps = PowerSource(s, 'АКБ', 12, 500, gnd)
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


def test_with_relay5_light():
    s = createScheme()

    gnd = GroundPin(s, 'Земля')
    ps = PowerSource(s, 'АКБ', 12, 500, gnd)
    l = Consumer(s, 'Свет', 5)
    l2 = Consumer(s, 'Свет 2', 5)
    relay = Relay5(s, 'Реле')

    ps.plus.addWireConnectionTo(relay._30, 1, 1, COLOR.Green)

    relay._86.addWireConnectionTo(gnd, 1, 1, COLOR.Black)

    relay._87.addWireConnectionTo(l.plus, 1,1, COLOR.Blue)
    relay._88.addWireConnectionTo(l2.plus, 1,1, COLOR.Red)

    l.minus.addWireConnectionTo(gnd, 1, 1, COLOR.Black)
    l2.minus.addWireConnectionTo(gnd, 1, 1, COLOR.Black)

    simulate_circuit_with_relays(s, gnd)
    printScheme(s)

    assert(l.plus.getPotential() < 0.1)
    assert(l2.plus.getPotential() > 11)


    print('Добавляем питание на контакт 85 реле...')

    # Теперь переключаем реле - подаем ток на управляющий pin
    ps.plus.addWireConnectionTo(relay._85, 1, 1, COLOR.Red)

    simulate_circuit_with_relays(s, gnd)
    printScheme(s)

    assert(l2.plus.getPotential() < 0.1)
    assert(l.plus.getPotential() > 11)


def test_short_circuit():
    s = createScheme()

    gnd = GroundPin(s, 'Земля')
    ps = PowerSource(s, 'АКБ', 12, 500, gnd)

    pin = Pin(s, 'Pin')

    ps.plus.addWireConnectionTo(pin, 1, 50, COLOR.Red)
    pin.addWireConnectionTo(gnd, 1, 50, COLOR.Red)

    with pytest.raises(ShortCircuitException):
        simulate_circuit_with_relays(s, gnd)

    printScheme(s)
