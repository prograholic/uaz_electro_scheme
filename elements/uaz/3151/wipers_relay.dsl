tags "wipers_relay,relay"

_31b = pin "31b"
_15 = pin "15"
S = pin "S"
_86 = pin "86"
J = pin "J"
_31 = pin "31"

coil1 = consumer "coil1" {
    properties {
        amper 0.2
    }
}

coil2 = consumer "coil2" {
    properties {
        amper 0.2
    }
}


_86 -> coil1 {
    tags "expect_plus,internal_connection"
}
J -> coil2 {
    tags "expect_plus,internal_connection"
}
coil1 -> _31 {
    tags "expect_minus,internal_connection"
}
coil2 -> _31 {
    tags "expect_minus,internal_connection"
}

S -> _31b {
    tags "relay_power_switch,internal_connection"
    properties {
        switch_state 0
    }
}
_15 -> S {
    tags "relay_power_switch,internal_connection"
    properties {
        switch_state 1
    }
}
