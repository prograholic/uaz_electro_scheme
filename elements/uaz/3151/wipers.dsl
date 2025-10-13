tags "wipers"

_1 = pin "1"
_2 = pin "2"
_3 = pin "3"
_4 = pin "4"
_5 = pin "5"
_6 = pin "6"

motor1 = consumer "электродвигатель1"
motor2 = consumer "электродвигатель2"

_5 -> motor1 {
    tags "internal_connection"
}

_6 -> motor2 {
    tags "internal_connection"
}

motor1 -> _3 {
    tags "internal_connection"
}
motor2 -> _3 {
    tags "internal_connection"
}

_4 -> _3 {
    tags "internal_connection"
}


#TODO добавить резистор
_1 -> _2 {
    tags "internal_connection"
}