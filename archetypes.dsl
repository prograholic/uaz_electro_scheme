archetypes {
    relay = container {
        tags "relay"
    }
    fuse = container {
        tags "fuse"
    }
    switch = container {
        tags "switch"
    }
    light = container {
        tags "light"
    }
    sensor = container {
        tags "sensor"
    }
    splitter = container {
        tags "splitter"
    }
    fan = container {
        tags "fan"
    }
    resistor = container {
        tags "resistor"
    }
    gauge = container {
        tags "gauge"
    }

    pin = component {
        tags "pin"
    }
    plus = pin {
        tags "plus"
    }
    minus = pin {
        tags "minus"
    }
    consumer = component {
        tags "consumer"
    }
    power_source = component {
        tags "power_source"
    }

    ground = pin {
        tags "ground"
    }
}
