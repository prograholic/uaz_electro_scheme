pb = pin "ПБ"
p = pin "П"
lb = pin "ЛБ"
pow = pin "пов"
plus = pin "+"
emer = pin "авар"

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
