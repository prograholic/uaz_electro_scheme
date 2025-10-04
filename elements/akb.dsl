tags "akb"
power_source = power_source "akb"
plus = plus "+"
minus = minus "-"

power_source -> plus {
    tags "internal_connection"
}
minus -> power_source {
    tags "internal_connection"
}
