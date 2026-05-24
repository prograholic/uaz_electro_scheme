import engine


class Akb(engine.PowerSource):
    def __init__(self, scheme, name, voltage):
        super().__init__(scheme, name, voltage)



class Light(engine.Consumer):
    def __init__(self, scheme, name, amperage):
        super().__init__(scheme, name, amperage)



        

class Relay:
    def __init__(self, scheme, name, coilAmperage=0.2):
        self._coil = engine.Consumer(scheme, name + '.coil', coilAmperage)
        self._30 = engine.Pin(scheme, name + '.30')
        self._85 = engine.Pin(scheme, name + '.85')
        self._86 = engine.Pin(scheme, name + '.86')
        self._87 = engine.Pin(scheme, name + '.87')

        self._85._addInternalConnectionTo(self._coil.plus)
        self._86._addInternalConnectionTo(self._coil.minus)

        self._30._addInternalConnectionTo(self._87, False)


class Starter:
    def __init__(self, scheme, name, engineAmperage, solenoidAmperage):
        self.engine = engine.Consumer(scheme, name + '.двигатель', engineAmperage)
        self.solenoid = engine.Consumer(scheme, name + ".втяг. реле", solenoidAmperage)
