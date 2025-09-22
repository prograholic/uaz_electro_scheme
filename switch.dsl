tags "switch"
in = pin "in" {
    tags "in"
}
out = pin "out" {
    tags "out"
}

in -> out {
    tags "ctr,switch_ctr"
    properties {
        switch_state 1
    }
}
