workspace "Name" "Description" {

    !identifiers hierarchical

    configuration {
        scope none
    }

    model {
        properties {
            "structurizr.groupSeparator" "/"
            default_voltage 12
        }

        !impliedRelationships false

        archetypes {
            relay = container {
                tags "relay"
                properties {
                    ctr_amper 0.2
                }
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
            ground = container {
                tags "pin,ground"
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
                tags "pin,power_source"
            }
        }

        es = softwareSystem "Электрическая система УАЗ" {
            tags "electric_system"
            power_group = group "Подкапотное пространство" {
                ground_switch = switch "Размыкатель массы" {
                    !include switch.dsl
                }
                g0 = ground "g0"
                akb = container "Аккумулятор" {
                    tags "akb"
                    plus = power_source "+"
                    minus = minus "-" {
                        tags "non_root"
                    }
                }

                starter = container "Стартер" {
                    tags "starter"
                    plus = plus "+"
                    
                    eng = consumer "двигатель" {
                        properties {
                            amper 350
                        }
                    }

                    g = component "g" {
                        tags "ground"
                    }

                    st = pin "Втяг"

                    st_relay = consumer "Втяг реле" {
                        # Информация о мощности: https://forum.uazbuka.ru/showthread.php?t=40718
                        properties {
                            amper 20
                        }
                    }

                    plus -> eng {
                        tags "internal_connection"
                    }
                    eng -> g {
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
                    plus = power_source "+"

                    v = component "Возб" {
                        tags "pin,consumer"
                        properties {
                            amper 1000
                        }
                    }

                    g = component "g" {
                        tags "ground"
                    }
                    v -> g {
                        tags "internal_connection"
                    }
                }

                ignition = splitter "Система зажигания" {
                    data = pin "pin"
                }

                winch = container "Лебедка" {
                    tags "winch"
                    plus = plus "+"
                    minus = minus "-"
                    winch = consumer "winch"

                    plus -> winch {
                        tags "internal_connection"
                    }
                    winch -> minus {
                        tags "internal_connection"
                    }
                }
                g4 = ground "g4"

                group "Блок силовых предохранителей" {
                    # Сюда преды на 60-60-40-90
                    ignition_relay_fuse = fuse "Прд реле зажигания" {
                        !include fuse.dsl
                    }
                    light_fuse = fuse "Предохранитель штатного освещения" {
                        !include fuse.dsl
                    }
                    ignition_vent_fuse = fuse "Предохранитель зажигания и э-вент охл-я" {
                        !include fuse.dsl
                    }

                    fuse_90 = fuse "Предохранитель" {
                        !include fuse.dsl
                    }
                }

                group "Вентиляторы" {
                    coolant_vent_1 = container "Э-вент охл ДВС 1"{
                        tags "vent"
                        plus = plus "+"
                        minus = minus "-"
                        vent = consumer "vent" {
                            properties {
                                amper 20
                            }
                        }
                        plus -> vent {
                            tags "internal_connection"
                        }
                        vent -> minus {
                            tags "internal_connection"
                        }
                    }
                    coolant_vent_2 = container "Э-вент охл ДВС 2"{
                        tags "vent"
                        plus = plus "+"
                        minus = minus "-"
                        vent = consumer "vent" {
                            properties {
                                amper 20
                            }
                        }
                        plus -> vent {
                            tags "internal_connection"
                        }
                        vent -> minus {
                            tags "internal_connection"
                        }
                    }
                    g5 = ground "g5"
                }

                coolant_sensor = sensor "Датчик вкл э-вент охл ДВС" {
                    !include sensor.dsl
                }
                g7 = ground "g7"

                group "Передний блок фар" {
                    group "Левая фара" {
                        left_low_beam = light "Левый ближний свет" {
                            properties {
                                amper 20
                            }
                            !include light.dsl
                        }
                        left_high_beam = light "Левый дальний свет" {
                            properties {
                                amper 20
                            }
                            !include light.dsl
                        }
                        front_left_side_light = light "Передний левый габарит" {
                            properties {
                                amper 20
                            }
                            !include light.dsl
                        }
                        g10 = ground "g10"
                    }
                    group "Правая фара" {
                        right_low_beam = light "Правый ближний свет" {
                            properties {
                                amper 20
                            }
                            !include light.dsl
                        }
                        right_high_beam = light "Правый дальний свет" {
                            properties {
                                amper 20
                            }
                            !include light.dsl
                        }
                        front_right_side_light = light "Передний правый габарит" {
                            properties {
                                amper 20
                            }
                            !include light.dsl
                        }
                        g11 = ground "g11"
                    }
                }
            }

            group "Кабина" {
                group "Блок реле и предохранителей" {
                    #Реле
                    ignition_relay = relay "Реле зажигания" {
                        !include relay.dsl
                    }
                    g2 = ground "g2"

                    starter_relay = relay "Реле стартера" {
                        !include relay5.dsl
                    }
                    g3 = ground "g3"

                    coolant_vent_1_relay = relay "Реле э-вент охл ДВС 1" {
                        !include relay.dsl
                    }
                    coolant_vent_2_relay = relay "Реле э-вент охл ДВС 2" {
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

                    # Предохранители
                    starter_relay_fuse = fuse "Прд реле стартера." {
                        !include fuse.dsl
                    }
                    coolant_vent_1_fuse = fuse "Прд э-вент охл ДВС 1." {
                        !include fuse.dsl
                    }
                    coolant_vent_2_fuse = fuse "Прд э-вент охл ДВС 2." {
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
                }
                group "Блок приборов" {
                    internal_lighting = splitter "Система подсветки приборов" {
                        data = pin "pin"
                    }
                    coolant_control_light = light "Подсветка упр э-вент охл ДВС" {
                            properties {
                                amper 20
                            }
                        !include light.dsl
                    }
                    g9 = ground "g9"
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
                        V = pin "V"
                        L = pin "L"
                        H = pin "H"

                        I -> D {
                            tags "ctr,switch_ctr"
                            properties {
                                switch_state 1
                            }
                        }
                        I -> U {
                            tags "ctr,switch_ctr"
                            properties {
                                switch_state 2
                            }
                        }

                        V -> L {
                            tags "ctr,switch_ctr"
                            properties {
                                switch_state 1
                            }
                        }

                        L -> H {
                            tags "ctr,switch_ctr"
                            properties {
                                switch_state 2
                            }
                        }
                    }
                    g8 = ground "g8"
                }
                group "Подрулевые переключатели" {

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
                        properties {
                            amper 20
                        }
                        !include light.dsl
                    }
                }
                group "Правая задняя фара" {
                    rear_right_side_light = light "Задний правый габарит" {
                        properties {
                            amper 20
                        }
                        !include light.dsl
                    }
                }

                number_plate_light = light "Подсветка номера" {
                    properties {
                        amper 20
                    }
                    !include light.dsl
                }
                g16 = ground "g16"
            }

            #######################
            # Описание соединений #
            #######################
    
            # Система питания

            ground_switch.out -> g0
    
            akb.minus -> ground_switch.in
            akb.plus -> starter.plus
            akb.plus -> winch.plus

            # Система зажигания

            generator.plus -> starter.plus
    
            starter.plus -> ignition_relay_fuse.in
            starter.plus -> light_fuse.in
            starter.plus -> ignition_vent_fuse.in
            starter.plus -> fuse_90.in

            ignition_relay_fuse.out -> ignition_relay._30
            ignition_relay_fuse.out -> ignition_switch.in

            ignition_relay_fuse.out -> generator.v
    
            ignition_switch.out -> ignition_relay._85
            
            ignition_relay._86 -> g2
            ignition_relay._87 -> starter_relay_fuse.in
            
            starter_relay_fuse.out -> starter_relay._30
            starter_relay_fuse.out -> ignition.data
            starter_relay_fuse.out -> start_button.in
    
            start_button.out -> starter_relay._85
    
            starter_relay._86 -> g3
            starter_relay._87 -> starter.st
            starter_relay._88 -> control_line_from_ignition_fuse.in
            control_line_from_ignition_fuse.out -> control_line_from_ignition.data

            # Лебедка
        
            winch.minus -> g4

            # Электровентиляторы охлаждения ДВС

            coolant_vent_1.minus -> g5
            coolant_vent_1_fuse.out -> coolant_vent_1_relay._30
            coolant_vent_1_relay._87 -> coolant_vent_1.plus
            control_line_from_ignition.data -> coolant_vent_1_relay._85
            ignition_vent_fuse.out -> coolant_vent_1_fuse.in
            coolant_vent_1_relay._86 -> coolant_control_switch.I

            coolant_vent_2.minus -> g5
            coolant_vent_2_relay._87 -> coolant_vent_2.plus
            ignition_vent_fuse.out -> coolant_vent_2_fuse.in
            control_line_from_ignition.data -> coolant_vent_2_relay._85
            coolant_vent_2_fuse.out -> coolant_vent_2_relay._30
            coolant_vent_2_relay._86 -> coolant_control_switch.I

            coolant_sensor.out -> g7
            coolant_control_switch.D -> coolant_sensor.in
            coolant_control_switch.U -> g8
            coolant_control_light.plus -> coolant_control_switch.H
            internal_lighting.data -> coolant_control_light.plus
            coolant_control_light.minus -> g9
            coolant_control_switch.D -> coolant_control_light.minus

            # Ближний/дальний свет
            left_low_beam.minus -> g10
            right_low_beam.minus -> g11
            low_beam_relay._87 -> left_low_beam_fuse.in
            left_low_beam_fuse.out -> left_low_beam.plus
            low_beam_relay._87 -> right_low_beam_fuse.in
            right_low_beam_fuse.out -> right_low_beam.plus
            low_beam_relay_fuse.out -> low_beam_relay._30
            light_fuse.out -> low_beam_relay_fuse.in

            left_high_beam.minus -> g10
            right_high_beam.minus -> g11
            high_beam_relay._87 -> left_high_beam_fuse.in

            left_high_beam_fuse.out -> left_high_beam.plus
            high_beam_relay._87 -> right_high_beam_fuse.in
            right_high_beam_fuse.out -> right_high_beam.plus
            high_beam_relay_fuse.out -> high_beam_relay._30
            light_fuse.out -> high_beam_relay_fuse.in

            front_left_side_light.minus -> g10
            front_right_side_light.minus -> g11
            rear_left_side_light.minus -> g16
            rear_right_side_light.minus -> g16
            number_plate_light.minus -> g16


            side_light_relay._87 -> side_light_fuse.in
            side_light_fuse.out -> front_left_side_light.plus
            side_light_fuse.out -> front_right_side_light.plus
            side_light_fuse.out -> rear_left_side_light.plus
            side_light_fuse.out -> rear_right_side_light.plus
            side_light_fuse.out -> number_plate_light.plus
            side_light_relay_fuse.out -> side_light_relay._30
            light_fuse.out -> side_light_relay_fuse.in
        }

        !element es.low_beam_relay._85 {
            tags "non_root"
        }
        !element es.high_beam_relay._85 {
            tags "non_root"
        }
        !element es.side_light_relay._85 {
            tags "non_root"
        }
        !element es.internal_lighting.data {
            tags "non_root"
        }
        !element es.coolant_control_switch.V {
            tags "non_root"
        }
    }

    !script graph_validators.groovy

    views {
        properties {
            "structurizr.sort" "created"
        }

        #################
        # Описание вьюх #
        #################
        container es es_view "Общий вид электрической системы" {
            include *
            autolayout tb
        }

        component es.akb overall_component_view "Общий вид всех компонент" {
            include "element.type==component"
            include "element.type==container"
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
            relationship "square_50" {
                thickness 16
            }
            relationship "square_16" {
                thickness 14
            }
            relationship "square_6" {
                thickness 10
            }
            relationship "square_4" {
                thickness 9
            }
            relationship "square_2.5" {
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
            element "vent" {
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