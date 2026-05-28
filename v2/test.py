import pytest

from networkx import Graph
from engine import *

from circuit_analyzers import *


def createScheme():
    graph = Graph()
    return Scheme(graph)


def test_expect_short_circuit():
    s = createScheme()
    ps = PowerSource(s, 'ps', 12)
    ps.plus.addConnectionTo(ps.minus, 1, 1, COLOR.Black)
    with pytest.raises(ShortCircuitException, match='Detected short circuit for ps.минус, voltage is 12.0'):
        calculateCircuit(s)


def test_expect_no_short_circuit():
    s = createScheme()
    ps = PowerSource(s, 'ps', 12)
    cs = Consumer(s, 'cs', 5)
    ps.plus.addConnectionTo(cs.plus, 1, 1, COLOR.Black)
    cs.plus.addConnectionTo(cs.minus, 1, 1, COLOR.Black)
    calculateCircuit(s)
