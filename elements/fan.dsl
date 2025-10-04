tags "fan"
plus = plus "+"
minus = minus "-"
fan = consumer "fan"

plus -> fan {
    tags "internal_connection"
}
fan -> minus {
    tags "internal_connection"
}
