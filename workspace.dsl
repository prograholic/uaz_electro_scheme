workspace "Name" "Description" {

    !identifiers hierarchical

    model {

        archetypes {
            relay = container {
                tags "relay"
            }
        }

        es = softwareSystem "Электрическая система УАЗ" {
            ground = container "Масса (корпус)" {
                tags "ground"
            }

            ground_switch = container "Размыкатель массы" {
                tags "switch"
            }

            akb = container "Аккумулятор" {
                plus = component "+" {
                    tags "plus"
                }
                minus = component "-" {
                    tags "minus"
                }
            }

            starter = container "Стартер" {
                tags "starter"
                plus = component "+" {
                    tags "plus"
                }
                st = component "Втяг"
            }

            generator = container "Генератор" {
                tags "generator"
                plus = component "+" {
                    tags "plus"
                }
                v = component "Возб"
            }
            
            ignition_relay = container "Реле зажигания" {
                !include relay.dsl
            }

            starter_relay = container "Реле стартера" {
                !include relay5.dsl
            }

            ignition_relay_fuse = container "Предохранитель для реле зажигания" {
                tags "fuse"
            }
            starter_relay_fuse = container "Предохранитель для реле стартера" {
                tags "fuse"
            }

            ignition_switch = container "Выключатель зажигания" {
                tags "switch"
            }

            ignition = container "Система зажигания"

            start_button = container "Кнопка Старт" {
                tags "switch"
            }

            winch = container "Лебедка" {
                plus = component "+" {
                    tags "plus"
                }
                minus = component "-" {
                    tags "minus"
                }
            }

            other_from_ignition = container "прочие потребители от зажигания"
            other_from_akb_gen = container "прочие потребители от АКБ и генератора напрямую"
            control_line_from_ignition = container "Потребители управляющей линии от зажигания"
            control_line_from_ignition_fuse = container "Предохранители потребителей управляющей линии от зажигания" {
                tags "fuse"
            }

            coolant_vent_1 = container "Электровентилятор охлаждения ДВС 1"{
                tags "vent"
            }

            coolant_vent_1_fuse = container "Предохранитель вентилятора охлаждения ДВС 1" {
                tags "fuse"
            }

            coolant_vent_1_relay = container "Реле электровентилятора охлаждения ДВС 1" {
                !include relay.dsl
            }

            coolant_vent_2 = container "Электровентилятор охлаждения ДВС 2"{
                tags "vent"
            }

            coolant_vent_2_fuse = container "Предохранитель вентилятора охлаждения ДВС 2" {
                tags "fuse"
            }

            coolant_vent_2_relay = container "Реле электровентилятора охлаждения ДВС 2" {
                !include relay.dsl
            }

            coolant_sensor = container "Датчик включения электровентиляторов охлаждения ДВС"

            coolant_control_switch = container "Переключатель управления вентиляторами охлаждения ДВС" {
                tags "switch"

                D = component "D"
                I = component "I"
                U = component "U"
                V = component "V"
                L = component "L"
                H = component "H"
            }

            #######################
            # Описание соединений #
            #######################
    
            ground_switch -> ground "50 мм2" {
                tags "50мм2"
            }
    
            akb.minus -> ground_switch "50 мм2" {
                tags "50мм2"
            }
            akb.plus -> starter.plus "50 мм2" {
                tags "50мм2"
                tags "red"
            }
            akb.plus -> winch.plus "50 мм2" {
                tags "50мм2"
                tags "red"
            }

    
            generator -> ground "50 мм2" {
                tags "50мм2"
            }
            generator.plus -> starter.plus "50 мм2" {
                tags "50мм2"
                tags "red"
            }
    
            starter.plus -> ignition_relay_fuse
    
            ignition_relay_fuse -> ignition_relay._30
            ignition_relay_fuse -> ignition_switch
            ignition_relay_fuse -> other_from_akb_gen
            ignition_relay_fuse -> generator.v
    
            ignition_switch -> ignition_relay._85
            
            ignition_relay._86 -> ground
            ignition_relay._87 -> starter_relay_fuse
            
            starter_relay_fuse -> starter_relay._30
            starter_relay_fuse -> ignition
            starter_relay_fuse -> other_from_ignition
            starter_relay_fuse -> start_button
    
            start_button -> starter_relay._85
    
            starter_relay._86 -> ground
            starter_relay._87 -> starter.st
            starter_relay._88 -> control_line_from_ignition_fuse
            control_line_from_ignition_fuse -> control_line_from_ignition
        
            winch.minus -> ground "50 мм2" {
                tags "50мм2"
                tags "black"
            }

            coolant_vent_1 -> ground
            coolant_vent_1_fuse -> coolant_vent_1
            coolant_vent_1_relay._87 -> coolant_vent_1_fuse
            control_line_from_ignition -> coolant_vent_1_relay._85
            other_from_akb_gen -> coolant_vent_1_relay._30
            coolant_vent_1_relay._86 -> coolant_control_switch.I

            coolant_vent_2 -> ground
            coolant_vent_2_fuse -> coolant_vent_2
            coolant_vent_2_relay._87 -> coolant_vent_2_fuse
            control_line_from_ignition -> coolant_vent_2_relay._85
            other_from_akb_gen -> coolant_vent_2_relay._30
            coolant_vent_2_relay._86 -> coolant_control_switch.I

            coolant_sensor -> ground
            coolant_sensor -> coolant_control_switch.D
            coolant_control_switch.U -> ground
            
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

        component es.akb  overall_component_view "Общий вид всех компонент" {
            include "element.type==component"
            include "element.type==container"
            autolayout lr
        }

        component es.akb {
            include "element.parent==es.akb"
            include "element.type==component && ->es.akb->"
            include "element.type==container && ->es.akb->"
            autolayout lr
        }

        component es.starter {
            include "element.parent==es.starter"
            include "element.type==component && ->es.starter->"
            include "element.type==container && ->es.starter->"
            autolayout lr
        }

        component es.generator {
            include "element.parent==es.generator"
            include "element.type==component && ->es.generator->"
            include "element.type==container && ->es.generator->"
            autolayout lr
        }

        component es.ignition_relay {
            include "element.parent==es.ignition_relay"
            include "element.type==component && ->es.ignition_relay->"
            include "element.type==container && ->es.ignition_relay->"
            autolayout lr
        }

        component es.starter_relay {
            include "element.parent==es.starter_relay"
            include "element.type==component && ->es.starter_relay->"
            include "element.type==container && ->es.starter_relay->"
            autolayout lr
        }

        component es.winch {
            include "element.parent==es.winch"
            include "element.type==component && ->es.winch->"
            include "element.type==container && ->es.winch->"
            autolayout lr
        }

        styles {

            #######################
            # Описание соединений #
            #######################

            relationship "Relationship" {
                style solid
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
            relationship "50мм2" {
                thickness 10
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
            element "relay_connector" {
                description false
                shape Box
                background #0000bb
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