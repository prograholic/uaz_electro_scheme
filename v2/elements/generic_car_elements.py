import engine

class PotentialDiff(engine.Pin):
    def __init__(self, scheme, name, category='PotentialDiff'):
        super().__init__(scheme, name, category)

        self.plus = engine.Pin(scheme, name + '.плюс')
        self.minus = engine.Pin(scheme, name + '.минус')

        self._addInternalConnectionTo(self.plus)
        self._addInternalConnectionTo(self.minus)

    def getPins(self):
        return [self, self.plus, self.minus]

class Consumer(PotentialDiff):
    def __init__(self, scheme, name, amperage, category: str ='Consumer'):
        super().__init__(scheme, name, category)
        self.setAmperage(amperage)

    def setAmperage(self, amperage):
        self._setProperty('_amperage', amperage)

    def getAmperage(self):
        return self._getProperty('_amperage')

class PowerSource(PotentialDiff):
    def __init__(self, scheme, name, voltage, category: str ='PowerSource'):
        super().__init__(scheme, name, category)
        self.setVoltage(voltage)

    def setVoltage(self, voltage):
        self._setProperty('_voltage', voltage)

    def getVoltage(self):
        return self._getProperty('_voltage')


class Akb(PowerSource):
    def __init__(self, scheme, name, voltage):
        super().__init__(scheme, name, voltage, category='Akb')



class Light(Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage, category='Light')


class SimpleSwitch(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)
        self.pin1 = engine.Pin(scheme, name + '.pin1')
        self.pin2 = engine.Pin(scheme, name + '.pin2')

        self.createSwitchState([1], self.pin1, self.pin2)

    def on(self):
        self.applySwitchState(1)

    def off(self):
        self.applySwitchState(0)

class Relay(engine.SwitchBase):
    def __init__(self, scheme, name, coilAmperage=0.2):
        super().__init__(name)
        self._30 = engine.Pin(scheme, name + '.30')
        self._85 = engine.Pin(scheme, name + '.85')
        self._86 = engine.Pin(scheme, name + '.86')
        self._87 = engine.Pin(scheme, name + '.87')
        self._coil = Consumer(scheme, name + '.coil', coilAmperage)

        self._85._addInternalConnectionTo(self._coil.plus)
        self._86._addInternalConnectionTo(self._coil.minus)

        self.createSwitchState([1], self._30, self._87)

class Relay5(engine.SwitchBase):
    def __init__(self, scheme, name, coilAmperage=0.2):
        super().__init__(name)
        self._30 = engine.Pin(scheme, name + '.30')
        self._85 = engine.Pin(scheme, name + '.85')
        self._86 = engine.Pin(scheme, name + '.86')
        self._87 = engine.Pin(scheme, name + '.87')
        self._88 = engine.Pin(scheme, name + '.88')
        self._coil = Consumer(scheme, name + '.coil', coilAmperage)

        self._85._addInternalConnectionTo(self._coil.plus)
        self._86._addInternalConnectionTo(self._coil.minus)

        self.createSwitchState([0], self._30, self._88)
        self.createSwitchState([1], self._30, self._87)



class Starter(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str, engineAmperage: float, solenoidAmperage: float):
        super().__init__(name)
        self.st_relay = Consumer(scheme, name + ".втяг. реле", solenoidAmperage)
        self.st = engine.Pin(scheme, name + ".втяг")
        self.st._addInternalConnectionTo(self.st_relay.plus)

        self.eng = Consumer(scheme, name + ".двигатель", engineAmperage)
        self.plus = engine.Pin(scheme, name + ".плюс")
        self.createSwitchState([1], self.eng.plus, self.plus)

        self.g = engine.Pin(scheme, name + ".минус")
        self.g._addInternalConnectionTo(self.eng.minus)
        self.g._addInternalConnectionTo(self.st_relay.minus)




class Sensor(SimpleSwitch):
    def __init__(self, scheme, name):
        super().__init__(scheme, name)

class Generator(PowerSource):
    def __init__(self, scheme, name, voltage, vAmperage):
        super().__init__(scheme, name, voltage)
        self.v = Consumer(scheme, name + ".возбуждение", vAmperage)
        self.v.minus._addInternalConnectionTo(self.minus)

    def getPins(self):
        res = super().getPins()
        res.extend(self.v.getPins())

        return res

class Winch(Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage, category='Winch')

class Fan(Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage, category='Fan')

class CarHorn(Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage, category='CarHorn')

class ElectricPump(Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage, category='ElectricPump')

class Fuse(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str, amperage: float):
        super().__init__(name)
        self._amperage = amperage
        self.pin1 = engine.Pin(scheme, name + '.pin1')
        self.pin2 = engine.Pin(scheme, name + '.pin2')

        self.createSwitchState([0], self.pin1, self.pin2)

class Heater(Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage, category='Heater')

class Resistor(SimpleSwitch):
    def __init__(self, scheme: engine.Scheme, name: str, resistance: float):
        super().__init__(scheme, name)
        self._resistance = float
        self.pin1 = engine.Pin(scheme, name + '.pin1')
        self.pin2 = engine.Pin(scheme, name + '.pin2')

        self.createSwitchState([0], self.pin1, self.pin2)

class Wipers(Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage, category='Wipers')

        self._1 = engine.Pin(scheme, name + '.1')
        self._2 = engine.Pin(scheme, name + '.2')
        self._3 = engine.Pin(scheme, name + '.3')
        self._4 = engine.Pin(scheme, name + '.4')
        self._5 = engine.Pin(scheme, name + '.5')
        self._6 = engine.Pin(scheme, name + '.6')

class WindshieldWasher(Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage, category='WindshieldWasher')

class Gauge(Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage, category='Gauge')

class Switch3States6Pins(engine.SwitchBase):
    def __init__(self, scheme, name):
        super().__init__(name)
        self.d = engine.Pin(scheme, name + '.D')
        self.i = engine.Pin(scheme, name + '.I')
        self.u = engine.Pin(scheme, name + '.U')
        self.v = engine.Pin(scheme, name + '.V')
        self.l = engine.Pin(scheme, name + '.L')
        self.h = engine.Pin(scheme, name + '.H')

        self.createSwitchState([1], self.i, self.d)
        self.createSwitchState([2], self.i, self.u)

        self.createSwitchState([1], self.v, self.l)
        self.createSwitchState([2], self.l, self.h)
