tags "switch" "emer_lght_switch"
pb = pin "ПБ (7)"
p = pin "П (1)"
lb = pin "ЛБ (3)"
pow = pin "пов (2)"
plus = pin "+ (4)"
emer = pin "авар (8)"

pow -> plus {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 0
    }
}
emer -> plus {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 1
    }
}
p -> pb {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 1
    }
}
p -> lb {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 1
    }
}
