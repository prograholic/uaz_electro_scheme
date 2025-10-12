plus = plus "+"
minus = minus "-"
motor = consumer "электродвигатель"

plus -> motor {
    tags "internal_connection"
}
motor -> minus {
    tags "internal_connection"
}
