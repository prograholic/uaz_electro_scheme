!element es.ground_switch {
    properties {
        # 1 - масса
        active_switch_state 1
    }
}
!element es.ignition_switch {
    properties {
        # 1 - вкл зажигание
        active_switch_state 1
    }
}
!element es.start_button {
    properties {
        # 0 - стартер не крутим
        # 1 - покрутить стартер!
        active_switch_state 0
    }
}


# Вентиляторы охлаждения ДВС
!element es.coolant_control_switch {
    properties {
        # 0 - отключены
        # 1 - от датчика
        # 2 - всегда
        active_switch_state 2
    }
}


# Освещение
!element es.light_switch {
    properties {
        # 0 - выключено
        # 1 - габариты
        # 2 - габариты + ближний
        active_switch_state 2
    }
}
!element es.left_steering_column_light_switch {
    properties {
        # при light_switch == 0
        #   0 - 
        #   1 - 
        #   2 - дальний (мыргалка)
        # при light_switch == 1
        #   0 - 
        #   1 - 
        #   2 - дальний (мыргалка)
        # при light_switch == 2
        #   0 - ближний
        #   1 - ближний + дальний (постоянный)
        #   2 - ближний + дальний (мыргалка)
        active_switch_state 2
    }
}


# Поворотники и аварийка
!element es.left_steering_column_turn_signal_switch {
    properties {
        # 0 - поворотники выключены
        # 1 - правый поворотник включен
        # 2 - левый поворотник включен
        active_switch_state 2
    }
}
!element es.emergency_light_button {
    properties {
        # 0 - аварийка выключена
        # 1 - аварийка включена
        active_switch_state 0
    }
}

# Доп освещение
!element es.front_head_light_switch {
    properties {
        # 0 - передний доп свет выключен
        # 1 - передний доп свет включен
        active_switch_state 0
    }
}
!element es.rear_head_light_switch {
    properties {
        # 0 - задний доп свет выключен
        # 1 - задний доп свет включен
        active_switch_state 0
    }
}
!element es.left_head_light_switch {
    properties {
        # 0 - левый доп свет выключен
        # 1 - левый доп свет включен
        active_switch_state 0
    }
}
!element es.right_head_light_switch {
    properties {
        # 0 - правый доп свет выключен
        # 1 - правый доп свет включен
        active_switch_state 0
    }
}

# Гудок
!element es.car_horn_switch {
    properties {
        # 0 - гудок выключен
        # 1 - гудок включен
        active_switch_state 0
    }
}

#Печка
!element es.heater_switch {
    properties {
        # 0 - печка выключена
        # 1 - печка включена (1-я скорость)
        # 2 - печка включена (2-я скорость)
        active_switch_state 0
    }
}


#Салонный вентилятор
!element es.interior_fan_switch {
    properties {
        # 0 - вентилятор выключен
        # 1 - вентилятор включен
        active_switch_state 0
    }
}


# Дворники и омыватель
!element es.right_steering_column_switch {
    properties {
        # 0 - дворники и омыватель выключен
        # 1 - однократный взмах дворниками (???)
        # 2 - ???
        # 3 - ???
        # 4 - ???
        # 8 - ???
        active_switch_state 0
    }
}


# Датчики
!element es.brake_pressure_sensor {
    properties {
        # 0 - тормоз отпущен
        # 1 - тормоз нажат
        active_switch_state 0
    }
}
!element es.reverse_lamp_sensor {
    properties {
        # 0 - задняя передача не включена
        # 1 - включена задняя передача
        active_switch_state 0
    }
}
!element es.coolant_sensor {
    properties {
        # 0 - датчик температуры не включен
        # 1 - датчик температуры включен
        active_switch_state 0
    }
}

# Лебедка
!element es.winch_switch {
    properties {
        # 0 - лебедка выключена
        # 1 - лебедка включена
        active_switch_state 0
    }
}
