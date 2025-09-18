workspace "Name" "Description" {

    !identifiers hierarchical

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }

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
        }

        es = softwareSystem "Электрическая система УАЗ" {

            g0 = ground "g0"
            g1 = ground "g1"
            g2 = ground "g2"
            g3 = ground "g3"
            g4 = ground "g4"
            g5 = ground "g5"
            g6 = ground "g6"
            g7 = ground "g7"
            g8 = ground "g8"
            g9 = ground "g9"
            g10 = ground "g10"
            g11 = ground "g11"
            g12 = ground "g12"
            g13 = ground "g13"
            g14 = ground "g14"
            g15 = ground "g15"
            g16 = ground "g16"
            g17 = ground "g17"
            g18 = ground "g18"


            ground_switch = switch "Размыкатель массы" {
                !include switch.dsl
            }

            power_group = group "Система питания" {
                akb = container "Аккумулятор" {
                    tags "akb"
                    plus = plus "+"
                    minus = minus "-"
                }

                starter = container "Стартер" {
                    tags "starter"
                    plus = plus "+"
                    st = component "Втяг. 20А" {
                        # Информация о мощности: https://forum.uazbuka.ru/showthread.php?t=40718
                    }
                }

                generator = container "Генератор" {
                    tags "generator"
                    plus = plus "+"
                    minus = minus "-"
                    v = component "Возб"
                }
            }

            group "Система зажигания" {
                ignition_relay = relay "Реле зажигания" {
                    !include relay.dsl
                }

                starter_relay = relay "Реле стартера" {
                    !include relay5.dsl
                }

                ignition_relay_fuse = fuse "Прд реле зажигания. 80A" {
                    tags "80А"
                    !include fuse.dsl
                }
                starter_relay_fuse = fuse "Прд реле стартера. 20A" {
                    tags "20А"
                    !include fuse.dsl
                }

                ignition_switch = switch "Выключатель зажигания" {
                    !include switch.dsl
                }

                ignition = container "Система зажигания" {
                    in = component "in" {
                        tags "ignition_connector,in,connector"
                    }
                }

                start_button = switch "Кнопка Старт" {
                    !include switch.dsl
                }
            }

            winch = container "Лебедка" {
                tags "winch"
                plus = plus "+"
                minus = minus "-"
            }

            other_from_akb_gen = container "прочие потребители от АКБ и генератора напрямую"
            control_line_from_ignition = container "Потребители управляющей линии от зажигания"
            control_line_from_ignition_fuse = fuse "Предохранитель потребителей управляющей линии от зажигания" {
                !include fuse.dsl
            }

            internal_lighting = container "Система подсветки приборов"

            group "Система охлаждения" {
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
                }


                coolant_vent_1_fuse = fuse "Прд э-вент охл ДВС 1. 20А" {
                    tags "20А"
                    !include fuse.dsl
                }

                coolant_vent_1_relay = relay "Реле э-вент охл ДВС 1" {
                    !include relay.dsl
                }

                coolant_vent_2_fuse = fuse "Прд э-вент охл ДВС 2. 20А" {
                    !include fuse.dsl
                }

                coolant_vent_2_relay = relay "Реле э-вент охл ДВС 2" {
                    !include relay.dsl
                }

                coolant_sensor = sensor "Датчик вкл э-вент охл ДВС" {
                    !include sensor.dsl
                }

                coolant_control_switch = switch "Переключатель упр э-вент охл ДВС" {
                    D = component "D"
                    I = component "I"
                    U = component "U"
                    V = component "V"
                    L = component "L"
                    H = component "H"
                }

                coolant_control_light = light "Подсветка упр э-вент охл ДВС" {
                    !include light.dsl
                }
            }


            group "Ближний,дальний свет" {
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
                    }
                }

                group "Задний блок фар" {
                    rear_left_side_light = light "Задний левый габарит" {
                        !include light.dsl
                    }
                    rear_right_side_light = light "Задний правый габарит" {
                        !include light.dsl
                    }
                    number_plate_light = light "Подсветка номера" {
                        !include light.dsl
                    }
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

            #######################
            # Описание соединений #
            #######################
    
            # Система питания

            ground_switch.out -> g0 "50 мм2" {
                tags "50мм2,red"
            }
    
            akb.minus -> ground_switch.in "50 мм2" {
                tags "50мм2,red"
            }
            akb.plus -> starter.plus "50 мм2" {
                tags "50мм2,red"
            }
            akb.plus -> winch.plus "50 мм2" {
                tags "50мм2,red"
            }

            # Система зажигания

            generator.minus -> g1 "50 мм2" {
                tags "50мм2,red"
            }
            generator.plus -> starter.plus "50 мм2" {
                tags "50мм2,red"
            }
    
            starter.plus -> ignition_relay_fuse.in "16 мм2" {
                tags "16мм2,red"
            }
    
            ignition_relay_fuse.out -> ignition_relay._30 "16 мм2" {
                tags "16мм2,red"
            }
            ignition_relay_fuse.out -> ignition_switch.in "0.5 мм2" {
                tags "0.5мм2,red"
            }
            ignition_relay_fuse.out -> other_from_akb_gen "16 мм2" {
                tags "16мм2,red"
            }
            ignition_relay_fuse.out -> generator.v "4 мм2" {
                tags "4мм2,red"
            }
    
            ignition_switch.out -> ignition_relay._85 "0.5 мм2" {
                tags "0.5мм2,red"
            }
            
            ignition_relay._86 -> g2 "0.5 мм2" {
                tags "0.5мм2,black"
            }
            ignition_relay._87 -> starter_relay_fuse.in "6 мм2" {
                tags "6мм2,black"
            }
            
            starter_relay_fuse.out -> starter_relay._30 "6 мм2" {
                tags "6мм2,black"
            }
            starter_relay_fuse.out -> ignition.in "4 мм2" {
                tags "4мм2,black"
            }
            starter_relay_fuse.out -> start_button.in "0.5 мм2" {
                tags "0.5мм2,red"
            }
    
            start_button.out -> starter_relay._85 "0.5 мм2" {
                tags "0.5мм2,red"
            }
    
            starter_relay._86 -> g3 "0.5 мм2" {
                tags "0.5мм2,black"
            }
            starter_relay._87 -> starter.st "6 мм2" {
                tags "6мм2,black"
            }
            starter_relay._88 -> control_line_from_ignition_fuse.in "6 мм2" {
                tags "6мм2,black"
            }
            control_line_from_ignition_fuse.out -> control_line_from_ignition

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
                tags "6мм2,blue"
            }
            control_line_from_ignition -> coolant_vent_1_relay._85 "0.5 мм2" {
                tags "0.5мм2,yellow"
            }
            other_from_akb_gen -> coolant_vent_1_fuse.in "6 мм2" {
                tags "6мм2,blue"
            }
            coolant_vent_1_relay._86 -> coolant_control_switch.I "0.5 мм2" {
                tags "0.5мм2,yellow"
            }

            coolant_vent_2.minus -> g6 "6 мм2" {
                tags "6мм2,black"
            }
            coolant_vent_2_relay._87 -> coolant_vent_2.plus "6 мм2" {
                tags "6мм2,blue"
            }
            other_from_akb_gen -> coolant_vent_2_fuse.in "6 мм2" {
                tags "6мм2,blue"
            }
            control_line_from_ignition -> coolant_vent_2_relay._85 "0.5 мм2" {
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
                tags "0.5мм2,green"
            }
            coolant_control_switch.U -> g8
            coolant_control_light.plus -> coolant_control_switch.H "0.5 мм2" {
                tags "0.5мм2,brown"
            }
            internal_lighting -> coolant_control_light.plus "0.5 мм2" {
                tags "0.5мм2,brown"
            }
            coolant_control_light.minus -> g9 "0.5 мм2" {
                tags "0.5мм2,black"
            }
            coolant_control_switch.D -> coolant_control_light.minus "0.5 мм2" {
                tags "0.5мм2,black"
            }

            # Ближний/дальний свет
            left_low_beam.minus -> g10 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            right_low_beam.minus -> g11 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            low_beam_relay._87 -> left_low_beam_fuse.in
            left_low_beam_fuse.out -> left_low_beam.plus "1.5 мм2" {
                tags "1.5мм2,white"
            }
            low_beam_relay._87 -> right_low_beam_fuse.in
            right_low_beam_fuse.out -> right_low_beam.plus
            low_beam_relay_fuse.out -> low_beam_relay._30
            other_from_akb_gen -> low_beam_relay_fuse.in

            left_high_beam.minus -> g12 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            right_high_beam.minus -> g13 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            high_beam_relay._87 -> left_high_beam_fuse.in
            left_high_beam_fuse.out -> left_high_beam.plus "1.5 мм2" {
                tags "1.5мм2,green"
            }
            high_beam_relay._87 -> right_high_beam_fuse.in
            right_high_beam_fuse.out -> right_high_beam.plus
            high_beam_relay_fuse.out -> high_beam_relay._30
            other_from_akb_gen -> high_beam_relay_fuse.in

            front_left_side_light.minus -> g14 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            front_right_side_light.minus -> g15 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            rear_left_side_light.minus -> g16 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            rear_right_side_light.minus -> g17 "1.5 мм2" {
                tags "1.5мм2,black"
            }
            number_plate_light.minus -> g18 "1.5 мм2" {
                tags "1.5мм2,black"
            }


            side_light_relay._87 -> side_light_fuse.in
            side_light_fuse.out -> front_left_side_light.plus "1.5 мм2" {
                tags "1.5мм2,brown"
            }
            side_light_fuse.out -> front_right_side_light.plus
            side_light_fuse.out -> rear_left_side_light.plus
            side_light_fuse.out -> rear_right_side_light.plus
            side_light_fuse.out -> number_plate_light.plus



            side_light_relay_fuse.out -> side_light_relay._30
            other_from_akb_gen -> side_light_relay_fuse.in
        }
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
            autolayout lr
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
                routing Curved
            }
            relationship "relay_pwr" {
                style dashed
                thickness 3
            }
            relationship "relay_ctr" {
                style dotted
            }
            relationship "red" {
                color #ff0000
            }
            relationship "black" {
                color #000000
            }
            relationship "blue" {
                color #0000ff
            }
            relationship "green" {
                color #00b300
            }
            relationship "brown" {
                color #977400
            }
            relationship "yellow" {
                color #ffff00
            }
            relationship "white" {
                color #fdf4d7
            }
            relationship "50мм2" {
                thickness 50
            }
            relationship "16мм2" {
                thickness 16
            }
            relationship "6мм2" {
                thickness 6
            }
            relationship "2.5мм2" {
                thickness 3
            }
            relationship "1.5мм2" {
                thickness 2
            }
            relationship "0.75мм2" {
                thickness 1
            }
            relationship "0.5мм2" {
                thickness 1
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
                height 100
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