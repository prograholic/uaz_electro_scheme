D = pin "D"
I = pin "I"
U = pin "U"
#V = pin "V"
#L = pin "L"
#H = pin "H"

I -> D {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 1
    }
}
I -> U {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 2
    }
}

#V -> L {
#    tags "ctr,switch_ctr,internal_connection"
#    properties {
#        switch_state 1
#    }
#}

#L -> H {
#    tags "ctr,switch_ctr,internal_connection"
#    properties {
#        switch_state 2
#    }
#}
