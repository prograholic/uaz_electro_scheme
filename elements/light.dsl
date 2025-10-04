tags "light"
plus = pin "+" {
    tags "plus,light_pin"
}

lamp = consumer "lamp"

minus = pin "-" {
    tags "minus,light_pin"
}

plus -> lamp {
    tags "expect_plus,internal_connection"
}
lamp -> minus {
    tags "expect_ground,internal_connection"
}
