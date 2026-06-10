import engine
import elements.generic_car_elements



class Ignition:
    pass


class WipersRelay(engine.RelayBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)
        self._31b = engine.Pin(scheme, name + '.31b')
        self._15 = engine.Pin(scheme, name + '.15')
        self.s = engine.Pin(scheme, name + '.S')
        self._86 = engine.Pin(scheme, name + '.86')
        self.j = engine.Pin(scheme, name + '.J')
        self._31 = engine.Pin(scheme, name + '.31')

        self._coil1 = engine.Consumer(scheme, name + '.coil1', 0.2)
        self._coil2 = engine.Consumer(scheme, name + '.coil2', 0.2)

        self._86.addStaticInternalConnection(self._coil1.plus)
        self.j.addStaticInternalConnection(self._coil2.plus)
        coil1MinusConnection = self._coil1.minus.addStaticInternalConnection(self._31)
        coil2MinusConnection = self._coil2.minus.addStaticInternalConnection(self._31)

        self.addRelayConnection(self.s, self._31b, coil1MinusConnection, connectWhenUnpowered=True)
        self.addRelayConnection(self._15, self.s, coil2MinusConnection)


class LightSwitch(elements.generic_car_elements.ManualSwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)

        self._30 = engine.Pin(scheme, name + '.30')
        self._58 = engine.Pin(scheme, name + '.58')
        self.x = engine.Pin(scheme, name + '.x')
        self._56 = engine.Pin(scheme, name + '.56')

        self.createSwitchState([1, 2], self._30, self._58)
        self.createSwitchState([2], self.x, self._56)


class EmergencyLightSwitch(elements.generic_car_elements.ManualSwitchBase):
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


class TurnSignalRelay950(engine.RelayBase):
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

        self._coil_r = engine.Consumer(scheme, name + '.coil_r', 0.2)
        self._coil_l = engine.Consumer(scheme, name + '.coil_l', 0.2)
        self._kt_right_helper = engine.Pin(scheme, name + '.kt_right_helper')
        self._kt_left_helper = engine.Pin(scheme, name + '.kt_left_helper')

        coilRMinusConnection = self._coil_r.minus.addStaticInternalConnection(self.minus)
        coilLMinusConnection = self._coil_l.minus.addStaticInternalConnection(self.minus)

        self.plus.addStaticInternalConnection(self.p)
        self.plus.addStaticInternalConnection(self._kt_right_helper)
        self.plus.addStaticInternalConnection(self._kt_left_helper)
        self.pb.addStaticInternalConnection(self._coil_r.plus)
        self.lb.addStaticInternalConnection(self._coil_l.plus)

        self.addRelayConnection(self.plus, self.left, coilLMinusConnection)
        self.addRelayConnection(self.plus, self.right, coilRMinusConnection)

        self.addRelayConnection(self._kt_right_helper, self.kt, coilRMinusConnection)
        self.addRelayConnection(self._kt_left_helper, self.kt, coilLMinusConnection)


class LeftSteeringColumnTurnSignalSwitch(elements.generic_car_elements.ManualSwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)
        self._49ar = engine.Pin(scheme, name + '.49aR')
        self._49a = engine.Pin(scheme, name + '.49a')
        self._49al = engine.Pin(scheme, name + '.49aL')

        self.createSwitchState([1], self._49a, self._49ar)
        self.createSwitchState([2], self._49a, self._49al)


class RightSteeringColumnSwitch(elements.generic_car_elements.ManualSwitchBase):
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

class LeftSteeringColumnLightSwitch(elements.generic_car_elements.ManualSwitchBase):
    def __init__(self, scheme: engine.Scheme, name: str):
        super().__init__(name)

        self._56 = engine.Pin(scheme, name + '.56')
        self._56b = engine.Pin(scheme, name + '.56b')
        self._56a = engine.Pin(scheme, name + '.56a')
        self._30 = engine.Pin(scheme, name + '.30')

        self.createSwitchState([0, 1, 2], self._56, self._56b)
        self.createSwitchState([1], self._56, self._56a)
        self.createSwitchState([2], self._30, self._56a)
