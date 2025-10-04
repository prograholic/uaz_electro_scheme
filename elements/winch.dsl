winch = container "Лебедка" {
    tags "winch"
    plus = plus "+"
    minus = minus "-"
    winch = consumer "winch"
}
winch_relay = relay "winch_relay"{
    !include "relay.dsl"
}
winch_switch = switch "winch_switch" {
    !include "switch.dsl"
}
