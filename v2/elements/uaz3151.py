import engine
import elements.generic_car_elements



class Ignition:
    pass


class WipersRelay(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)
        self._31b = engine.Pin(scheme, name + '.31b')
        self._15 = engine.Pin(scheme, name + '.15')
        self.S = engine.Pin(scheme, name + '.S')
        self._86 = engine.Pin(scheme, name + '.86')
        self.J = engine.Pin(scheme, name + '.J')
        self._31 = engine.Pin(scheme, name + '.31')

        self._coil1 = elements.generic_car_elements.Consumer(scheme, name + 'coil1', 0.2)
        self._coil2 = elements.generic_car_elements.Consumer(scheme, name + 'coil2', 0.2)

        self._86._addInternalConnectionTo(self._coil1.plus)
        self.J._addInternalConnectionTo(self._coil2.plus)
        self._coil1.minus._addInternalConnectionTo(self._31)
        self._coil2.minus._addInternalConnectionTo(self._31)
        
        self.createConnection(0, self.S, self._31b)
        self.createConnection(1, self._15, self.S)

class LightSwitch(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)

        self._30 = engine.Pin(scheme, name + '.30')
        self._58 = engine.Pin(scheme, name + '.58')
        self.x = engine.Pin(scheme, name + '.x')
        self._56 = engine.Pin(scheme, name + '.56')

        c12 = self.createConnection(1, self._30, self._58)
        self._connectionMapping.setdefault(2, []).append(c12)

        self.createConnection(2, self.x, self._56)


class EmergencyLightSwitch(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)
        self.pb = engine.Pin(scheme, name + '.ПБ (7)')
        self.p = engine.Pin(scheme, name + '.П (1)')
        self.lb = engine.Pin(scheme, name + '.ЛБ (3)')
        self.pow = engine.Pin(scheme, name + '.пов (2)')
        self.plus = engine.Pin(scheme, name + '.+ (4)')
        self.emer = engine.Pin(scheme, name + '.авар (8)')

        self.createConnection(0, self.pow, self.plus)
        self.createConnection(1, self.emer, self.plus)
        self.createConnection(1, self.p, self.pb)
        self.createConnection(1, self.p, self.lb)
