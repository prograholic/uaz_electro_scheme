tags "relay"
_30 = pin "30" {
    tags "relay_pin,relay_30"
}
_87 = pin "87" {
    tags "relay_pin,relay_87"
}
_86 = pin "86" {
    tags "relay_pin,relay_86"
}
_85 = pin "85" {
    tags "relay_pin,relay_85"
}
coil = consumer "coil" {
    properties {
        amper 0.2
    }
}

_30 -> _87 {
    tags "relay_power_switch,internal_connection"
    properties {
        switch_state 1
    }
}

_85 -> coil {
    tags "expect_plus,internal_connection"
}
coil -> _86 {
    tags "expect_minus,internal_connection"
}
