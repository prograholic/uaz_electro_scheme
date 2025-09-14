#relay = container "Реле" {
    tags "relay"
    _30 = component "30" {
        tags "relay_30,relay_connector,connector"
    }
    _87 = component "87" {
        tags "relay_87,relay_connector,connector"
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
    _85 -> _86 {
        tags "relay_ctr"
    }
#}
