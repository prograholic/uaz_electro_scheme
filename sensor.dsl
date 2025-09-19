tags "sensor"
in = component "in" {
    tags "connector,in,sensor_connector"
}
out = component "out" {
    tags "connector,out,sensor_connector"
}

in -> out {
    tags "ctr;sensor_ctr"
}
