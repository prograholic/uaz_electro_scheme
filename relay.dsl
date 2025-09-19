#relay = container "Реле" {
    tags "relay"
    _30 = component "30" {
        tags "connector,relay_connector,relay_30"
    }
    _87 = component "87" {
        tags "connector,relay_connector,relay_87"
    }
    _86 = component "86" {
        tags "connector,relay_connector,relay_86"
    }
    _85 = component "85" {
        tags "connector,relay_connector,relay_85"
    }

    _30 -> _87 {
        tags "pwr;relay_pwr"
    }
    _85 -> _86 {
        tags "ctr;relay_ctr"
    }
#}
