tags "fuse"
in = component "in" {
    tags "connector,in,fuse_connector"
}
out = component "out" {
    tags "connector,out,fuse_connector"
}

in -> out {
    tags "fuse_pwr;pwr"
}
