tags "switch"
in = pin "in" {
    tags "in"
}
out = pin "out" {
    tags "out"
}

in -> out {
    tags "ctr,switch_ctr,internal_connection"
    properties {
        switch_state 1
    }
}
