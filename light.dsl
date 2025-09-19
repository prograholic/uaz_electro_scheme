tags "light"
plus = component "+" {
    tags "connector,plus,light_connector"
}
minus = component "-" {
    tags "connector,minus,light_connector"
}
plus -> minus {
    tags "pwr;light_pwr"
}
