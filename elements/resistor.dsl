tags "resistor"
in = pin "in" {
    tags "in" "resistor_pin"
}
out = pin "out" {
    tags "out" "resistor_pin"
}

in -> out {
    tags "internal_connection"
}
