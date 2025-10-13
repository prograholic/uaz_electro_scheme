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
        amper 30
    }
}

# Охлаждение ДВС
!element es.coolant_fan_1.motor {
    properties {
        amper 20
    }
}
!element es.coolant_fan_2.motor {
    properties {
        amper 20
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