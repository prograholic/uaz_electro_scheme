tags "sensor"
in = pin "in" {
    tags "in,sensor_pin"
}
out = pin "out" {
    tags "out,sensor_pin"
}

in -> out {
    tags "ctr;sensor_ctr"
    properties {
        switch_state 1
    }
}
