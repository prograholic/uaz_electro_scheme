#Стартер, генератор, зажигание
!element es.starter.eng {
    properties {
        amper 300
    }
}
!element es.starter.st_relay {
    properties {
        # Кратковременный потребитель
        max_voltage_drop 0.75
        amper 20
    }
}
!element es.generator.v {
    properties {
        amper 5
    }
}
!element es.ignition.xxx {
    properties {
        amper 10
    }
}

# Лебедка
!element es.winch.winch {
    properties {
        amper 300
        # Кратковременный потребитель
        max_voltage_drop 0.75
    }
}

# Охлаждение ДВС
!element es.coolant_fan_1.motor {
    properties {
        amper 8
    }
}
!element es.coolant_fan_2.motor {
    properties {
        amper 8
    }
}


# Ближний/дальний/габариты
!element es.left_low_beam.lamp {
    properties {
        amper 5
    }
}
!element es.left_high_beam.lamp {
    properties {
        amper 5
    }
}
!element es.front_left_side_light.lamp {
    properties {
        amper 0.5
    }
}
!element es.right_low_beam.lamp {
    properties {
        amper 5
    }
}
!element es.right_high_beam.lamp {
    properties {
        amper 5
    }
}
!element es.front_right_side_light.lamp {
    properties {
        amper 0.5
    }
}
!element es.rear_left_side_light.lamp {
    properties {
        amper 0.5
    }
}
!element es.rear_right_side_light.lamp {
    properties {
        amper 0.5
    }
}
!element es.number_plate_light.lamp {
    properties {
        amper 0.5
    }
}
!element es.high_beam_control_light.lamp {
    properties {
        amper 0.5
    }
}


# Поворотники и аварийка
!element es.right_rear_turn_signal.lamp {
    properties {
        amper 0.5
    }
}
!element es.right_turn_signal_repeater.lamp {
    properties {
        amper 0.5
    }
}
!element es.right_front_turn_signal.lamp {
    properties {
        amper 0.5
    }
}
!element es.left_rear_turn_signal.lamp {
    properties {
        amper 0.5
    }
}
!element es.left_turn_signal_repeater.lamp {
    properties {
        amper 0.5
    }
}
!element es.left_front_turn_signal.lamp {
    properties {
        amper 0.5
    }
}
!element es.turn_signal_control_light.lamp {
    properties {
        amper 0.5
    }
}

# Стоп-сигнал и задний ход
!element es.extra_stop_signal.lamp {
    properties {
        amper 2
    }
}
!element es.right_stop_signal.lamp {
    properties {
        amper 2
    }
}
!element es.left_stop_signal.lamp {
    properties {
        amper 2
    }
}
!element es.reverse_lamp.lamp {
    properties {
        amper 2
    }
}

# Гудок
!element es.car_horn.horn {
    properties {
        amper 15
    }
}


# Отопитель салона
!element es.heater.motor {
    properties {
        amper 8
    }
}

# Доп свет
!element es.front_head_light.lamp {
    properties {
        amper 10
    }
}
!element es.rear_head_light.lamp {
    properties {
        amper 10
    }
}
!element es.left_head_light.lamp {
    properties {
        amper 10
    }
}
!element es.right_head_light.lamp {
    properties {
        amper 10
    }
}


#Вентилятор в салоне
!element es.interior_fan.motor {
    properties {
        amper 2
    }
}

# Дворники и омыватель
!element es.windshield_washer.motor {
    properties {
        amper 1
    }
}

!element es.wipers.motor1 {
    properties {
        amper 5
    }
}

!element es.wipers.motor2 {
    properties {
        amper 5
    }
}

# Электрическая помпа
!element es.electric_pump.motor {
    properties {
        amper 6
    }
}

# Лампа низкого уровня тормозной жидкости
!element es.low_brake_fluid_warning_light.lamp {
    properties {
        amper 0.5
    }
}

# Подсветка спидометра
!element es.speedometer_backlight.lamp {
    properties {
        amper 0.5
    }
}

# Подсветка датчика уровня топлива
!element es.fuel_level_backlight.lamp {
    properties {
        amper 0.5
    }
}

# Подсветка датчика температуры двигателя
!element es.engine_temp_backlight.lamp {
    properties {
        amper 0.5
    }
}

# Подсветка датчика давления масла
!element es.oil_pressure_backlight.lamp {
    properties {
        amper 0.5
    }
}

# Подсветка вольтметра
!element es.voltmeter_backlight.lamp {
    properties {
        amper 0.5
    }
}

# Указатель уровня топлива
!element es.fuel_level_gauge.gauge {
    properties {
        amper 0.1
    }
}

# Указатель температуры двигателя
!element es.engine_temp_gauge.gauge {
    properties {
        amper 0.1
    }
}

# Указатель давления масла
!element es.oil_pressure_gauge.gauge {
    properties {
        amper 0.1
    }
}

# Указатель вольтметра
!element es.voltmeter_gauge.gauge {
    properties {
        amper 0.1
    }
}

# Лампа перегрева двигателя
!element es.engine_overheat_control_light.lamp {
    properties {
        amper 0.5
    }
}

# Лампа низкого давления масла в двигателе
!element es.low_oil_pressure_control_light.lamp {
    properties {
        amper 0.5
    }
}
