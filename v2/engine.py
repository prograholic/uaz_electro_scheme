from enum import Enum

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


class Scheme:
    def __init__(self, graph):
        self._graph = graph

    def getGraph(self):
        return self._graph

    def addPin(self, name):
        self._graph.add_node(name)

    def setPinProperty(self, pinName, key, value):
        self._graph.nodes[pinName][key] = value

    def getPinProperty(self, pinName, key):
        return self._graph.nodes[pinName][key]

    def addConnection(self, name1, name2):
        self._graph.add_edge(name1, name2)

    def removeConnection(self, name1, name2):
        self._graph.remove_edge(name1, name2)

    def setConnectionProperty(self, name1, name2, key, value):
        self._graph.edges[name1, name2][key] = value

    def getConnectionProperty(self, name1, name2, key):
        return self._graph.edges[name1, name2][key]



class Connection:
    def __init__(self, pin1, pin2, length, square, color, internal=False, initialConnected=True):
        self._pin1 = pin1
        self._pin2 = pin2
        self._length = length
        self._square = square
        self._color = color
        self._internal = internal

        if initialConnected:
            self.connect()

    def _setProperty(self, key, value):
        self._pin1._scheme.setConnectionProperty(self._pin1.getName(), self._pin2.getName(), key, value)

    def _getProperty(self, key):
        return self._scheme.getConnectionProperty(self._pin1.getName(), self._pin2.getName(), key)

    def setLength(self, length):
        self._setProperty('_length', length)

    def getLength(self):
        return self._getProperty('_length')
    
    def setSquare(self, square):
        self._setProperty('_square', square)

    def getSquare(self):
        return self._getProperty('_square')
    
    def setColor(self, color):
        self._setProperty('color', color.value)

    def getColor(self):
        return self._getProperty('color')
    
    def isInternal(self):
        return self._getProperty('_internal')
    
    def connect(self):
        self.pin1._scheme.addConnection(self.pin1.getName(), self.pin2.getName())
        self.setLength(self._length)
        self.setSquare(self._square)
        self.setColor(self._color)
        self._setProperty('_internal', self._internal)

    def disconnect(self):
        self.pin1._scheme.removeConnection(self.pin1.getName(), self.pin2.getName())

class InternalConnection(Connection):
    def __init__(self, pin1, pin2, initialConnected=True):
        super().__init__(pin1, pin2, 0, 0, COLOR.Black, True, initialConnected)


class Pin:
    pin_names = set()

    def __init__(self, scheme, name):
        if name in self.pin_names:
            raise Exception(f'Pin with name `{name}` already exists')
        else:
            self.pin_names.add(name)

        self._name = name
        self._scheme = scheme
        self._scheme.addPin(name)

    def getName(self):
        return self._name

    def _setProperty(self, key, value):
        self._scheme.setPinProperty(self.getName(), key, value)

    def _getProperty(self, key):
        return self._scheme.getPinProperty(self.getName(), key)

    def addConnectionTo(self, pin, length, square, color):
        return Connection(self, pin, length, square, color)

    def _addInternalConnectionTo(self, pin, initialConnected=True):
        return InternalConnection(self, pin, initialConnected)


class PotentialDiff(Pin):
    def __init__(self, scheme, name):
        super().__init__(scheme, name)

        self._plus = Pin(scheme, name + '.плюс')
        self._minus = Pin(scheme, name + '.минус')

        self._addInternalConnectionTo(self._plus)
        self._addInternalConnectionTo(self._minus)

    def plus(self):
        return self._plus
    
    def minus(self):
        return self._minus

class Consumer(PotentialDiff):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name)
        self.setAmperage(amperage)

    def setAmperage(self, amperage):
        self._setProperty('_amperage', amperage)

    def getAmperage(self):
        return self._getProperty('_amperage')

class PowerSource(PotentialDiff):
    def __init__(self, scheme, name, voltage):
        super().__init__(scheme, name)
        self.setVoltage(voltage)

    def setVoltage(self, voltage):
        self._setProperty('_voltage', voltage)

    def getVoltage(self):
        return self._getProperty('_voltage')

