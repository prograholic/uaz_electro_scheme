tags "switch"
in = component "in" {
    tags "connector,in,switch_connector"
}
out = component "out" {
    tags "connector,out,switch_connector"
}

in -> out {
    tags "ctr;switch_ctr"
    properties {
        switch_state 1
    }
}
