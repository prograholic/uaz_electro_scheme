tags "gauge"
plus = pin "+" {
    tags "plus,gauge_pin"
}
minus = pin "-" {
    tags "minus,gauge_pin"
}

gauge = consumer "gauge"

plus -> gauge {
    tags "ctr,gauge_ctr,internal_connection"
}

gauge -> minus {
    tags "ctr,gauge_ctr,internal_connection"
}
