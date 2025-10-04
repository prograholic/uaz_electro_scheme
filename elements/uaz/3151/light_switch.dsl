_30 = pin "30"
_58 = pin "58"
x = pin "X"
_56 = pin "56"

_30 -> _58 {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state "1,2"
    }
}
x -> _56 {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 2
    }
}
