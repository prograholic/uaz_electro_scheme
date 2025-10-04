tags "fuse"
in = pin "in" {
    tags "in" "fuse_pin"
}
out = pin "out" {
    tags "out" "fuse_pin"
}

in -> out {
    tags "pwr" "fuse_pwr" "internal_connection"
}
