from enum import StrEnum
from typing import Self
from networkx import Graph, snap_aggregation

class COLOR(StrEnum):
    Black = 'black'
    Red = 'red'
    Blue = 'blue'
    White = 'white'
    Green = 'green'
    Yellow = 'yellow'
    Brown = 'brown'
    Orange = 'orange'
    Pink = 'pink'
    Violet = 'violet'
    Grey = 'grey'



PIN_TAG = 'pin'
CONNECTION_TAG = 'connection'

'''

POWER_SOURCE_TAG = 'power_source'
POWER_SOURCE_PLUS = 'plus'
POWER_SOURCE_MINUS = 'minus'


PREFIX_GROUP_TAG = 'prefix_group'
CATEGORY_TAG = 'category'
CONSUMER_TAG = 'consumer'
AMPERAGE_TAG = 'amperage'
VOLTAGE_TAG = 'voltage'
LENGTH_TAG = 'length'
SQUARE_TAG = 'square'
COLOR_TAG = 'color'
INTERNAL_TAG = 'internal'

'''

WIRE_RELATIVE_RESISTANCE = 0.018

class ShortCircuitException(Exception):
    def __init__(self, *args):
        super().__init__(*args)

class Scheme:
    def __init__(self, graph: Graph):
        self._graph = graph

    def getGraph(self) -> Graph:
        return self._graph

    def getSubGraph(self, objects: list):
        subgraphPinList = list()
        for object in objects:
            subgraphPinList.extend(object.getPins())

        subgraphIdList = [pin.getName() for pin in subgraphPinList]
        return self._graph.subgraph(subgraphIdList)

    def getSNAPGraph(self):
        res = snap_aggregation(self._graph, node_attributes=(PREFIX_GROUP_TAG,))

        for node in res.nodes():
            res.nodes[node]['label'] = res.nodes[node][PREFIX_GROUP_TAG]

        return res

    def addPin(self, pin):
        self._graph.add_node(pin.getName(), **{PIN_TAG: pin})

    def findPinByName(self, pinName: str):
        return self._graph.nodes[pinName][PIN_TAG]

    def addConnection(self, connection):
        self._graph.add_edge(connection._pin1.getName(), connection._pin2.getName(), **{CONNECTION_TAG: connection})

    def removeConnection(self, connection):
        self._graph.remove_edge(connection._pin1.getName(), connection._pin2.getName())

    def isConnectionEnabled(self, connection) -> bool:
        return self._graph.has_edge(connection._pin1.getName(), connection._pin2.getName())

class NamedEntity:
    def __init__(self, name: str):
        self._name = name

    def getName(self):
        return self._name

    def getGroupName(self):
        return self._name.split('.')[0]


class Pin(NamedEntity):
    def __init__(self, scheme: Scheme, name: str, powerSourcePlus: bool=False, powerSourceMinus: bool=False, consumerPlus: bool=False, consumerMinus: bool=False, voltage: float=0.0, amperage: float=0.0):
        super().__init__(name)
        self._scheme = scheme
        self._scheme.addPin(self)

        self._powerSourcePlus = powerSourcePlus
        self._powerSourceMinus = powerSourceMinus
        self._consumerPlus = consumerPlus
        self._consumerMinus = consumerMinus
        self._voltage = voltage
        self._amperage = amperage

    def isPowerSourcePlus(self):
        return self._powerSourcePlus

    def isPowerSourceMinus(self):
        return self._powerSourceMinus

    def getPins(self):
        return [self]

    def getAmperage(self) -> float:
        return self._amperage

    def updateAmperage(self, amperage):
        if amperage > self._amperage:
            self._amperage = amperage

    def getVoltage(self) -> float:
        return self._voltage

    def updateVoltage(self, voltage: float):
        if self.isPowerSourceMinus() and (voltage > 0.0):
            raise ShortCircuitException(f'Detected short circuit for {self.getName()}, voltage is {voltage}')

        if voltage > self._voltage:
            self._voltage = voltage

    def addConnectionTo(self, pin: Self, length: float, square: float, color: COLOR):
        return Connection(self, pin, length, square, color)

    def _addInternalConnectionTo(self, pin: Self):
        return createInternalConnection(self, pin)

