tags "car_horn"

plus = plus "+"
minus = minus "-"
horn = consumer "гудок"

plus -> horn {
    tags "internal_connection"
}
horn -> minus {
    tags "internal_connection"
}
