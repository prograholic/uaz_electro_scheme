import engine
import elements.generic_car_elements



class Ignition:
    pass


class WipersRelay(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)
        self._31b = engine.Pin(scheme, name + '.31b')
        self._15 = engine.Pin(scheme, name + '.15')
        self.s = engine.Pin(scheme, name + '.S')
        self._86 = engine.Pin(scheme, name + '.86')
        self.j = engine.Pin(scheme, name + '.J')
        self._31 = engine.Pin(scheme, name + '.31')

        self._coil1 = elements.generic_car_elements.Consumer(scheme, name + '.coil1', 0.2)
        self._coil2 = elements.generic_car_elements.Consumer(scheme, name + '.coil2', 0.2)

        self._86._addInternalConnectionTo(self._coil1.plus)
        self.j._addInternalConnectionTo(self._coil2.plus)
        self._coil1.minus._addInternalConnectionTo(self._31)
        self._coil2.minus._addInternalConnectionTo(self._31)

        self.createSwitchState([0], self.s, self._31b)
        self.createSwitchState([1], self._15, self.s)

class LightSwitch(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)

        self._30 = engine.Pin(scheme, name + '.30')
        self._58 = engine.Pin(scheme, name + '.58')
        self.x = engine.Pin(scheme, name + '.x')
        self._56 = engine.Pin(scheme, name + '.56')

        self.createSwitchState([1, 2], self._30, self._58)
        self.createSwitchState([2], self.x, self._56)


class EmergencyLightSwitch(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)
        self.pb = engine.Pin(scheme, name + '.ПБ (7)')
        self.p = engine.Pin(scheme, name + '.П (1)')
        self.lb = engine.Pin(scheme, name + '.ЛБ (3)')
        self.pow = engine.Pin(scheme, name + '.пов (2)')
        self.plus = engine.Pin(scheme, name + '.+ (4)')
        self.emer = engine.Pin(scheme, name + '.авар (8)')

        self.createSwitchState([0], self.pow, self.plus)
        self.createSwitchState([1], self.emer, self.plus)
        self.createSwitchState([1], self.p, self.pb)
        self.createSwitchState([1], self.p, self.lb)


class TurnSignalRelay950(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)
        self.plus = engine.Pin(scheme, name + '.+')
        self.minus = engine.Pin(scheme, name + '.-')
        self.p = engine.Pin(scheme, name + '.П')
        self.pb = engine.Pin(scheme, name + '.ПБ')
        self.lb = engine.Pin(scheme, name + '.ЛБ')
        self.kt = engine.Pin(scheme, name + '.КТ')
        self.left = engine.Pin(scheme, name + '.Лев (ЛТ)')
        self.right = engine.Pin(scheme, name + '.Прав (ПТ)')
        self.coil_r = elements.generic_car_elements.Consumer(scheme, name + '.coil_r', 0.2)
        self.coil_l = elements.generic_car_elements.Consumer(scheme, name + '.coil_l', 0.2)

        self.coil_r.minus._addInternalConnectionTo(self.minus)
        self.coil_l.minus._addInternalConnectionTo(self.minus)

        self.plus._addInternalConnectionTo(self.p)
        self.pb._addInternalConnectionTo(self.coil_r.plus)
        self.lb._addInternalConnectionTo(self.coil_l.plus)

        self.createSwitchState([1], self.plus, self.left)
        self.createSwitchState([2], self.plus, self.right)
        self.createSwitchState([1, 2], self.plus, self.kt)

class LeftSteeringColumnTurnSignalSwitch(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)
        self._49ar = engine.Pin(scheme, name + '.49aR')
        self._49a = engine.Pin(scheme, name + '.49a')
        self._49al = engine.Pin(scheme, name + '.49aL')

        self.createSwitchState([1], self._49a, self._49ar)
        self.createSwitchState([2], self._49a, self._49al)

class RightSteeringColumnSwitch(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)
        self._53e = engine.Pin(scheme, name + '.53e')
        self._53 = engine.Pin(scheme, name + '.53')
        self._53a = engine.Pin(scheme, name + '.53a')
        self.j = engine.Pin(scheme, name + '.J')
        self._53b = engine.Pin(scheme, name + '.53b')
        self._53ah = engine.Pin(scheme, name + '.53ah')
        self.w = engine.Pin(scheme, name + '.W')
        self._53h = engine.Pin(scheme, name + '.53h')
        self.wh = engine.Pin(scheme, name + '.WH')

        self.createSwitchState([0, 1, 2, 8], self._53e, self._53)
        self.createSwitchState([1, 2], self._53a, self.j)
        self.createSwitchState([3], self._53a, self._53)
        self.createSwitchState([4], self._53a, self._53b)
        self.createSwitchState([6, 7], self._53ah, self.wh)
        self.createSwitchState([7], self._53ah, self._53h)
        self.createSwitchState([8], self._53ah, self.w)

class LeftSteeringColumnLightSwitch(engine.SwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)

        self._56 = engine.Pin(scheme, name + '.56')
        self._56b = engine.Pin(scheme, name + '.56b')
        self._56a = engine.Pin(scheme, name + '.56a')
        self._30 = engine.Pin(scheme, name + '.30')

        self.createSwitchState([0, 1, 2], self._56, self._56b)
        self.createSwitchState([1], self._56, self._56a)
        self.createSwitchState([2], self._30, self._56a)
