workspace "Name" "Description" {

    !identifiers hierarchical

    model {

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
        }

        es = softwareSystem "Электрическая система УАЗ" {

            ground = container "Масса (корпус)" {
                tags "ground"
            }

            ground_switch = switch "Размыкатель массы" {
                !include switch.dsl
            }

            power_group = group "Система питания" {
                akb = container "Аккумулятор" {
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
                    !include fuse.dsl
                }
                starter_relay_fuse = fuse "Прд реле стартера. 80A" {
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

                coolant_vent_1 = container "Э-вент охл ДВС 1"{
                    tags "vent"
                    plus = plus "+"
                    minus = minus "-"
                }

                coolant_vent_1_fuse = fuse "Прд э-вент охл ДВС 1. 20А" {
                    !include fuse.dsl
                }

                coolant_vent_1_relay = relay "Реле э-вент охл ДВС 1" {
                    !include relay.dsl
                }

                coolant_vent_2 = container "Э-вент охл ДВС 2"{
                    tags "vent"
                    plus = plus "+"
                    minus = minus "-"
                }

                coolant_vent_2_fuse = fuse "Прд э-вент охл ДВС 2. 20А" {
                    !include fuse.dsl
                }

                coolant_vent_2_relay = relay "Реле э-вент охл ДВС 2" {
                    !include relay.dsl
                }

                coolant_sensor = container "Датчик вкл э-вент охл ДВС"

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

            #######################
            # Описание соединений #
            #######################
    
            ground_switch.out -> ground "50 мм2" {
                tags "50мм2"
            }
    
            akb.minus -> ground_switch.in "50 мм2" {
                tags "50мм2"
            }
            akb.plus -> starter.plus "50 мм2" {
                tags "50мм2,red"
            }
            akb.plus -> winch.plus "50 мм2" {
                tags "50мм2,red"
            }

    
            generator.minus -> ground "50 мм2" {
                tags "50мм2"
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
            ignition_relay_fuse.out -> ignition_switch.in "0.75 мм2" {
                tags "0.75мм2,red"
            }
            ignition_relay_fuse.out -> other_from_akb_gen "16 мм2" {
                tags "16мм2,red"
            }
            ignition_relay_fuse.out -> generator.v "4 мм2" {
                tags "4мм2,red"
            }
    
            ignition_switch.out -> ignition_relay._85 "0.75 мм2" {
                tags "0.75мм2,red"
            }
            
            ignition_relay._86 -> ground "0.75 мм2" {
                tags "0.75мм2,black"
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
            starter_relay_fuse.out -> start_button.in "0.75 мм2" {
                tags "0.75мм2,red"
            }
    
            start_button.out -> starter_relay._85 "0.75 мм2" {
                tags "0.75мм2,red"
            }
    
            starter_relay._86 -> ground
            starter_relay._87 -> starter.st "6 мм2" {
                tags "6мм2,black"
            }
            starter_relay._88 -> control_line_from_ignition_fuse.in "6 мм2" {
                tags "6мм2,black"
            }
            control_line_from_ignition_fuse.out -> control_line_from_ignition
        
            winch.minus -> ground "50 мм2" {
                tags "50мм2,black"
            }

            coolant_vent_1.minus -> ground
            coolant_vent_1_fuse.out -> coolant_vent_1_relay._30 "6 мм2" {
                tags "6мм2,blue"
            }
            coolant_vent_1_relay._87 -> coolant_vent_1.plus "6 мм2" {
                tags "6мм2,blue"
            }
            control_line_from_ignition -> coolant_vent_1_relay._85
            other_from_akb_gen -> coolant_vent_1_fuse.in "6 мм2" {
                tags "6мм2,blue"
            }
            coolant_vent_1_relay._86 -> coolant_control_switch.I

            coolant_vent_2.minus -> ground
            coolant_vent_2_relay._87 -> coolant_vent_2.plus "6 мм2" {
                tags "6мм2,blue"
            }
            other_from_akb_gen -> coolant_vent_2_fuse.in "6 мм2" {
                tags "6мм2,blue"
            }
            control_line_from_ignition -> coolant_vent_2_relay._85
            coolant_vent_2_fuse.out -> coolant_vent_2_relay._30 "6 мм2" {
                tags "6мм2,blue"
            }
            coolant_vent_2_relay._86 -> coolant_control_switch.I

            coolant_sensor -> ground
            coolant_sensor -> coolant_control_switch.D
            coolant_control_switch.U -> ground
            coolant_control_light.plus -> coolant_control_switch.H
            internal_lighting -> coolant_control_light.plus
            coolant_control_light.minus -> ground
            coolant_control_switch.D -> coolant_control_light.minus
        }
    }

    views {

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
            relationship "50мм2" {
                thickness 50
            }
            relationship "16мм2" {
                thickness 16
            }
            relationship "6мм2" {
                thickness 6
            }
            relationship "4мм2" {
                thickness 4
            }
            relationship "0.75мм2" {
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
            }

            element "vent" {
                shape "Hexagon"
                background #000000
            }
            element "starter" {
                icon "starter.jpg"
            }
            element "generator" {
                shape pipe
            }
            element "plus" {
                icon "plus.png"
                width 100
                metadata false
                description false
                shape Circle
                background #ff6f6f
            }
            element "minus" {
                icon "minus.png"
                width 100
                metadata false
                description false
                shape Circle
                background #727272
            }
            element "switch" {
                icon "switch.png"
                background #038803
            }
            element "fuse" {
                background #ff0000
                icon fuse.jpeg
            }
            element "relay" {
                background #0000bb
                icon relay.jpg
            }
            element "relay5" {
                background #0000bb
            }
            element "connector" {
                description false
                shape Box
                background #0000bb
            }
            element "light" {
                metadata false
                description false
                #width 100
                #height 100
                color #000000
                icon light.jpg
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
        scope softwaresystem
    }

}