workspace "Name" "Description" {

    !identifiers hierarchical

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }

#        !impliedRelationships false

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

            plus = component {
                tags "plus"
            }

            minus = component {
                tags "minus"
            }
            ground = container {
                tags "ground"
            }
            sensor = container {
                tags "sensor"
            }
            splitter = container {
                tags "splitter"
            }
        }

        es = softwareSystem "Электрическая система УАЗ" {
            power_group = group "Подкапотное пространство" {
                ground_switch = switch "Размыкатель массы" {
                    !include switch.dsl
                }
                g0 = ground "g0"
                akb = container "Аккумулятор" {
                    tags "akb;power_source"
                    plus = plus "+"
                    minus = minus "-"
                }

                starter = container "Стартер" {
                    tags "starter"
                    plus = plus "+"
                    st = component "Втяг" {
                        properties {
                            # Информация о мощности: https://forum.uazbuka.ru/showthread.php?t=40718
                            amper 20
                        }
                    }
                }

                generator = container "Генератор" {
                    tags "generator;power_source"
                    plus = plus "+"
                    minus = minus "-"
                    v = component "Возб"
                }
                g1 = ground "g1"

                ignition = container "Система зажигания" {
                    in = component "in" {
                        tags "ignition_connector,in,connector"
                    }
                }

                winch = container "Лебедка" {
                    tags "winch"
                    plus = plus "+"
                    minus = minus "-"
                }
                g4 = ground "g4"

                group "Блок силовых предохранителей" {
                    # Сюда преды на 60-60-40-90
                    ignition_relay_fuse = fuse "Прд реле зажигания. 40A" {
                        tags "40А"
                        !include fuse.dsl
                    }
                    light_fuse = fuse "Предохранитель штатного освещения. 60А" {
                        tags "60А"
                        !include fuse.dsl
                    }
                    ignition_vent_fuse = fuse "Предохранитель зажигания и э-вент охл-я. 60А" {
                        tags "60А"
                        !include fuse.dsl
                    }

                    fuse_90 = fuse "Предохранитель 90А" {
                        tags "90А"
                        !include fuse.dsl
                    }
                }

                group "Вентиляторы" {
                    coolant_vent_1 = container "Э-вент охл ДВС 1"{
                        tags "vent"
                        plus = plus "+"
                        minus = minus "-"
                    }
                    coolant_vent_2 = container "Э-вент охл ДВС 2"{
                        tags "vent"
                        plus = plus "+"
                        minus = minus "-"
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
                            !include light.dsl
                        }
                        left_high_beam = light "Левый дальний свет" {
                            !include light.dsl
                        }
                        front_left_side_light = light "Передний левый габарит" {
                            !include light.dsl
                        }
                        g10 = ground "g10"
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
                    starter_relay_fuse = fuse "Прд реле стартера. 20A" {
                        tags "20А"
                        !include fuse.dsl
                    }
                    coolant_vent_1_fuse = fuse "Прд э-вент охл ДВС 1. 20А" {
                        tags "20А"
                        !include fuse.dsl
                    }
                    coolant_vent_2_fuse = fuse "Прд э-вент охл ДВС 2. 20А" {
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
                        data = component "connector"
                    }
                    coolant_control_light = light "Подсветка упр э-вент охл ДВС" {
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
                        D = component "D"
                        I = component "I"
                        U = component "U"
                        V = component "V"
                        L = component "L"
                        H = component "H"

                        I -> D {
                            properties {
                                state 1
                            }
                        }
                        I -> U {
                            properties {
                                state 2
                            }
                        }

                        V -> L {
                            properties {
                                state 1
                            }
                        }

                        L -> H {
                            properties {
                                state 2
                            }
                        }
                    }
                    g8 = ground "g8"
                }
                group "Подрулевые переключатели" {

                }
            }

            control_line_from_ignition = splitter "Потребители управляющей линии от зажигания" {
                data = component "connector"
            }
            control_line_from_ignition_fuse = fuse "Предохранитель потребителей управляющей линии от зажигания" {
                !include fuse.dsl
            }

            group "Задний блок фар" {
                group "Левая задняя фара" {
                    rear_left_side_light = light "Задний левый габарит" {
                        !include light.dsl
                    }
                }
                group "Правая задняя фара" {
                    rear_right_side_light = light "Задний правый габарит" {
                        !include light.dsl
                    }
                }

                number_plate_light = light "Подсветка номера" {
                    !include light.dsl
                }
                g16 = ground "g16"
            }

            #######################
            # Описание соединений #
            #######################
    
            # Система питания

            ground_switch.out -> g0 {
                properties {
                    square 50
                    color black
                }
            }
    
            akb.minus -> ground_switch.in {
                properties {
                    square 50
                    color black
                }
            }
            akb.plus -> starter.plus {
                properties {
                    square 50
                    color red
                }
            }
            akb.plus -> winch.plus {
                properties {
                    square 50
                    color red
                }
            }

            # Система зажигания

            generator.minus -> g1 {
                properties {
                    square 50
                    color red
                }
            }
            generator.plus -> starter.plus {
                properties {
                    square 50
                    color red
                }
            }
    
            starter.plus -> ignition_relay_fuse.in {
                properties {
                    square 16
                    color red
                }
            }
            starter.plus -> light_fuse.in {
                properties {
                    square 16
                    color red
                }
            }
            starter.plus -> ignition_vent_fuse.in {
                properties {
                    square 16
                    color red
                }
            }
            starter.plus -> fuse_90.in {
                properties {
                    square 16
                    color red
                }
            }

            ignition_relay_fuse.out -> ignition_relay._30 {
                properties {
                    square 16
                    color red
                }
            }
            ignition_relay_fuse.out -> ignition_switch.in {
                properties {
                    square 0.5
                    color red
                }
            }

            ignition_relay_fuse.out -> generator.v {
                properties {
                    square 4
                    color red
                }
            }
    
            ignition_switch.out -> ignition_relay._85 {
                properties {
                    square 0.5
                    color green
                }
            }
            
            ignition_relay._86 -> g2 {
                properties {
                    square 0.5
                    color black
                }
            }
            ignition_relay._87 -> starter_relay_fuse.in {
                properties {
                    square 6
                    color red
                }
            }
            
            starter_relay_fuse.out -> starter_relay._30 {
                properties {
                    square 6
                    color blue
                }
            }
            starter_relay_fuse.out -> ignition.in {
                properties {
                    square 4
                    color black
                }
            }
            starter_relay_fuse.out -> start_button.in {
                properties {
                    square 0.5
                    color red
                }
            }
    
            start_button.out -> starter_relay._85 {
                properties {
                    square 0.5
                    color green
                }
            }
    
            starter_relay._86 -> g3 {
                properties {
                    square 0.5
                    color black
                }
            }
            starter_relay._87 -> starter.st {
                properties {
                    square 6
                    color red
                }
            }
            starter_relay._88 -> control_line_from_ignition_fuse.in "6 мм2" {
                tags "6мм2,black"
            }
            control_line_from_ignition_fuse.out -> control_line_from_ignition.data

            # Лебедка
        
            winch.minus -> g4 "50 мм2" {
                tags "50мм2,black"
            }

            # Электровентиляторы охлаждения ДВС

            coolant_vent_1.minus -> g5 "6 мм2" {
                tags "6мм2,black"
            }
            coolant_vent_1_fuse.out -> coolant_vent_1_relay._30 "6 мм2" {
                tags "6мм2,blue"
            }
            coolant_vent_1_relay._87 -> coolant_vent_1.plus "6 мм2" {
                tags "6мм2,green"
            }
            control_line_from_ignition.data -> coolant_vent_1_relay._85 "0.5 мм2" {
                tags "0.5мм2,yellow"
            }
            ignition_vent_fuse.out -> coolant_vent_1_fuse.in "6 мм2" {
                tags "6мм2,brown"
            }
            coolant_vent_1_relay._86 -> coolant_control_switch.I "0.5 мм2" {
                tags "0.5мм2,brown"
            }

            coolant_vent_2.minus -> g5 "6 мм2" {
                tags "6мм2,black"
            }
            coolant_vent_2_relay._87 -> coolant_vent_2.plus "6 мм2" {
                tags "6мм2,blue"
            }
            ignition_vent_fuse.out -> coolant_vent_2_fuse.in "6 мм2" {
                tags "6мм2,yellow"
            }
            control_line_from_ignition.data -> coolant_vent_2_relay._85 "0.5 мм2" {
                tags "0.5мм2,yellow"
            }
            coolant_vent_2_fuse.out -> coolant_vent_2_relay._30 "6 мм2" {
                tags "6мм2,blue"
            }
            coolant_vent_2_relay._86 -> coolant_control_switch.I "0.5 мм2" {
                tags "0.5мм2,yellow"
            }

            coolant_sensor.out -> g7
            coolant_sensor.in -> coolant_control_switch.D "0.5 мм2" {
                tags "0.5мм2,white"
            }
            coolant_control_switch.U -> g8
            coolant_control_light.plus -> coolant_control_switch.H "0.5 мм2" {
                tags "0.5мм2,red"
            }
            internal_lighting.data -> coolant_control_light.plus "0.5 мм2" {
                tags "0.5мм2,brown"
            }
            coolant_control_light.minus -> g9 "0.5 мм2" {
                tags "0.5мм2,black"
            }
            coolant_control_switch.D -> coolant_control_light.minus "0.5 мм2" {
                tags "0.5мм2,green"
            }

            # Ближний/дальний свет
            left_low_beam.minus -> g10 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            right_low_beam.minus -> g11 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            low_beam_relay._87 -> left_low_beam_fuse.in "1.5 мм2" {
                tags "1.5мм2,green"
            }
            left_low_beam_fuse.out -> left_low_beam.plus "1.5 мм2" {
                tags "1.5мм2,white"
            }
            low_beam_relay._87 -> right_low_beam_fuse.in "1.5 мм2" {
                tags "1.5мм2,blue"
            }
            right_low_beam_fuse.out -> right_low_beam.plus "1.5 мм2" {
                tags "1.5мм2,yellow"
            }
            low_beam_relay_fuse.out -> low_beam_relay._30 "2.5 мм2" {
                tags "2.5мм2,brown"
            }
            light_fuse.out -> low_beam_relay_fuse.in "2.5 мм2" {
                tags "2.5мм2,red"
            }

            left_high_beam.minus -> g10 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            right_high_beam.minus -> g11 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            high_beam_relay._87 -> left_high_beam_fuse.in "1.5 мм2" {
                tags "1.5мм2,white"
            }
            left_high_beam_fuse.out -> left_high_beam.plus "1.5 мм2" {
                tags "1.5мм2,green"
            }
            high_beam_relay._87 -> right_high_beam_fuse.in "1.5 мм2" {
                tags "1.5мм2,brown"
            }
            right_high_beam_fuse.out -> right_high_beam.plus "1.5 мм2" {
                tags "1.5мм2,red"
            }
            high_beam_relay_fuse.out -> high_beam_relay._30 "2.5 мм2" {
                tags "2.5мм2,green"
            }
            light_fuse.out -> high_beam_relay_fuse.in "2.5 мм2" {
                tags "2.5мм2,yellow"
            }

            front_left_side_light.minus -> g10 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            front_right_side_light.minus -> g11 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            rear_left_side_light.minus -> g16 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            rear_right_side_light.minus -> g16 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            number_plate_light.minus -> g16 "1.5 мм2" {
                tags "1.5мм2,black"
            }


            side_light_relay._87 -> side_light_fuse.in "1.5 мм2" {
                tags "1.5мм2,red"
            }
            side_light_fuse.out -> front_left_side_light.plus "1.5 мм2" {
                tags "1.5мм2,brown"
            }
            side_light_fuse.out -> front_right_side_light.plus "1.5 мм2" {
                tags "1.5мм2,green"
            }
            side_light_fuse.out -> rear_left_side_light.plus "1.5 мм2" {
                tags "1.5мм2,blue"
            }
            side_light_fuse.out -> rear_right_side_light.plus "1.5 мм2" {
                tags "1.5мм2,yellow"
            }
            side_light_fuse.out -> number_plate_light.plus "1.5 мм2" {
                tags "1.5мм2,white"
            }
            side_light_relay_fuse.out -> side_light_relay._30 "1.5 мм2" {
                tags "1.5мм2,red"
            }
            light_fuse.out -> side_light_relay_fuse.in "1.5 мм2" {
                tags "1.5мм2,brown"
            }
        }

        !script deduce_wire_square.groovy
    }

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
            element "Container" {
                background #0773af
                metadata false
                fontSize 1
            }
            element "connector" {
                description false
                shape Box
                background #0000bb
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

    configuration {
        scope none
    }

}