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
        # 1 - покрутить стартер!
        #active_switch_state 1
    }
}

!element es.coolant_control_switch {
    properties {
        # 1 - от датчика, 2 - всегда
        active_switch_state 2
    }
}


# Освещение
!element es.light_switch {
    properties {
        # 1 - габариты, 2 - габариты + ближний
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
        active_switch_state 0
    }
}
!element es.emergency_light_button {
    properties {
        # 0 - аварийка выключена
        # 1 - аварийка включена
        active_switch_state 1
    }
}