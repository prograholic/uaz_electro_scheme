from enum import StrEnum
from typing import Iterable
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


# Превышение этого значения фактически означает, что цепь разомкнута
MAX_RESISTANCE = 1e10
DEFAULT_VOLTAGE = 12.0
DEFAULT_RELAY_ACTIVATION_VOLTAGE = 6.0


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


class PinBase(NamedEntity):
    def __init__(self, scheme: Scheme, name: str, voltage: float = -1.0):
        super().__init__(name)
        self._scheme = scheme
        self._voltage = voltage
        self._scheme.addPin(self)

    def getVoltage(self) -> float:
        return self._voltage

    def updateVoltage(self, newVoltage: float) -> bool:
        if newVoltage > self._voltage:
            self._voltage = newVoltage
            return True

        return False

    def isGroundPin(self) -> bool:
        return False

    def getPins(self):
        return [self]


class ConnectionBase:
    def __init__(self, pin1: PinBase, pin2: PinBase):
        assert(isinstance(pin1, PinBase))
        assert(isinstance(pin2, PinBase))

        self._pin1 = pin1
        self._pin2 = pin2

        self._pin1._scheme.addConnection(self)

    def getPins(self):
        return [self._pin1, self._pin2]

    def isInternal(self) -> bool:
        raise Exception('isInternal should be implemented in child classes')

    def isDynamicConnection(self) -> bool:
        raise Exception('isDynamicConnection should be implemented in child classes')

    def isManualSwitchConnection(self) -> bool:
        raise Exception('isManualSwitchConnection should be implemented in child classes')

    def getResistance(self) -> float:
        raise Exception('getResistance should be implemented in child classes')

    def getAmperage(self) -> float:
        raise Exception('getAmperage should be implemented in child classes')

    def calculateVoltageDrop(self):
        return self.getAmperage() * self.getResistance()

class StaticConnection(ConnectionBase):
    def __init__(self, pin1: PinBase, pin2: PinBase):
        super().__init__(pin1, pin2)

    def isConnected(self) -> bool:
        return True

    def isDynamicConnection(self) -> bool:
        return False

    def isManualSwitchConnection(self) -> bool:
        raise Exception('isManualSwitchConnection should not be called for static connections')


class WireConnection(StaticConnection):
    def __init__(self, pin1: PinBase, pin2: PinBase, length: float, square: float, color: COLOR):
        super().__init__(pin1, pin2)
        self._length = length
        self._square = square
        self._color = color

    def isInternal(self) -> bool:
        return False

    def getLength(self) -> float:
        return self._length

    def getSquare(self) -> float:
        return self._square

    def getColor(self) -> COLOR:
        return self._color

    def getResistance(self) -> float:
        return WIRE_RELATIVE_RESISTANCE * self.getLength() / self.getSquare()

    def getAmperage(self) -> float:
        raise Exception('Not implemeted yet')
        #assert(self._pin1.getAmperage() == self._pin2.getAmperage())
        #return self._pin1.getAmperage()


class StaticInternalConnection(StaticConnection):
    def __init__(self, pin1: PinBase, pin2: PinBase):
        super().__init__(pin1, pin2)

    def isInternal(self):
        return True

    def getResistance(self) -> float:
        return 0.0


class Pin(PinBase):
    def __init__(self, scheme: Scheme, name: str, voltage: float = -1.0):
        super().__init__(scheme, name, voltage)

    def addWireConnectionTo(self, pin: PinBase, length: float, square: float, color: COLOR):
        return WireConnection(self, pin, length, square, color)

    def addStaticInternalConnection(self, pin: PinBase):
        return StaticInternalConnection(self, pin)


class DynamicConnectionBase(ConnectionBase):
    def __init__(self, pin1: PinBase, pin2: PinBase, connected: bool):
        super().__init__(pin1, pin2)
        self._connected = connected

    def isInternal(self):
        return True

    def isDynamicConnection(self) -> bool:
        return True

    def isConnected(self) -> bool:
        return self._connected

    def connect(self):
        # если были выключены, то должны вернуть True, т.к. состояние меняется
        res = not self._connected
        self._connected = True
        return res

    def disconnect(self):
        # если были включены, то должны вернуть True, т.к. состояние меняется
        res = self._connected
        self._connected = False
        return res

    def getResistance(self) -> float:
        if not self.isConnected():
            return MAX_RESISTANCE

        return self._getResistanceWhenConnected()

    def _getResistanceWhenConnected(self) -> float:
        raise Exception('_getResistanceWhenConnected should be implemented in child classes')

    def updateState(self) -> bool:
        raise Exception('updateState should be implemented in child classes')



