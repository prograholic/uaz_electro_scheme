workspace "Name" "Description" {

    !identifiers hierarchical

    configuration {
        scope none
    }

    model {
        properties {
            "structurizr.groupSeparator" "/"
            "default_voltage" "12"


        }

        !impliedRelationships true

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

        es = softwareSystem "Электрическая система УАЗ" {
            tags "electric_system"
            m = container "Кузов" {
                tags "chassis"
                ground = ground "Масса"
            }

            power_group = group "Подкапотное пространство" {
                ground_switch = switch "Размыкатель массы" {
                    !include switch.dsl
                }
                akb = container "Аккумулятор" {
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
                }

                starter = container "Стартер" {
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
                }

                generator = container "Генератор" {
                    tags "generator"
                    plus = plus "+"
                    minus = minus "-"
                    power_source = power_source "gen"
                    g = ground "масса"

                    v = component "Возб" {
                        tags "pin,consumer"
                    }

                    v -> g {
                        tags "internal_connection"
                    }
                    g -> m.ground {
                        tags "internal_connection"
                    }
                    power_source -> plus {
                        tags "relay_power_switch,internal_connection"
                        properties {
                            switch_state 1
                        }
                    }
                    minus -> power_source {
                        tags "internal_connection"
                    }
                }

                ignition = splitter "Система зажигания" {
                    data = pin "pin"

                    xxx = consumer "x"

                    g = ground "масса"

                    data -> xxx {
                        tags "internal_connection"
                    }
                    xxx -> g {
                        tags "internal_connection"
                    }
                    g -> m.ground {
                        tags "internal_connection"
                    }
                }

                group "Лебедка" {
                    winch = container "Лебедка" {
                        tags "winch"
                        plus = plus "+"
                        minus = minus "-"
                        winch = consumer "winch"
                    }
                    winch_relay = relay "winch_relay"{
                        !include relay.dsl
                    }
                    winch_switch = switch "winch_switch" {
                        !include switch.dsl
                    }
                }



                group "Блок силовых предохранителей" {
                    # Сюда преды на 60-60-40-90
                    ignition_relay_fuse = fuse "Прд реле зажигания" {
                        !include fuse.dsl
                    }
                    light_fuse = fuse "Предохранитель освещения" {
                        !include fuse.dsl
                    }
                    ignition_fan_fuse = fuse "Предохранитель зажигания и э-вент охл-я" {
                        !include fuse.dsl
                    }

                    #fuse_90 = fuse "Предохранитель" {
                    #    !include fuse.dsl
                    #}
                }

                group "Вентиляторы" {
                    coolant_fan_1 = container "Э-вент охл ДВС 1"{
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
                    }
                    coolant_fan_2 = container "Э-вент охл ДВС 2"{
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
                    }
                }

                coolant_sensor = sensor "Датчик вкл э-вент охл ДВС" {
                    !include sensor.dsl
                }

                group "Передний блок фар" {
                    group "Левая фара" {
                        left_low_beam = light "Левый ближний свет" {
                            !include light.dsl
                        }
                        left_high_beam = light "Левый дальний свет" {
                            !include light.dsl
                        }
                        front_left_side_light = light "Передний левый габарит" {
                            !include light.dsl
                        }
                        left_front_turn_signal = light "Левый передний поворотник" {
                            !include light.dsl
                        }
                        left_turn_signal_repeater = light "Левый повторитель поворотника" {
                            !include light.dsl
                        }
                    }
                    group "Правая фара" {
                        right_low_beam = light "Правый ближний свет" {
                            !include light.dsl
                        }
                        right_high_beam = light "Правый дальний свет" {
                            !include light.dsl
                        }
                        front_right_side_light = light "Передний правый габарит" {
                            !include light.dsl
                        }
                        right_front_turn_signal = light "Правый передний поворотник" {
                            !include light.dsl
                        }
                        right_turn_signal_repeater = light "Правый повторитель поворотника" {
                            !include light.dsl
                        }
                    }
                }
            }

            group "Кабина" {
                heater = container "Отопитель салона" {
                    tags "heater"
                }
                interior_fan = container "Вентилятор салона" {
                    tags "fan"
                }
                wipers = container "Дворники" {
                    tags "wipers"
                }
                windshield_washer = container "Омыватель лобового стекла" {
                    tags "windshield_washer"
                }
                transmitter = container "Рация" {
                    tags "transmitter"
                }
                car_radio = container "Магнитола" {
                    tags "car_radio"
                }
                usb_charger = container "USB зарядка" {
                    tags "usb_charger"
                }
                brake_pressure_sensor = sensor "Датчик нажатия педали тормоза" {
                    !include sensor.dsl
                }
                reverse_lamp_sensor = sensor "Датчик движения заднего хода" {
                    !include sensor.dsl
                }

                group "Дополнительный свет" {
                    front_head_light = light "Передняя люстра" {
                        !include light.dsl
                    }
                    rear_head_light = light "Задняя люстра" {
                        !include light.dsl
                    }
                    left_head_light = light "Левая боковая люстра" {
                        !include light.dsl
                    }
                    right_head_light = light "Правая боковая люстра" {
                        !include light.dsl
                    }

                }
                group "Блок реле и предохранителей" {
                    #Реле
                    group "Блок реле" {
                        ignition_relay = relay "Реле зажигания" {
                            !include relay.dsl
                        }

                        starter_relay = relay "Реле стартера" {
                            !include relay5.dsl
                        }

                        coolant_fan_1_relay = relay "Реле э-вент охл ДВС 1" {
                            !include relay.dsl
                        }
                        coolant_fan_2_relay = relay "Реле э-вент охл ДВС 2" {
                            !include relay.dsl
                        }
                        low_beam_relay = relay "Реле ближнего света" {
                            !include relay.dsl
                        }
                        high_beam_relay = relay "Реле дальнего света" {
                            !include relay.dsl
                        }
                        side_light_relay = relay "Реле габаритов" {
                            !include relay.dsl
                        }
                        turn_signal_relay = relay "Реле поворотников" {
                            tags "relay950"
                            plus = pin "+" {
                                tags "relay_pin,relay_plus"
                            }
                            minus = pin "-" {
                                tags "relay_pin,relay_minus"
                            }
                            p = pin "П" {
                                tags "relay_pin,relay_p"
                            }
                            pb = pin "ПБ" {
                                tags "relay_pin,relay_pb"
                            }
                            lb = pin "ЛБ" {
                                tags "relay_pin,relay_lb"
                            }
                            kt = pin "КТ" {
                                tags "relay_pin,relay_kt"
                            }
                            left = pin "Лев" {
                                tags "relay_pin,relay_left"
                            }
                            right = pin "Прав" {
                                tags "relay_pin,relay_right"
                            }

                            coil_r = consumer "coil_r" {
                                properties {
                                    amper 0.2
                                    state_when_active 2
                                }
                            }
                            coil_l = consumer "coil_l" {
                                properties {
                                    amper 0.2
                                    state_when_active 1
                                }
                            }

                            coil_r -> minus {
                                tags "internal_connection"
                            }
                            coil_l -> minus {
                                tags "internal_connection"
                            }
                            plus -> p {
                                tags "internal_connection"
                            }
                            pb -> coil_r {
                                tags "internal_connection"
                            }
                            lb -> coil_l {
                                tags "internal_connection"
                            }

                            plus -> left {
                                tags "relay_power_switch,internal_connection"
                                properties {
                                    switch_state 1
                                }
                            }
                            plus -> right {
                                tags "relay_power_switch,internal_connection"
                                properties {
                                    switch_state 2
                                }
                            }
                            plus -> kt {
                                tags "relay_power_switch,internal_connection"
                                properties {
                                    switch_state "1,2"
                                }
                            }
                        }

                        front_head_light_relay = relay "Реле передней люстры" {
                            !include relay.dsl
                        }
                        rear_head_light_relay = relay "Реле задней люстры" {
                            !include relay.dsl
                        }
                        left_head_light_relay = relay "Реле левой боковой люстры" {
                            !include relay.dsl
                        }
                        right_head_light_relay = relay "Реле правой боковой люстры" {
                            !include relay.dsl
                        }
                    }

                    right_turn_signal_splitter = splitter "Подключение правых поворотников"{
                        pin = pin "pin"
                    }
                    left_turn_signal_splitter = splitter "Подключение левых поворотников"{
                        pin = pin "pin"
                    }

                    group "Блок предохранителей" {
                        starter_relay_fuse = fuse "Прд реле стартера." {
                            !include fuse.dsl
                        }
                        coolant_fan_1_fuse = fuse "Прд э-вент охл ДВС 1." {
                            !include fuse.dsl
                        }
                        coolant_fan_2_fuse = fuse "Прд э-вент охл ДВС 2." {
                            !include fuse.dsl
                        }
                        low_beam_relay_fuse = fuse "Прд. реле ближн света" {
                            !include fuse.dsl
                        }
                        high_beam_relay_fuse = fuse "Прд. реле дальн света" {
                            !include fuse.dsl
                        }
                        side_light_relay_fuse = fuse "Прд. реле габаритов" {
                            !include fuse.dsl
                        }
                        left_low_beam_fuse = fuse "Прд. ближн света (лев)" {
                            !include fuse.dsl
                        }
                        right_low_beam_fuse = fuse "Прд. ближн света (прав)" {
                            !include fuse.dsl
                        }
                        left_high_beam_fuse = fuse "Прд. дальн света (лев)" {
                            !include fuse.dsl
                        }
                        right_high_beam_fuse = fuse "Прд. дальн света (прав)" {
                            !include fuse.dsl
                        }
                        side_light_fuse = fuse "Прд. габаритов" {
                            !include fuse.dsl
                        }
                        turn_signal_fuse = fuse "Прд. поворотников" {
                            !include fuse.dsl
                        }
                        front_head_light_fuse = fuse "Прд. передней люстры" {
                            !include fuse.dsl
                        }
                        rear_head_light_fuse = fuse "Прд. задней люстры" {
                            !include fuse.dsl
                        }
                        left_head_light_fuse = fuse "Прд. левой боковой люстры" {
                            !include fuse.dsl
                        }
                        right_head_light_fuse = fuse "Прд. правой боковой люстры" {
                            !include fuse.dsl
                        }
                    }
                }
                group "Блок приборов" {
                    internal_lighting = splitter "Система подсветки приборов" {
                        data = pin "pin"
                    }
                    coolant_control_light = light "Подсветка упр э-вент охл ДВС" {
                        !include light.dsl
                    }

                    turn_signal_control_light = light "Контрольная лампа поворотников" {
                        !include light.dsl
                    }
                }
                group "Блок выключателей" {
                    ignition_switch = switch "Выключатель зажигания" {
                        !include switch.dsl
                    }
                    start_button = switch "Кнопка Старт" {
                        !include switch.dsl
                    }
                    coolant_control_switch = switch "Переключатель упр э-вент охл ДВС" {
                        D = pin "D"
                        I = pin "I"
                        U = pin "U"
                        #V = pin "V"
                        #L = pin "L"
                        #H = pin "H"

                        I -> D {
                            tags "ctr,switch_ctr,internal_connection"
                            properties {
                                switch_state 1
                            }
                        }
                        I -> U {
                            tags "ctr,switch_ctr,internal_connection"
                            properties {
                                switch_state 2
                            }
                        }

                        #V -> L {
                        #    tags "ctr,switch_ctr,internal_connection"
                        #    properties {
                        #        switch_state 1
                        #    }
                        #}

                        #L -> H {
                        #    tags "ctr,switch_ctr,internal_connection"
                        #    properties {
                        #        switch_state 2
                        #    }
                        #}
                    }
                    light_switch = switch "Выключатель габаритов и ближнего света" {
                        _30 = pin "30"
                        _58 = pin "58"
                        x = pin "X"
                        _56 = pin "56"

                        _30 -> _58 {
                            tags "ctr,switch_ctr,internal_connection"
                            properties {
                                switch_state "1,2"
                            }
                        }
                        x -> _56 {
                            tags "ctr,switch_ctr,internal_connection"
                            properties {
                                switch_state 2
                            }
                        }
                    }
                    car_horn_switch = switch "Кнопка гудка" {
                    }

                    emergency_light_button = switch "Кнопка аварийной сигнализации" {
                        pb = pin "ПБ"
                        p = pin "П"
                        lb = pin "ЛБ"
                        pow = pin "пов"
                        plus = pin "+"
                        emer = pin "авар"

                        pow -> plus {
                            tags "ctr,switch_ctr,internal_connection"
                            properties {
                                switch_state 0
                            }
                        }
                        emer -> plus {
                            tags "ctr,switch_ctr,internal_connection"
                            properties {
                                switch_state 1
                            }
                        }
                        p -> pb {
                            tags "ctr,switch_ctr,internal_connection"
                            properties {
                                switch_state 1
                            }
                        }
                        p -> lb {
                            tags "ctr,switch_ctr,internal_connection"
                            properties {
                                switch_state 1
                            }
                        }
                    }

                    front_head_light_switch = switch "Выключатель передней люстры" {
                        !include switch.dsl
                    }
                    rear_head_light_switch = switch "Выключатель задней люстры" {
                        !include switch.dsl
                    }
                    left_head_light_switch = switch "Выключатель левой боковой люстры" {
                        !include switch.dsl
                    }
                    right_head_light_switch = switch "Выключатель правой боковой люстры" {
                        !include switch.dsl
                    }
                }
                group "Подрулевые переключатели" {
                    group "левый подрулевой переключатель" {
                        left_steering_column_light_switch = switch "Левый подрулевой переключатель освещения" {
                            _56 = pin "56"
                            _56b = pin "56b"
                            _56a = pin "56a"
                            _30 = pin "30"

                            _56 -> _56b {
                                tags "ctr,switch_ctr,internal_connection"
                                properties {
                                    switch_state "0,1,2"
                                }
                            }
                            _56 -> _56a {
                                tags "ctr,switch_ctr,internal_connection"
                                properties {
                                    switch_state 1
                                }
                            }
                            _30 -> _56a {
                                tags "ctr,switch_ctr,internal_connection"
                                properties {
                                    switch_state 2
                                }
                            }
                        }
                        left_steering_column_turn_signal_switch = switch "левый подрулевой переключатель поворотников" {
                            _49aR = pin "49aR"
                            _49a = pin "49a"
                            _49aL = pin "49aL"

                            _49a -> _49aR {
                                tags "ctr,switch_ctr,internal_connection"
                                properties {
                                    switch_state 1
                                }
                            }

                            _49a -> _49aL {
                                tags "ctr,switch_ctr,internal_connection"
                                properties {
                                    switch_state 2
                                }
                            }
                        }
                    }
                    group "правый подрулевой переключатель" {
                        right_steering_column_switch = switch "правый подрулевой переключатель" {
                        }
                    }
                }
            }

            control_line_from_ignition = splitter "Потребители управляющей линии от зажигания" {
                data = pin "pin"
            }
            control_line_from_ignition_fuse = fuse "Предохранитель потребителей управляющей линии от зажигания" {
                !include fuse.dsl
            }

            group "Задний блок фар" {
                group "Левая задняя фара" {
                    rear_left_side_light = light "Задний левый габарит" {
                        !include light.dsl
                    }
                    left_rear_turn_signal = light "Левый задний поворотник" {
                        !include light.dsl
                    }
                    left_stop_signal = light "Левый стоп-сигнал" {
                        !include light.dsl
                    }
                }
                group "Правая задняя фара" {
                    rear_right_side_light = light "Задний правый габарит" {
                        !include light.dsl
                    }
                    right_rear_turn_signal = light "Правый задний поворотник" {
                        !include light.dsl
                    }
                    right_stop_signal = light "Правый стоп-сигнал" {
                        !include light.dsl
                    }
                }

                number_plate_light = light "Подсветка номера" {
                    !include light.dsl
                }
                reverse_lamp = light "Лампа заднего хода" {
                    !include light.dsl
                }
                extra_stop_signal = light "Доп. стоп-сигнал" {
                    !include light.dsl
                }

                s3 = splitter "s3" {
                    pin = pin "pin"
                }
            }

            #######################
            # Описание соединений #
            #######################
    
            # Система питания

            m.ground -> ground_switch.in {
                properties {
                    distance 0
                }
            }
            ground_switch.out -> akb.minus {
                properties {
                    distance 0.2
                }
            }
            akb.plus -> starter.plus {
                properties {
                    distance 1.5
                }
            }
            akb.plus -> winch.plus {
                properties {
                    distance 1.5
                }
            }


            # Система зажигания

            generator.plus -> starter.plus {
                properties {
                    distance 1.5
                }
            }
            m.ground -> generator.minus {
                properties {
                    distance 0.1
                }
            }
    
            starter.plus -> ignition_relay_fuse.in
            starter.plus -> light_fuse.in
            starter.plus -> ignition_fan_fuse.in
            #starter.plus -> fuse_90.in

            ignition_relay_fuse.out -> ignition_relay._30
            ignition_relay_fuse.out -> ignition_switch.in

            ignition_relay_fuse.out -> generator.v
    
            ignition_switch.out -> ignition_relay._85
            
            ignition_relay._86 -> m.ground {
                properties {
                    distance 0.1
                }
            }
            ignition_relay._87 -> starter_relay_fuse.in {
                properties {
                    distance 0.2
                }
            }
            
            starter_relay_fuse.out -> starter_relay._30 {
                properties {
                    distance 0.2
                }
            }
            starter_relay_fuse.out -> ignition.data
            starter_relay_fuse.out -> start_button.in
    
            start_button.out -> starter_relay._85
    
            starter_relay._86 -> m.ground {
                properties {
                    distance 0.1
                }
            }
            starter_relay._87 -> starter.st
            starter_relay._88 -> control_line_from_ignition_fuse.in
            control_line_from_ignition_fuse.out -> control_line_from_ignition.data

            # Лебедка
        
            winch.minus -> m.ground {
                properties {
                    distance 1.5
                }
            }
            winch.plus -> winch_relay._30 {
                tags "internal_connection"
            }
            winch_relay._87 -> winch.winch {
                tags "internal_connection"
            }
            winch.winch -> winch.minus {
                tags "internal_connection"
            }

            winch.plus -> winch_switch.in {
                tags "internal_connection"
            }
            winch_switch.out -> winch_relay._85 {
                tags "internal_connection"
            }
            winch_relay._86 -> winch.minus {
                tags "internal_connection"
            }


            # Электровентиляторы охлаждения ДВС

            coolant_fan_1.minus -> m.ground {
                properties {
                    distance 0.2
                }
            }
            coolant_fan_1_fuse.out -> coolant_fan_1_relay._30 {
                properties {
                    distance 0.2
                }
            }
            coolant_fan_1_relay._87 -> coolant_fan_1.plus
            control_line_from_ignition.data -> coolant_fan_1_relay._85
            ignition_fan_fuse.out -> coolant_fan_1_fuse.in
            coolant_fan_1_relay._86 -> coolant_control_switch.I {
                properties {
                    distance 0.5
                }
            }

            coolant_fan_2.minus -> m.ground {
                properties {
                    distance 0.2
                }
            }
            coolant_fan_2_relay._87 -> coolant_fan_2.plus
            ignition_fan_fuse.out -> coolant_fan_2_fuse.in
            control_line_from_ignition.data -> coolant_fan_2_relay._85
            coolant_fan_2_fuse.out -> coolant_fan_2_relay._30
            coolant_fan_2_relay._86 -> coolant_control_switch.I

            coolant_sensor.out -> m.ground {
                properties {
                    distance 0
                }
            }
            coolant_control_switch.D -> coolant_sensor.in
            coolant_control_switch.U -> m.ground {
                properties {
                    distance 0.2
                }
            }
            internal_lighting.data -> coolant_control_light.plus
            coolant_control_light.minus -> m.ground
            coolant_control_switch.D -> coolant_control_light.minus

            # Ближний/дальний свет
            control_line_from_ignition.data -> left_steering_column_light_switch._30
            left_steering_column_light_switch._56a -> high_beam_relay._85
            left_steering_column_light_switch._56b -> low_beam_relay._85

            control_line_from_ignition.data -> light_switch.x
            light_fuse.out -> light_switch._30
            light_switch._58 -> internal_lighting.data
            light_switch._56 -> left_steering_column_light_switch._56
            light_switch._58 -> side_light_relay._85

            left_low_beam.minus -> m.ground
            right_low_beam.minus -> m.ground
            low_beam_relay._86 -> m.ground
            low_beam_relay._87 -> left_low_beam_fuse.in
            left_low_beam_fuse.out -> left_low_beam.plus
            low_beam_relay._87 -> right_low_beam_fuse.in
            right_low_beam_fuse.out -> right_low_beam.plus
            low_beam_relay_fuse.out -> low_beam_relay._30
            light_fuse.out -> low_beam_relay_fuse.in

            left_high_beam.minus -> m.ground
            right_high_beam.minus -> m.ground
            high_beam_relay._87 -> left_high_beam_fuse.in
            high_beam_relay._86 -> m.ground

            left_high_beam_fuse.out -> left_high_beam.plus
            high_beam_relay._87 -> right_high_beam_fuse.in
            right_high_beam_fuse.out -> right_high_beam.plus
            high_beam_relay_fuse.out -> high_beam_relay._30
            light_fuse.out -> high_beam_relay_fuse.in

            front_left_side_light.minus -> m.ground
            front_right_side_light.minus -> m.ground
            rear_left_side_light.minus -> m.ground
            rear_right_side_light.minus -> m.ground
            number_plate_light.minus -> m.ground

            left_front_turn_signal.minus -> m.ground
            left_turn_signal_repeater.minus -> m.ground
            left_rear_turn_signal.minus -> m.ground

            right_front_turn_signal.minus -> m.ground
            right_turn_signal_repeater.minus -> m.ground
            right_rear_turn_signal.minus -> m.ground


            side_light_relay._86 -> m.ground
            side_light_relay._87 -> side_light_fuse.in
            side_light_fuse.out -> front_left_side_light.plus
            side_light_fuse.out -> front_right_side_light.plus
            side_light_fuse.out -> rear_left_side_light.plus
            side_light_fuse.out -> rear_right_side_light.plus
            side_light_fuse.out -> number_plate_light.plus
            side_light_relay_fuse.out -> side_light_relay._30
            light_fuse.out -> side_light_relay_fuse.in

            # Поворотники и аварийка
            light_fuse.out -> turn_signal_fuse.in
            turn_signal_relay.p -> left_steering_column_turn_signal_switch._49a
            turn_signal_relay.p -> emergency_light_button.p
            turn_signal_relay.minus -> m.ground
            left_steering_column_turn_signal_switch._49aR -> turn_signal_relay.pb
            emergency_light_button.pb -> turn_signal_relay.pb
            left_steering_column_turn_signal_switch._49aL -> turn_signal_relay.lb
            emergency_light_button.lb -> turn_signal_relay.lb
            turn_signal_relay.kt -> turn_signal_control_light.plus
            turn_signal_control_light.minus -> m.ground
            turn_signal_relay.right -> right_turn_signal_splitter.pin
            turn_signal_relay.left -> left_turn_signal_splitter.pin

            emergency_light_button.plus -> turn_signal_relay.plus

            # TODO тут питание должно приходить только при включенном зажигании - значит нужно поставить реле
            turn_signal_fuse.out -> emergency_light_button.pow
            turn_signal_fuse.out -> emergency_light_button.emer


            right_turn_signal_splitter.pin -> right_front_turn_signal.plus
            right_turn_signal_splitter.pin -> right_turn_signal_repeater.plus
            right_turn_signal_splitter.pin -> right_rear_turn_signal.plus

            left_turn_signal_splitter.pin -> left_front_turn_signal.plus
            left_turn_signal_splitter.pin -> left_turn_signal_repeater.plus
            left_turn_signal_splitter.pin -> left_rear_turn_signal.plus



            # Передняя люстра
            light_fuse.out -> front_head_light_fuse.in
            front_head_light_fuse.out -> front_head_light_relay._30
            front_head_light_relay._87 -> front_head_light.plus
            front_head_light.minus -> m.ground
            control_line_from_ignition.data -> front_head_light_switch.in
            front_head_light_switch.out -> front_head_light_relay._85
            front_head_light_relay._86 -> m.ground


            # Задняя люстра
            light_fuse.out -> rear_head_light_fuse.in
            rear_head_light_fuse.out -> rear_head_light_relay._30
            rear_head_light_relay._87 -> rear_head_light.plus
            rear_head_light.minus -> m.ground
            control_line_from_ignition.data -> rear_head_light_switch.in
            rear_head_light_switch.out -> rear_head_light_relay._85
            rear_head_light_relay._86 -> m.ground

            # Левая боковая люстра
            light_fuse.out -> left_head_light_fuse.in
            left_head_light_fuse.out -> left_head_light_relay._30
            left_head_light_relay._87 -> left_head_light.plus
            left_head_light.minus -> m.ground
            control_line_from_ignition.data -> left_head_light_switch.in
            left_head_light_switch.out -> left_head_light_relay._85
            left_head_light_relay._86 -> m.ground


            # Задняя люстра
            light_fuse.out -> right_head_light_fuse.in
            right_head_light_fuse.out -> right_head_light_relay._30
            right_head_light_relay._87 -> right_head_light.plus
            right_head_light.minus -> m.ground
            control_line_from_ignition.data -> right_head_light_switch.in
            right_head_light_switch.out -> right_head_light_relay._85
            right_head_light_relay._86 -> m.ground


            # Педаль тормоза
            ignition_fan_fuse.out -> brake_pressure_sensor.in
            brake_pressure_sensor.out -> s3.pin
            s3.pin -> left_stop_signal.plus
            s3.pin -> right_stop_signal.plus
            s3.pin -> extra_stop_signal.plus

            left_stop_signal.minus -> m.ground
            right_stop_signal.minus -> m.ground
            extra_stop_signal.minus -> m.ground

            # Лампа заднего хода
            ignition_fan_fuse.out -> reverse_lamp_sensor.in
            reverse_lamp_sensor.out -> reverse_lamp.plus
            reverse_lamp.minus -> m.ground
        }

        // Set amper
        !include set_consumer_amper.dsl
        !include switch_states.dsl
    }

    !script graph_validators.groovy
    !script deduce_wire_square.groovy

    views {
        properties {
            "structurizr.sort" "created"
        }

        #################
        # Описание вьюх #
        #################
        container es es_view "Общий вид электрической системы" {
            include *
            exclude es.m
            autolayout tb
        }

        component es.akb overall_component_view "Общий вид всех компонент" {
            include "element.type==component"
            include "element.type==container"
            exclude es.m.ground
            autolayout lr
        }

        !script all_components_view.groovy

        styles {

            #######################
            # Описание соединений #
            #######################

            relationship "Relationship" {
                style solid
                #Direct|Orthogonal|Curved
                routing Direct
                opacity 20
            }
            relationship "powered" {
                opacity 100
                thickness 5
            }
            relationship "pwr" {
                style dashed
                thickness 3
            }
            relationship "ctr" {
                style dotted
            }
            relationship "color_red" {
                color #ff0000
            }
            relationship "color_black" {
                color #000000
            }
            relationship "color_blue" {
                color #0000ff
            }
            relationship "color_green" {
                color #00b300
            }
            relationship "color_brown" {
                color #977400
            }
            relationship "color_yellow" {
                color #ffff00
            }
            relationship "color_white" {
                color #fdf4d7
            }
            relationship "square_100" {
                thickness 19
            }
            relationship "square_75" {
                thickness 18
            }
            relationship "square_50" {
                thickness 17
            }
            relationship "square_35" {
                thickness 16
            }
            relationship "square_25" {
                thickness 15
            }
            relationship "square_16" {
                thickness 14
            }
            relationship "square_6" {
                thickness 11
            }
            relationship "square_4" {
                thickness 10
            }
            relationship "square_2.5" {
                thickness 9
            }
            relationship "square_1.5" {
                thickness 8
            }
            relationship "square_1.5" {
                thickness 7
            }
            relationship "square_0.75" {
                thickness 6
            }
            relationship "square_0.5" {
                thickness 5
            }


            ######################
            # Описание элементов #
            ######################
            element "Component" {
                background #808080
                width 100
                height 100
                metadata false
            }
            element "pin" {
                description false
                shape Box
                background #0000bb
            }
            element "power_source" {
                description false
                shape Box
                background #ff0000
            }
            element "consumer" {
                description false
                shape Circle
                background #ffc400
            }
            element "ground" {
                metadata false
                description false
                width 100
                height 100
                color #000000
                icon ground.png
                fontSize 5
                shape Circle
                background #ffffff
            }
            element "plus" {
                icon "plus.png"
                width 100
                metadata false
                description false
                shape Circle
                background #ffffff
            }
            element "minus" {
                icon "minus.png"
                width 100
                metadata false
                description false
                shape Circle
                background #ffffff
            }


            element "Container" {
                background #0773af
                metadata false
                fontSize 1
            }
            element "fan" {
                shape "Hexagon"
                width 150
                fontSize 1
                background #000000
            }
            element "akb" {
                icon akb.jpg
                background #ffc400
            }
            element "starter" {
                icon "starter.jpg"
                shape pipe
                height 150
                width 300
                background #808080
            }
            element "generator" {
                shape pipe
                height 150
                width 300
                background #ae03fd
            }
            element "winch" {
                shape pipe
                height 150
                fontSize 40
                background #8b3301
            }
            element "switch" {
                icon "switch.png"
                height 100
                width 300
                background #038803
            }
            element "fuse" {
                background #ff0000
                height 300
                width 100
                icon fuse.jpeg
            }
            element "relay" {
                background #0000bb
                height 100
                width 100
                icon relay.jpg
            }
            element "relay5" {
                background #0000bb
            }
            element "light" {
                metadata false
                description false
                width 150
                icon light.jpg
                shape Circle
                background #808080
            }
            element "sensor" {
                metadata false
                description false
                width 150
                height 150
                background #865515
            }


            element "Element" {
                color #ffffff
            }
            element "Person" {
                background #05527d
                shape person
            }
            element "Software System" {
                background #066296
            }
        }
    }
}