tags "relay5"
_30 = component "30" {
    tags "connector,relay_connector,relay_30"
}
_87 = component "87" {
    tags "connector,relay_connector,relay_87"
}
_88 = component "88" {
    tags "connector,relay_connector,relay_88"
}
_86 = component "86" {
    tags "connector,relay_connector,relay_86"
}
_85 = component "85" {
    tags "connector,relay_connector,relay_85"
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
