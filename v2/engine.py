from enum import Enum
from typing import Self
from networkx import Graph

class COLOR(Enum):
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


class SwitchManager:
    def __init__(self):
        pass



class Scheme:
    def __init__(self, graph: Graph, switchManager: SwitchManager):
        self._graph = graph
        self._switchManager = switchManager

    def getGraph(self) -> Graph:
        return self._graph
    
    def getSwitchManager(self) -> SwitchManager:
        return self._switchManager

    def addPin(self, name: str):
        self._graph.add_node(name)

    def setPinProperty(self, pinName: str, key: str, value):
        self._graph.nodes[pinName][key] = value

    def getPinProperty(self, pinName: str, key: str):
        return self._graph.nodes[pinName][key]

    def addConnection(self, name1: str, name2: str):
        self._graph.add_edge(name1, name2)

    def removeConnection(self, name1: str, name2: str):
        self._graph.remove_edge(name1, name2)

    def hasConnection(self, name1: str, name2: str) -> bool:
        return self._graph.has_edge(name1, name2)

    def setConnectionProperty(self, name1: str, name2: str, key: str, value):
        self._graph.edges[name1, name2][key] = value

    def getConnectionProperty(self, name1: str, name2: str, key: str):
        return self._graph.edges[name1, name2][key]

class Pin:
    def __init__(self, scheme: Scheme, name: str):
        self._name = name
        self._scheme = scheme
        self._scheme.addPin(name)

    def getName(self):
        return self._name

    def _setProperty(self, key: str, value):
        self._scheme.setPinProperty(self.getName(), key, value)

    def _getProperty(self, key: str):
        return self._scheme.getPinProperty(self.getName(), key)

    def addConnectionTo(self, pin: Self, length: float, square: float, color: COLOR):
        return Connection(self, pin, length, square, color)

    def _addInternalConnectionTo(self, pin: Self):
        return createInternalConnection(self, pin)

class Connection:
    def __init__(self, pin1: Pin, pin2: Pin, length: float, square: float, color: COLOR, internal=False, initialConnected=True):
        self._pin1 = pin1
        self._pin2 = pin2
        self._length = length
        self._square = square
        self._color = color
        self._internal = internal

        if initialConnected:
            self.connect()

    def _setProperty(self, key: str, value):
        self._pin1._scheme.setConnectionProperty(self._pin1.getName(), self._pin2.getName(), key, value)

    def _getProperty(self, key: str):
        return self._pin1._scheme.getConnectionProperty(self._pin1.getName(), self._pin2.getName(), key)

    def setLength(self, length: float):
        self._setProperty('_length', length)

    def getLength(self) -> float:
        return self._getProperty('_length')
    
    def setSquare(self, square: float):
        self._setProperty('_square', square)

    def getSquare(self) -> float:
        return self._getProperty('_square')
    
    def setColor(self, color: COLOR):
        self._setProperty('color', color.value)

    def getColor(self) -> COLOR:
        return self._getProperty('color')
    
    def isInternal(self) -> bool:
        return self._getProperty('_internal')
    
    def connect(self):
        self._pin1._scheme.addConnection(self._pin1.getName(), self._pin2.getName())
        self.setLength(self._length)
        self.setSquare(self._square)
        self.setColor(self._color)
        self._setProperty('_internal', self._internal)

    def disconnect(self):
        if self._pin1._scheme.hasConnection(self._pin1.getName(), self._pin2.getName()):
            self._pin1._scheme.removeConnection(self._pin1.getName(), self._pin2.getName())

    def isConnected(self) -> bool:
        return self._pin1._scheme.hasConnection(self._pin1.getName(), self._pin2.getName())

def createInternalConnection(pin1: Pin, pin2: Pin, initialConnected=True):
    return Connection(pin1, pin2, 0, 0, COLOR.Black, True, initialConnected)

class SwitchBase:
    def __init__(self, name: str, connectionMapping: dict[int, list[Connection]], currentSwitchState: int = 0):
        self._name = name
        self._connectionMapping = connectionMapping
        self._currentSwitchState = -1

        self.applySwitchState(currentSwitchState)

    def applySwitchState(self, newSwitchState: int):
        if newSwitchState != self._currentSwitchState:
            for connections in self._connectionMapping.values():
                for connection in connections:
                    connection.disconnect()

            newActiveConnections = self._connectionMapping[newSwitchState]
            for connection in newActiveConnections:
                connection.connect()
            self._currentSwitchState = newSwitchState
