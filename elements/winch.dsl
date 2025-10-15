winch = container "Лебедка" {
    tags "winch"
    plus = plus "+"
    minus = minus "-"
    winch = consumer "winch"
}
winch_relay = relay "winch_relay" {
    !include "relay.dsl"
}
winch_fuse = fuse "winch_fuse" {
    !include "fuse.dsl"
}
winch_switch = switch "winch_switch" {
    !include "switch.dsl"
}

winch.plus -> winch_fuse.in {
    tags "internal_connection"
}

winch_fuse.out -> winch_relay._30 {
    tags "internal_connection"
}
winch_relay._87 -> winch.winch {
    tags "internal_connection"
}
winch.winch -> winch.minus {
    tags "internal_connection"
}

winch_fuse.out -> winch_switch.in {
    tags "internal_connection"
}
winch_switch.out -> winch_relay._85 {
    tags "internal_connection"
}
winch_relay._86 -> winch.minus {
    tags "internal_connection"
}