class Connection:
    def __init__(self, pin1: Pin, pin2: Pin, length: float, square: float, color: COLOR, internal=False, initialConnected=True):
        assert(isinstance(pin1, Pin))
        assert(isinstance(pin2, Pin))

        self._pin1 = pin1
        self._pin2 = pin2
        self._length = length
        self._square = square
        self._color = color
        self._internal = internal

        if initialConnected:
            self.connect()

    def getPins(self):
        return [self._pin1, self._pin2]


    def setLength(self, length: float):
        self._length = length

    def getLength(self) -> float:
        return self._length

    def setSquare(self, square: float):
        self._square = square

    def getSquare(self) -> float:
        return self._square

    def setColor(self, color: COLOR):
        self._color = color

    def getColor(self) -> COLOR:
        return self._color

    def isInternal(self) -> bool:
        return self._internal

    def getAmperage(self) -> float:
        assert(self._pin1.getAmperage() == self._pin2.getAmperage())
        return self._pin1.getAmperage()

    def _calculateVoltageDrop(self):
        if self.isInternal():
            return 0.0
        else:
            return self.getAmperage() * WIRE_RELATIVE_RESISTANCE * self.getLength() / self.getSquare()

    def updateVoltage(self):
        droppedVoltage = self._calculateVoltageDrop()

        self._pin1.updateVoltage(self._pin2.getVoltage() - droppedVoltage)
        self._pin2.updateVoltage(self._pin1.getVoltage() - droppedVoltage)

    def connect(self):
        if not self._pin1._scheme.isConnectionEnabled(self):
            self._pin1._scheme.addConnection(self)

    def disconnect(self):
        if self._pin1._scheme.isConnectionEnabled(self):
            self._pin1._scheme.removeConnection(self)

    def isConnected(self) -> bool:
        return self._pin1._scheme.isConnectionEnabled(self)


def createInternalConnection(pin1: Pin, pin2: Pin, initialConnected=True):
    return Connection(pin1, pin2, 0, 0, COLOR.Black, True, initialConnected)


class SwitchBase(NamedEntity):
    def __init__(self, name: str):
        super().__init__(name)
        self._connectionMapping: dict[int, list[Connection]] = {}
        self._currentSwitchState: int = -1

    def getPins(self):
        res = set()
        for connections in self._connectionMapping.values():
            for connection in connections:
                res.update(connection.getPins())

        return list(res)

    def createSwitchState(self, positions: list[int], pin1: Pin, pin2: Pin):
        connection = createInternalConnection(pin1, pin2, False)
        for position in positions:
            self._connectionMapping.setdefault(position, []).append(connection)

    def getActiveConnections(self):
        return self._connectionMapping.get(self._currentSwitchState, [])

    def applySwitchState(self, newSwitchState: int):
        if newSwitchState != self._currentSwitchState:
            for connections in self._connectionMapping.values():
                for connection in connections:
                    connection.disconnect()

            newActiveConnections = self._connectionMapping[newSwitchState]
            for connection in newActiveConnections:
                connection.connect()
            self._currentSwitchState = newSwitchState

class Consumer(NamedEntity):
    def __init__(self, scheme: Scheme, name: str, amperage: float):
        super().__init__(name)

        self.plus = Pin(scheme, name + '.плюс', amperage=amperage, consumerPlus=True)
        self.minus = Pin(scheme, name + '.минус', amperage=amperage, consumerMinus=True)
        self.plus._addInternalConnectionTo(self.minus)

    def getAmperage(self):
        return self.plus.getAmperage()

class PowerSource(NamedEntity):
    def __init__(self, scheme, name, voltage):
        super().__init__(name)

        self.plus = Pin(scheme, name + '.плюс', voltage=voltage, powerSourcePlus=True)
        self.minus = Pin(scheme, name + '.минус', powerSourceMinus=True)

    def getVoltage(self):
        return self.plus.getVoltage()
