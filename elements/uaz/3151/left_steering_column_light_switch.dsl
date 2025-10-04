_56 = pin "56"
_56b = pin "56b"
_56a = pin "56a"
_30 = pin "30"

_56 -> _56b {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state "0,1,2"
    }
}
_56 -> _56a {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 1
    }
}
_30 -> _56a {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 2
    }
}
