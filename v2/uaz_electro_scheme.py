from networkx import Graph
from engine import Scheme, SwitchManager, Pin, COLOR

from elements.generic_car_elements import Akb, Light, Relay, Starter, SimpleSwitch, Consumer

graph = Graph()
sm = SwitchManager()
uaz = Scheme(graph, sm)

ground = Pin(uaz, "Масса (кузов)")
akb = Akb(uaz, "Аккумулятор", 12.0)

ground_switch = SimpleSwitch("Размыкатель массы", ground, akb.minus)

starter = Starter(uaz, "Стартер", 300, 20)

generator = Generator(uaz, "Генератор")

ignition_input_pin = Pin(uaz, "Разветвитель для питания катушек зажигания")
ignition_coil_1 = Consumer(uaz, "Катушка 1", 8)
ignition_coil_2 = Consumer(uaz, "Катушка 2", 8)

winch = Consumer(uaz, "Лебедка", 300)

coolant_fan_1 = Consumer(uaz, "Э-вент охл ДВС 1", 8)
coolant_fan_2 = Consumer(uaz, "Э-вент охл ДВС 2", 8)


coolant_sensor = Sensor(uaz, "Датчик вкл э-вент охл ДВС")
engine_overheat_sensor = Sensor(uaz, "Датчик перегрева охлаждающей жидкости")
engine_temp_sensor = Sensor("Датчик температуры охлаждающей жидкости")
