_49aR = pin "49aR"
_49a = pin "49a"
_49aL = pin "49aL"

_49a -> _49aR {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 1
    }
}

_49a -> _49aL {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 2
    }
}
