tags "generator"
plus = plus "+"
minus = minus "-"
power_source = power_source "gen"
g = ground "масса"

v = component "Возб" {
    tags "pin,consumer"
}

v -> g {
    tags "internal_connection"
}
g -> m.ground {
    tags "internal_connection"
}
power_source -> plus {
    tags "relay_power_switch,internal_connection"
    properties {
        switch_state 1
    }
}
minus -> power_source {
    tags "internal_connection"
}
