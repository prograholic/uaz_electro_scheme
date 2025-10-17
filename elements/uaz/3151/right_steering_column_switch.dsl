_53e = pin "53e"
_53 = pin "53"
_53a = pin "53a"
J = pin "J"
_53b = pin "53b"
_53ah = pin "53ah"
W = pin "W"
#_53h = pin "53h"
#WH = pin "WH"

_53e -> _53 {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state "0,1,2,8"
    }
}
_53a -> J {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state "1,2"
    }
}
_53a -> _53b {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state "4"
    }
}
#_53ah -> WH {
#    tags "ctr,switch_ctr,internal_connection"
#    properties {
#        switch_state "6,7"
#    }
#}
#_53ah -> _53h {
#    tags "ctr,switch_ctr,internal_connection"
#    properties {
#        switch_state "7"
#    }
#}
_53ah -> W {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state "8"
    }
}
