import engine




class PotentialDiff(engine.Pin):
    def __init__(self, scheme, name):
        super().__init__(scheme, name)

        self.plus = engine.Pin(scheme, name + '.плюс')
        self.minus = engine.Pin(scheme, name + '.минус')

        self._addInternalConnectionTo(self.plus)
        self._addInternalConnectionTo(self.minus)


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


class Akb(PowerSource):
    def __init__(self, scheme, name, voltage):
        super().__init__(scheme, name, voltage)



class Light(Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage)


class SimpleSwitch(engine.Switch):
    def __init__(self, name: str, pin1: engine.Pin, pin2: engine.Pin, connected:bool=False):

        connection = engine.createInternalConnection(pin1, pin2, False)
        connections = {
            0: [],
            1: [connection]
        }

        super().__init__(name, connections, 1 if connected else 0)


        

class Relay(Consumer):
    def __init__(self, scheme, name, coilAmperage=0.2):
        super().__init__(scheme, name, coilAmperage)
        self._30 = engine.Pin(scheme, name + '.30')
        self._85 = engine.Pin(scheme, name + '.85')
        self._86 = engine.Pin(scheme, name + '.86')
        self._87 = engine.Pin(scheme, name + '.87')

        self._85._addInternalConnectionTo(self.plus)
        self._86._addInternalConnectionTo(self.minus)

        self._relay_switch = SimpleSwitch(name + ".relay_switch", self._30, self._87)



class Starter(Consumer):
    def __init__(self, scheme, name, engineAmperage, solenoidAmperage):
        self.solenoid = Consumer(scheme, name + ".втяг. реле", solenoidAmperage)


class Sensor(SimpleSwitch):
    def __init__(self, name, pin1, pin2, connected=False):
        super().__init__(name, pin1, pin2, connected)
