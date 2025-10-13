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

        !include "archetypes.dsl"

        es = softwareSystem "Электрическая система УАЗ" {
            tags "electric_system"
            m = container "Кузов" {
                tags "chassis"
                ground = ground "Масса"
            }

            power_group = group "Подкапотное пространство" {
                ground_switch = switch "Размыкатель массы" {
                    !include "elements/switch.dsl"
                }
                akb = container "Аккумулятор" {
                    !include "elements/akb.dsl"
                }

                starter = container "Стартер" {
                    !include "elements/starter.dsl"
                }

                generator = container "Генератор" {
                    !include "elements/generator.dsl"
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
                    !include "elements/winch.dsl"
                }

                group "Блок силовых предохранителей" {
                    # Сюда преды на 60-60-40-90
                    ignition_relay_fuse = fuse "Прд реле зажигания" {
                        !include "elements/fuse.dsl"
                    }
                    light_fuse = fuse "Предохранитель освещения" {
                        !include "elements/fuse.dsl"
                    }
                    ignition_fan_fuse = fuse "Предохранитель зажигания и э-вент охл-я" {
                        !include "elements/fuse.dsl"
                    }

                    #fuse_90 = fuse "Предохранитель" {
                    #    !include "elements/fuse.dsl"
                    #}
                }

                group "Вентиляторы" {
                    coolant_fan_1 = fan "Э-вент охл ДВС 1"{
                        !include "elements/fan.dsl"
                    }
                    coolant_fan_2 = fan "Э-вент охл ДВС 2"{
                        !include "elements/fan.dsl"
                    }
                }

                coolant_sensor = sensor "Датчик вкл э-вент охл ДВС" {
                    !include "elements/sensor.dsl"
                }

                group "Передний блок фар" {
                    group "Левая фара" {
                        left_low_beam = light "Левый ближний свет" {
                            !include "elements/light.dsl"
                        }
                        left_high_beam = light "Левый дальний свет" {
                            !include "elements/light.dsl"
                        }
                        front_left_side_light = light "Передний левый габарит" {
                            !include "elements/light.dsl"
                        }
                        left_front_turn_signal = light "Левый передний поворотник" {
                            !include "elements/light.dsl"
                        }
                        left_turn_signal_repeater = light "Левый повторитель поворотника" {
                            !include "elements/light.dsl"
                        }
                    }
                    group "Правая фара" {
                        right_low_beam = light "Правый ближний свет" {
                            !include "elements/light.dsl"
                        }
                        right_high_beam = light "Правый дальний свет" {
                            !include "elements/light.dsl"
                        }
                        front_right_side_light = light "Передний правый габарит" {
                            !include "elements/light.dsl"
                        }
                        right_front_turn_signal = light "Правый передний поворотник" {
                            !include "elements/light.dsl"
                        }
                        right_turn_signal_repeater = light "Правый повторитель поворотника" {
                            !include "elements/light.dsl"
                        }
                    }
                }
            }

            group "Кабина" {
                heater = container "Отопитель салона" {
                    tags "heater"
                    !include "elements/electric_motor.dsl"
                }
                heater_resistor = resistor "Резистор печки салона" {
                    !include "elements/resistor.dsl"
                }

                interior_fan = fan "Вентилятор салона" {
                    !include "elements/fan.dsl"
                }
                wipers = container "Дворники" {
                    tags "wipers"
                    !include "elements/uaz/3151/wipers.dsl"
                }
                windshield_washer = container "Омыватель лобового стекла" {
                    tags "windshield_washer"
                    !include "elements/electric_motor.dsl"
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
                    !include "elements/sensor.dsl"
                }
                reverse_lamp_sensor = sensor "Датчик движения заднего хода" {
                    !include "elements/sensor.dsl"
                }

                group "Дополнительный свет" {
                    front_head_light = light "Передняя люстра" {
                        !include "elements/light.dsl"
                    }
                    rear_head_light = light "Задняя люстра" {
                        !include "elements/light.dsl"
                    }
                    left_head_light = light "Левая боковая люстра" {
                        !include "elements/light.dsl"
                    }
                    right_head_light = light "Правая боковая люстра" {
                        !include "elements/light.dsl"
                    }

                }
                group "Блок реле и предохранителей" {
                    #Реле
                    group "Блок реле" {
                        ignition_relay = relay "Реле зажигания" {
                            !include "elements/relay.dsl"
                        }
                        starter_relay = relay "Реле стартера" {
                            !include "elements/relay5.dsl"
                        }
                        coolant_fan_1_relay = relay "Реле э-вент охл ДВС 1" {
                            !include "elements/relay.dsl"
                        }
                        coolant_fan_2_relay = relay "Реле э-вент охл ДВС 2" {
                            !include "elements/relay.dsl"
                        }
                        low_beam_relay = relay "Реле ближнего света" {
                            !include "elements/relay.dsl"
                        }
                        high_beam_relay = relay "Реле дальнего света" {
                            !include "elements/relay.dsl"
                        }
                        side_light_relay = relay "Реле габаритов" {
                            !include "elements/relay.dsl"
                        }
                        turn_signal_relay = relay "Реле поворотников" {
                            !include "elements/uaz/3151/turn_signal_relay_950.dsl"
                        }
                        heater_relay_1 = relay "Реле отопителя (1-я скорость)" {
                            !include "elements/relay.dsl"
                        }
                        heater_relay_2 = relay "Реле отопителя (2-я скорость)" {
                            !include "elements/relay.dsl"
                        }
                        interior_fan_relay = relay "Реле вентилятора салона" {
                            !include "elements/relay.dsl"
                        }
                        wipers_relay = relay "Реле дворников" {
                            !include "elements/uaz/3151/wipers_relay.dsl"
                        }
                        windshield_washer_relay = relay "Реле моторчика омывайки" {
                            !include "elements/relay.dsl"
                        }

                        front_head_light_relay = relay "Реле передней люстры" {
                            !include "elements/relay.dsl"
                        }
                        rear_head_light_relay = relay "Реле задней люстры" {
                            !include "elements/relay.dsl"
                        }
                        left_head_light_relay = relay "Реле левой боковой люстры" {
                            !include "elements/relay.dsl"
                        }
                        right_head_light_relay = relay "Реле правой боковой люстры" {
                            !include "elements/relay.dsl"
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
                            !include "elements/fuse.dsl"
                        }
                        coolant_fan_1_fuse = fuse "Прд э-вент охл ДВС 1." {
                            !include "elements/fuse.dsl"
                        }
                        coolant_fan_2_fuse = fuse "Прд э-вент охл ДВС 2." {
                            !include "elements/fuse.dsl"
                        }
                        low_beam_relay_fuse = fuse "Прд. реле ближн света" {
                            !include "elements/fuse.dsl"
                        }
                        high_beam_relay_fuse = fuse "Прд. реле дальн света" {
                            !include "elements/fuse.dsl"
                        }
                        side_light_relay_fuse = fuse "Прд. реле габаритов" {
                            !include "elements/fuse.dsl"
                        }
                        left_low_beam_fuse = fuse "Прд. ближн света (лев)" {
                            !include "elements/fuse.dsl"
                        }
                        right_low_beam_fuse = fuse "Прд. ближн света (прав)" {
                            !include "elements/fuse.dsl"
                        }
                        left_high_beam_fuse = fuse "Прд. дальн света (лев)" {
                            !include "elements/fuse.dsl"
                        }
                        right_high_beam_fuse = fuse "Прд. дальн света (прав)" {
                            !include "elements/fuse.dsl"
                        }
                        side_light_fuse = fuse "Прд. габаритов" {
                            !include "elements/fuse.dsl"
                        }
                        turn_signal_fuse = fuse "Прд. поворотников" {
                            !include "elements/fuse.dsl"
                        }
                        front_head_light_fuse = fuse "Прд. передней люстры" {
                            !include "elements/fuse.dsl"
                        }
                        rear_head_light_fuse = fuse "Прд. задней люстры" {
                            !include "elements/fuse.dsl"
                        }
                        left_head_light_fuse = fuse "Прд. левой боковой люстры" {
                            !include "elements/fuse.dsl"
                        }
                        right_head_light_fuse = fuse "Прд. правой боковой люстры" {
                            !include "elements/fuse.dsl"
                        }
                        heater_fuse = fuse "Прд. отопителя" {
                            !include "elements/fuse.dsl"
                        }
                        interior_fan_fuse = fuse "Прд. вентилятора салона" {
                            !include "elements/fuse.dsl"
                        }
                        wipers_fuse = fuse "Прд. дворников" {
                            !include "elements/fuse.dsl"
                        }
                        windshield_washer_fuse = fuse "Прд. моторчика омывайки" {
                            !include "elements/fuse.dsl"
                        }
                    }
                }
                group "Блок приборов" {
                    internal_lighting = splitter "Система подсветки приборов" {
                        data = pin "pin"
                    }
                    coolant_control_light = light "Подсветка упр э-вент охл ДВС" {
                        !include "elements/light.dsl"
                    }

                    turn_signal_control_light = light "Контрольная лампа поворотников" {
                        !include "elements/light.dsl"
                    }
                }
                group "Блок выключателей" {
                    ignition_switch = switch "Выключатель зажигания" {
                        !include "elements/switch.dsl"
                    }
                    start_button = switch "Кнопка Старт" {
                        !include "elements/switch.dsl"
                    }
                    coolant_control_switch = switch "Переключатель упр э-вент охл ДВС" {
                        !include "elements/switch_3states_6pin.dsl"
                    }
                    light_switch = switch "Выключатель габаритов и ближнего света" {
                        !include "elements/uaz/3151/light_switch.dsl"
                    }
                    car_horn_switch = switch "Кнопка гудка" {
                    }
                    heater_switch = switch "Переключатель печки" {
                        !include "elements/switch_3states_6pin.dsl"
                    }
                    interior_fan_switch = switch "Выключатель салонного вентилятора" {
                        !include "elements/switch.dsl"
                    }

                    emergency_light_button = switch "Кнопка аварийной сигнализации" {
                        !include "elements/uaz/3151/emergency_light_button.dsl"
                    }

                    front_head_light_switch = switch "Выключатель передней люстры" {
                        !include "elements/switch.dsl"
                    }
                    rear_head_light_switch = switch "Выключатель задней люстры" {
                        !include "elements/switch.dsl"
                    }
                    left_head_light_switch = switch "Выключатель левой боковой люстры" {
                        !include "elements/switch.dsl"
                    }
                    right_head_light_switch = switch "Выключатель правой боковой люстры" {
                        !include "elements/switch.dsl"
                    }
                }
                group "Подрулевые переключатели" {
                    group "левый подрулевой переключатель" {
                        left_steering_column_light_switch = switch "Левый подрулевой переключатель освещения" {
                            !include "elements/uaz/3151/left_steering_column_light_switch.dsl"
                        }
                        left_steering_column_turn_signal_switch = switch "левый подрулевой переключатель поворотников" {
                            !include "elements/uaz/3151/left_steering_column_turn_signal_switch.dsl"
                        }
                    }
                    group "правый подрулевой переключатель" {
                        right_steering_column_switch = switch "правый подрулевой переключатель" {
                            !include "elements/uaz/3151/right_steering_column_switch.dsl"
                        }
                    }
                }
            }

            control_line_from_ignition = splitter "Потребители управляющей линии от зажигания" {
                data = pin "pin"
            }
            control_line_from_ignition_fuse = fuse "Предохранитель потребителей управляющей линии от зажигания" {
                !include "elements/fuse.dsl"
            }

            group "Задний блок фар" {
                group "Левая задняя фара" {
                    rear_left_side_light = light "Задний левый габарит" {
                        !include "elements/light.dsl"
                    }
                    left_rear_turn_signal = light "Левый задний поворотник" {
                        !include "elements/light.dsl"
                    }
                    left_stop_signal = light "Левый стоп-сигнал" {
                        !include "elements/light.dsl"
                    }
                }
                group "Правая задняя фара" {
                    rear_right_side_light = light "Задний правый габарит" {
                        !include "elements/light.dsl"
                    }
                    right_rear_turn_signal = light "Правый задний поворотник" {
                        !include "elements/light.dsl"
                    }
                    right_stop_signal = light "Правый стоп-сигнал" {
                        !include "elements/light.dsl"
                    }
                }

                number_plate_light = light "Подсветка номера" {
                    !include "elements/light.dsl"
                }
                reverse_lamp = light "Лампа заднего хода" {
                    !include "elements/light.dsl"
                }
                extra_stop_signal = light "Доп. стоп-сигнал" {
                    !include "elements/light.dsl"
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

            # Отопитель
            ignition_fan_fuse.out -> heater_fuse.in
            heater_fuse.out -> heater_relay_1._30
            heater_fuse.out -> heater_relay_2._30
            heater_relay_1._87 -> heater_resistor.in
            heater_resistor.out -> heater.plus
            heater_relay_2._87 -> heater.plus
            heater.minus -> m.ground

            control_line_from_ignition.data -> heater_switch.i
            heater_switch.d -> heater_relay_1._85
            heater_switch.u -> heater_relay_2._85

            heater_relay_1._86 -> m.ground
            heater_relay_2._86 -> m.ground

            # Вентилятор салона
            ignition_fan_fuse.out -> interior_fan_fuse.in
            interior_fan_fuse.out -> interior_fan_relay._30
            interior_fan_relay._87 -> interior_fan.plus
            interior_fan.minus -> m.ground

            control_line_from_ignition.data -> interior_fan_switch.in
            interior_fan_switch.out -> interior_fan_relay._85
            interior_fan_relay._86 -> m.ground


            # Дворники и передний омыватель
            ignition_fan_fuse.out -> wipers_fuse.in
            wipers_fuse.out -> wipers._1
            wipers._3 -> m.ground
            wipers._2 -> wipers_relay._15
            wipers_relay.S -> right_steering_column_switch._53e
            right_steering_column_switch._53 -> wipers._5
            right_steering_column_switch._53b -> wipers._6
            right_steering_column_switch.J -> wipers_relay.J
            wipers_relay._15 -> right_steering_column_switch._53a
            control_line_from_ignition.data -> right_steering_column_switch._53ah


            light_fuse.out -> windshield_washer_fuse.in
            windshield_washer_fuse.out -> windshield_washer_relay._30
            windshield_washer_relay._87 -> windshield_washer.plus
            windshield_washer_relay._87 -> wipers_relay._86

            right_steering_column_switch.W -> windshield_washer_relay._85
            windshield_washer_relay._86 -> m.ground
            windshield_washer.minus -> m.ground


            wipers_relay._31b -> wipers._4
            wipers_relay._31 -> m.ground
        }

        // Set amper
        !include "set_consumer_amper.dsl"
        !include "switch_states.dsl"
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
            autolayout lr
        }

        component es.akb overall_component_view "Общий вид всех компонент" {
            include "element.type==component"
            include "element.type==container"
            exclude es.m.ground
            autolayout lr
        }

        !script all_components_view.groovy

        styles {
            !include "styles/relationships.dsl"
            !include "styles/elements.dsl"
        }
    }
}