import engine


class Akb(engine.PowerSource):
    def __init__(self, scheme, name, voltage):
        super().__init__(scheme, name, voltage)



class Light(engine.Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage)


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
        self._coil = engine.Consumer(scheme, name + '.coil', coilAmperage)

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
        self._coil = engine.Consumer(scheme, name + '.coil', coilAmperage)

        self._85._addInternalConnectionTo(self._coil.plus)
        self._86._addInternalConnectionTo(self._coil.minus)

        self.createSwitchState([0], self._30, self._88)
        self.createSwitchState([1], self._30, self._87)



class Starter(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str, engineAmperage: float, solenoidAmperage: float):
        super().__init__(name)
        self.st_relay = engine.Consumer(scheme, name + ".втяг. реле", solenoidAmperage)
        self.st = engine.Pin(scheme, name + ".втяг")
        self.st._addInternalConnectionTo(self.st_relay.plus)

        self.eng = engine.Consumer(scheme, name + ".двигатель", engineAmperage)
        self.plus = engine.Pin(scheme, name + ".плюс")
        self.createSwitchState([1], self.eng.plus, self.plus)

        self.g = engine.Pin(scheme, name + ".минус")
        self.g._addInternalConnectionTo(self.eng.minus)
        self.g._addInternalConnectionTo(self.st_relay.minus)




class Sensor(SimpleSwitch):
    def __init__(self, scheme, name):
        super().__init__(scheme, name)

class Generator(engine.PowerSource):
    def __init__(self, scheme, name, voltage, vAmperage):
        super().__init__(scheme, name, voltage)
        self.v = engine.Consumer(scheme, name + '.возбуждение', vAmperage)
        self.v.minus._addInternalConnectionTo(self.minus)

    def getPins(self):
        res = super().getPins()
        res.extend(self.v.getPins())

        return res

class Winch(engine.Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage)

class Fan(engine.Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage)

class CarHorn(engine.Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage)

class ElectricPump(engine.Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage)

class Fuse(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str, amperage: float):
        super().__init__(name)
        self._amperage = amperage
        self.pin1 = engine.Pin(scheme, name + '.pin1')
        self.pin2 = engine.Pin(scheme, name + '.pin2')

        self.createSwitchState([0], self.pin1, self.pin2)

class Heater(engine.Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage)

class Resistor(SimpleSwitch):
    def __init__(self, scheme: engine.Scheme, name: str, resistance: float):
        super().__init__(scheme, name)
        self._resistance = float
        self.pin1 = engine.Pin(scheme, name + '.pin1')
        self.pin2 = engine.Pin(scheme, name + '.pin2')

        self.createSwitchState([0], self.pin1, self.pin2)

class Wipers(engine.Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage)

        self._1 = engine.Pin(scheme, name + '.1')
        self._2 = engine.Pin(scheme, name + '.2')
        self._3 = engine.Pin(scheme, name + '.3')
        self._4 = engine.Pin(scheme, name + '.4')
        self._5 = engine.Pin(scheme, name + '.5')
        self._6 = engine.Pin(scheme, name + '.6')

class WindshieldWasher(engine.Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage)

class Gauge(engine.Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage)

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
