tags "starter"
plus = plus "+"

eng = consumer "двигатель"

st = pin "Втяг"

g = component "ground" {
    tags "ground"
}

st_relay = consumer "Втяг реле"

plus -> eng {
    tags "internal_connection,starter_switch"
    properties {
        switch_state 1
    }
}
eng -> g {
    tags "internal_connection"

}

g -> m.ground {
    tags "internal_connection"
}
st -> st_relay {
    tags "internal_connection"
}
st_relay -> g {
    tags "internal_connection"
}
