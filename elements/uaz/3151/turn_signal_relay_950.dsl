tags "relay950"
plus = pin "+" {
    tags "relay_pin,relay_plus"
}
minus = pin "-" {
    tags "relay_pin,relay_minus"
}
p = pin "П" {
    tags "relay_pin,relay_p"
}
pb = pin "ПБ" {
    tags "relay_pin,relay_pb"
}
lb = pin "ЛБ" {
    tags "relay_pin,relay_lb"
}
kt = pin "КТ" {
    tags "relay_pin,relay_kt"
}
left = pin "Лев" {
    tags "relay_pin,relay_left"
}
right = pin "Прав" {
    tags "relay_pin,relay_right"
}
coil_r = consumer "coil_r" {
    properties {
        amper 0.2
        state_when_active 2
    }
}
coil_l = consumer "coil_l" {
    properties {
        amper 0.2
        state_when_active 1
    }
}
coil_r -> minus {
    tags "internal_connection"
}
coil_l -> minus {
    tags "internal_connection"
}
plus -> p {
    tags "internal_connection"
}
pb -> coil_r {
    tags "internal_connection"
}
lb -> coil_l {
    tags "internal_connection"
}

plus -> left {
    tags "relay_power_switch,internal_connection"
    properties {
        switch_state 1
    }
}
plus -> right {
    tags "relay_power_switch,internal_connection"
    properties {
        switch_state 2
    }
}
plus -> kt {
    tags "relay_power_switch,internal_connection"
    properties {
        switch_state "1,2"
    }
}
