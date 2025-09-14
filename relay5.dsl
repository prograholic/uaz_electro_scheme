tags "relay5"
_30 = component "30" {
    tags "relay_30,relay_connector,connector"
}
_87 = component "87" {
    tags "relay_87,relay_connector,connector"
}
_88 = component "88" {
    tags "relay_88,relay_connector,connector"
}
_86 = component "86" {
    tags "relay_86,relay_connector,connector"
}
_85 = component "85" {
    tags "relay_85,relay_connector,connector"
}

_30 -> _87 {
    tags "relay_pwr"
}
_30 -> _88 {
    tags "relay_pwr_default_connected"
}

_85 -> _86 {
    tags "relay_ctr"
}