class ManualSwitchConnection(DynamicConnectionBase):
    def __init__(self, pin1: PinBase, pin2: PinBase, connected: bool):
        super().__init__(pin1, pin2, connected)

    def isManualSwitchConnection(self) -> bool:
        return True

    def _getResistanceWhenConnected(self) -> float:
        return 0.0


class StaticConsumerConnection(StaticInternalConnection):
    def __init__(self, pin1: PinBase, pin2: PinBase, amperage: float):
        super().__init__(pin1, pin2)
        self._amperage = amperage

    def getAmperage(self) -> float:
        return self._amperage

    def getResistance(self) -> float:
        return DEFAULT_VOLTAGE / self.getAmperage()


class Consumer(NamedEntity):
    def __init__(self, scheme: Scheme, name: str, amperage: float):
        super().__init__(name)

        self.plus = Pin(scheme, name + '.плюс')
        self.minus = Pin(scheme, name + '.минус')
        self._connection = StaticConsumerConnection(self.plus, self.minus, amperage)

    def getAmperage(self):
        return self._connection.getAmperage()


class StaticPowerSourceConnection(StaticInternalConnection):
    def __init__(self, pin1: PinBase, pin2: PinBase):
        super().__init__(pin1, pin2)

    def getResistance(self) -> float:
        # Фактически, нет соединения
        return MAX_RESISTANCE


class RelaySwitchConnection(DynamicConnectionBase):
    def __init__(self, pin1: PinBase, pin2: PinBase, coil: Consumer, activationVoltage: float=DEFAULT_RELAY_ACTIVATION_VOLTAGE, connectWhenUnpowered: bool=False):
        super().__init__(pin1, pin2, connectWhenUnpowered)
        self._coil = coil
        self._activationVoltage = activationVoltage
        self._connectWhenUnpowered = connectWhenUnpowered

    def isManualSwitchConnection(self) -> bool:
        return False

    def getCoilAmperage(self) -> float:
        return self._coil.getAmperage()

    def _getResistanceWhenConnected(self) -> float:
        return DEFAULT_VOLTAGE / self.getCoilAmperage()

    def updateState(self) -> bool:
        shouldConnect = False
        if self._connectWhenUnpowered:
            shouldConnect = self._coil.getVoltage() < self._activationVoltage
        else:
            shouldConnect = self._coil.getVoltage() > self._activationVoltage
        if shouldConnect:
            return self.connect()
        else:
            return self.disconnect()


class SwitchBase(NamedEntity):
    def __init__(self, name):
        super().__init__(name)

    def getConnections(self) -> Iterable[ConnectionBase]:
        raise Exception('getConnections should be implemented in child classes')

    def getPins(self):
        res = set()
        for connection in self.getConnections():
            res.update(connection.getPins())

        return list(res)


class RelayBase(SwitchBase):
    def __init__(self, name):
        super().__init__(name)
        self._connections: list[RelaySwitchConnection] = []

    def getConnections(self) -> Iterable[RelaySwitchConnection]:
        return self._connections

    def addRelayConnection(self, pin1: PinBase, pin2: PinBase, coil: Consumer, activationVoltage: float=DEFAULT_RELAY_ACTIVATION_VOLTAGE, connectWhenUnpowered: bool=False):
        self._connections.append(RelaySwitchConnection(pin1, pin2, coil, activationVoltage, connectWhenUnpowered))



class FuseConnection(DynamicConnectionBase):
    def __init__(self, pin1: PinBase, pin2: PinBase, maxAmperage: float):
        super().__init__(pin1, pin2, True)
        self._maxAmperage = maxAmperage

    def isManualSwitchConnection(self) -> bool:
        return True

    def updateState(self) -> bool:
        if self.getAmperage() > self._maxAmperage:
            print(f'Fuse {self._pin1.getName()}-{self._pin2.getName()} blowed, amperage {self.getAmperage()}, max amperage {self._maxAmperage}')
            self.disconnect()


class GroundPin(Pin):
    def __init__(self, scheme, name):
        super().__init__(scheme, name)

    def isGroundPin(self) -> bool:
        return True

class PlusPin(Pin):
    def __init__(self, scheme: Scheme, name: str, voltage: float):
        super().__init__(scheme, name, voltage)


class PowerSource(NamedEntity):
    def __init__(self, scheme, name, voltage):
        super().__init__(name)

        self.plus = PlusPin(scheme, name + '.плюс', voltage)
        self.minus = GroundPin(scheme, name + '.минус')
        self._connection = StaticPowerSourceConnection(self.plus, self.minus)

    def getVoltage(self):
        return self.plus.getVoltage()
