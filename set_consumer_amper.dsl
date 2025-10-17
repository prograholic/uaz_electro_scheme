#Стартер, генератор, зажигание
!element es.starter.eng {
    properties {
        amper 150
    }
}
!element es.starter.st_relay {
    properties {
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
        # Вообще-то кол-во ампер около 300, но т.к. это кратковременная нагрузка, то считаем поменьше
        #amper 300
        amper 140
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
!element es.coolant_control_light.lamp {
    properties {
        amper 0.5
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
