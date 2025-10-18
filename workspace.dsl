workspace "Name" "Description" {

    !identifiers hierarchical

    configuration {
        scope none
    }

    model {
        properties {
            "structurizr.groupSeparator" "/"
            "default_voltage" "13.8"
            "max_voltage_drop" "0.5"
            "wire_relative_resistance" "0.018"
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
                    power_fuse_splitter = splitter "Разветвитель силовых предохранителей" {
                        pin = pin "pin"
                    }
                    # Сюда преды на 60-60-40-90
                    ignition_relay_fuse = fuse "Прд реле зажигания" {
                        !include "elements/fuse.dsl"
                    }
                    light_fuse = fuse "Предохранитель освещения" {
                        !include "elements/fuse.dsl"
                    }
                    ignition_fan_fuse = fuse "Предохранитель охл-я, отопителя, дворники, гудок" {
                        !include "elements/fuse.dsl"
                    }

                    fuse_xxx = fuse "Предохранитель" {
                        !include "elements/fuse.dsl"
                    }
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

                car_horn = container "Гудок" {
                    !include "elements/car_horn.dsl"
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

                    head_light_splitter = splitter "Разветвитель питания доп. света" {
                        pin = pin "pin"
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
                        car_horn_relay = relay "Реле гудка" {
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
                    side_light_splitter = splitter "разветвитель габаритов" {
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
                        car_horn_fuse = fuse "Прд. гудка" {
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

                    car_horn_switch = switch "Кнопка гудка" {
                        !include "elements/switch.dsl"
                    }

                    heater_switch = switch "Переключатель печки" {
                        !include "elements/switch_3states_6pin.dsl"
                    }
                    interior_fan_switch = switch "Выключатель салонного вентилятора" {
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

            control_line_from_ignition_1 = splitter "Потребители управляющей линии от зажигания (свет)" {
                pin = pin "pin"
            }
            control_line_from_ignition_2 = splitter "Потребители управляющей линии от зажигания (прочее)" {
                pin = pin "pin"
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

                stop_signal_splitter = splitter "разветвитель стоп сигналов" {
                    pin = pin "pin"
                }
            }

            #######################
            # Описание соединений #
            #######################
    
            # Система питания

            m.ground -> ground_switch.in {
                # Прикручено к корпусу
                tags "internal_connection"
            }
            ground_switch.out -> akb.minus {
                tags "foreign_color"
                properties {
                    #distance 0.2
                    color "0"
                }
            }
            akb.plus -> starter.plus {
                tags "foreign_color"
                properties {
                    #distance 0.5
                    color "1"
                }
            }
            akb.plus -> winch.plus {
                tags "foreign_color"
                properties {
                    #distance 1.0
                    color "1"
                }
            }
            akb.plus -> power_fuse_splitter.pin {
                tags "foreign_color"
                properties {
                    #distance 1.0
                    color "1"
                }
            }


            # Система зажигания

            generator.plus -> starter.plus {
                tags "foreign_color"
                properties {
                    #distance 1.0
                    color "1"
                }
            }
            m.ground -> generator.minus {
                properties {
                    color "0"
                    distance 0.1
                }
            }
    
            power_fuse_splitter.pin -> ignition_relay_fuse.in {
                properties {
                    color "2"
                }
            }
            power_fuse_splitter.pin -> light_fuse.in {
                tags "foreign_color"
                properties {
                    color "1"
                }
            }
            power_fuse_splitter.pin -> ignition_fan_fuse.in {
                properties {
                    color "4"
                }
            }
            power_fuse_splitter.pin -> fuse_xxx.in {
                properties {
                    color "5"
                }
            }

            ignition_relay_fuse.out -> ignition_relay._30 {
                properties {
                    color "4"
                }
            }
            ignition_relay_fuse.out -> ignition_switch.in {
                properties {
                    color "1"
                }
            }

            ignition_relay_fuse.out -> generator.v {
                properties {
                    color "3"
                }
            }
    
            ignition_switch.out -> ignition_relay._85 {
                properties {
                    color "2"
                }
            }
            
            ignition_relay._86 -> m.ground {
                properties {
                    distance 0.1
                    color "0"
                }
            }
            ignition_relay._87 -> starter_relay_fuse.in {
                properties {
                    distance 0.2
                    color "3"
                }
            }
            
            starter_relay_fuse.out -> starter_relay._30 {
                properties {
                    distance 0.2
                    color "1"
                }
            }
            starter_relay_fuse.out -> ignition.data {
                properties {
                    color "0"
                }
            }
            starter_relay_fuse.out -> start_button.in {
                properties {
                    color "2"
                }
            }
    
            start_button.out -> starter_relay._85 {
                properties {
                    color "3"
                }
            }
    
            starter_relay._86 -> m.ground {
                properties {
                    color "0"
                }
            }
            starter_relay._87 -> starter.st {
                properties {
                    color "6"
                }
            }
            starter_relay._88 -> control_line_from_ignition_fuse.in {
                properties {
                    color "5"
                }
            }
            control_line_from_ignition_fuse.out -> control_line_from_ignition_1.pin {
                properties {
                    color "1"
                }
            }
            control_line_from_ignition_fuse.out -> control_line_from_ignition_2.pin {
                properties {
                    color "2"
                }
            }


            # Лебедка
        
            winch.minus -> m.ground {
                properties {
                    distance 1.5
                    color "0"
                }
            }
            # Электровентиляторы охлаждения ДВС

            coolant_fan_1.minus -> m.ground {
                properties {
                    distance 0.2
                    color "0"
                }
            }
            coolant_fan_1_fuse.out -> coolant_fan_1_relay._30 {
                properties {
                    distance 0.2
                    color "1"
                }
            }
            coolant_fan_1_relay._87 -> coolant_fan_1.plus {
                properties {
                    color "2"
                }
            }
            control_line_from_ignition_2.pin -> coolant_fan_1_relay._85 {
                properties {
                    color "3"
                }
            }
            ignition_fan_fuse.out -> coolant_fan_1_fuse.in {
                properties {
                    color "0"
                }
            }
            coolant_fan_1_relay._86 -> coolant_control_switch.I {
                properties {
                    distance 0.5
                    color "7"
                }
            }

            coolant_fan_2.minus -> m.ground {
                properties {
                    distance 0.2
                    color "0"
                }
            }
            coolant_fan_2_relay._87 -> coolant_fan_2.plus {
                properties {
                    color "1"
                }
            }
            ignition_fan_fuse.out -> coolant_fan_2_fuse.in {
                properties {
                    color "1"
                }
            }
            control_line_from_ignition_2.pin -> coolant_fan_2_relay._85 {
                properties {
                    color "6"
                }
            }
            coolant_fan_2_fuse.out -> coolant_fan_2_relay._30 {
                properties {
                    color "3"
                }
            }
            coolant_fan_2_relay._86 -> coolant_control_switch.I {
                properties {
                    color "5"
                }
            }

            coolant_sensor.out -> m.ground {
                tags "internal_connection"
            }
            coolant_control_switch.D -> coolant_sensor.in {
                properties {
                    color "1"
                }
            }
            coolant_control_switch.U -> m.ground {
                properties {
                    distance 0.2
                    color "0"
                }
            }
            internal_lighting.data -> coolant_control_light.plus {
                properties {
                    color "3"
                }
            }
            coolant_control_light.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            coolant_control_switch.D -> coolant_control_light.minus {
                properties {
                    color "2"
                }
            }

            # Ближний/дальний свет
            control_line_from_ignition_1.pin -> left_steering_column_light_switch._30 {
                properties {
                    color "9"
                }
            }
            left_steering_column_light_switch._56a -> high_beam_relay._85 {
                properties {
                    color "1"
                }
            }
            left_steering_column_light_switch._56b -> low_beam_relay._85 {
                properties {
                    color "4"
                }
            }

            control_line_from_ignition_1.pin -> light_switch.x {
                properties {
                    color "0"
                }
            }
            light_fuse.out -> light_switch._30 {
                properties {
                    color "3"
                }
            }
            light_switch._58 -> internal_lighting.data {
                properties {
                    color "1"
                }
            }
            light_switch._56 -> left_steering_column_light_switch._56 {
                properties {
                    color "2"
                }
            }
            light_switch._58 -> side_light_relay._85 {
                properties {
                    color "4"
                }
            }

            left_low_beam.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            right_low_beam.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            low_beam_relay._86 -> m.ground {
                properties {
                    color "0"
                }
            }
            low_beam_relay._87 -> left_low_beam.plus {
                properties {
                    color "2"
                }
            }
            low_beam_relay._87 -> right_low_beam.plus {
                properties {
                    color "3"
                }
            }
            low_beam_relay_fuse.out -> low_beam_relay._30 {
                properties {
                    color "1"
                }
            }
            light_fuse.out -> low_beam_relay_fuse.in {
                properties {
                    color "9"
                }
            }

            left_high_beam.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            right_high_beam.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            high_beam_relay._87 -> left_high_beam.plus {
                properties {
                    color "2"
                }
            }
            high_beam_relay._86 -> m.ground {
                properties {
                    color "0"
                }
            }

            high_beam_relay._87 -> right_high_beam.plus {
                properties {
                    color "3"
                }
            }
            high_beam_relay_fuse.out -> high_beam_relay._30 {
                properties {
                    color "4"
                }
            }
            light_fuse.out -> high_beam_relay_fuse.in {
                properties {
                    color "2"
                }
            }

            front_left_side_light.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            front_right_side_light.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            rear_left_side_light.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            rear_right_side_light.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            number_plate_light.minus -> m.ground {
                properties {
                    color "0"
                }
            }

            left_front_turn_signal.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            left_turn_signal_repeater.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            left_rear_turn_signal.minus -> m.ground {
                properties {
                    color "0"
                }
            }

            right_front_turn_signal.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            right_turn_signal_repeater.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            right_rear_turn_signal.minus -> m.ground {
                properties {
                    color "0"
                }
            }


            side_light_relay._86 -> m.ground {
                properties {
                    color "0"
                }
            }
            side_light_relay._87 -> side_light_splitter.pin {
                properties {
                    color "2"
                }
            }
            side_light_splitter.pin -> front_left_side_light.plus {
                properties {
                    color "1"
                }
            }
            side_light_splitter.pin -> front_right_side_light.plus {
                properties {
                    color "3"
                }
            }
            side_light_splitter.pin -> rear_left_side_light.plus {
                properties {
                    color "4"
                }
            }
            side_light_splitter.pin -> rear_right_side_light.plus {
                properties {
                    color "5"
                }
            }
            side_light_splitter.pin -> number_plate_light.plus {
                properties {
                    color "6"
                }
            }
            side_light_relay_fuse.out -> side_light_relay._30 {
                properties {
                    color "3"
                }
            }
            light_fuse.out -> side_light_relay_fuse.in {
                properties {
                    color "4"
                }
            }

            # Поворотники и аварийка
            light_fuse.out -> turn_signal_fuse.in {
                properties {
                    color "5"
                }
            }
            turn_signal_relay.p -> left_steering_column_turn_signal_switch._49a {
                properties {
                    color "2"
                }
            }
            turn_signal_relay.p -> emergency_light_button.p {
                properties {
                    color "1"
                }
            }
            turn_signal_relay.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            left_steering_column_turn_signal_switch._49aR -> turn_signal_relay.pb {
                properties {
                    color "3"
                }
            }
            emergency_light_button.pb -> turn_signal_relay.pb {
                properties {
                    color "4"
                }
            }
            left_steering_column_turn_signal_switch._49aL -> turn_signal_relay.lb {
                properties {
                    color "5"
                }
            }
            emergency_light_button.lb -> turn_signal_relay.lb {
                properties {
                    color "6"
                }
            }
            turn_signal_relay.kt -> turn_signal_control_light.plus {
                properties {
                    color "7"
                }
            }
            turn_signal_control_light.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            turn_signal_relay.right -> right_turn_signal_splitter.pin {
                properties {
                    color "8"
                }
            }
            turn_signal_relay.left -> left_turn_signal_splitter.pin {
                properties {
                    color "9"
                }
            }

            emergency_light_button.plus -> turn_signal_relay.plus {
                properties {
                    color "10"
                }
            }

            # TODO тут питание должно приходить только при включенном зажигании - значит нужно поставить реле
            turn_signal_fuse.out -> emergency_light_button.pow {
                properties {
                    color "2"
                }
            }
            turn_signal_fuse.out -> emergency_light_button.emer {
                properties {
                    color "3"
                }
            }


            right_turn_signal_splitter.pin -> right_front_turn_signal.plus {
                properties {
                    color "1"
                }
            }
            right_turn_signal_splitter.pin -> right_turn_signal_repeater.plus {
                properties {
                    color "2"
                }
            }
            right_turn_signal_splitter.pin -> right_rear_turn_signal.plus {
                properties {
                    color "3"
                }
            }

            left_turn_signal_splitter.pin -> left_front_turn_signal.plus {
                properties {
                    color "1"
                }
            }
            left_turn_signal_splitter.pin -> left_turn_signal_repeater.plus {
                properties {
                    color "2"
                }
            }
            left_turn_signal_splitter.pin -> left_rear_turn_signal.plus {
                properties {
                    color "3"
                }
            }



            # Передняя люстра
            light_fuse.out -> head_light_splitter.pin {
                properties {
                    color "7"
                }
            }
            head_light_splitter.pin -> front_head_light_fuse.in {
                properties {
                    color "6"
                }
            }
            front_head_light_fuse.out -> front_head_light_relay._30 {
                properties {
                    color "1"
                }
            }
            front_head_light_relay._87 -> front_head_light.plus {
                properties {
                    color "2"
                }
            }
            front_head_light.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            control_line_from_ignition_1.pin -> front_head_light_switch.in {
                properties {
                    color "5"
                }
            }
            front_head_light_switch.out -> front_head_light_relay._85 {
                properties {
                    color "3"
                }
            }
            front_head_light_relay._86 -> m.ground {
                properties {
                    color "0"
                }
            }


            # Задняя люстра
            head_light_splitter.pin -> rear_head_light_fuse.in {
                properties {
                    color "0"
                }
            }
            rear_head_light_fuse.out -> rear_head_light_relay._30 {
                properties {
                    color "1"
                }
            }
            rear_head_light_relay._87 -> rear_head_light.plus {
                properties {
                    color "2"
                }
            }
            rear_head_light.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            control_line_from_ignition_1.pin -> rear_head_light_switch.in {
                properties {
                    color "10"
                }
            }
            rear_head_light_switch.out -> rear_head_light_relay._85 {
                properties {
                    color "3"
                }
            }
            rear_head_light_relay._86 -> m.ground {
                properties {
                    color "0"
                }
            }

            # Левая боковая люстра
            head_light_splitter.pin -> left_head_light_fuse.in {
                properties {
                    color "1"
                }
            }
            left_head_light_fuse.out -> left_head_light_relay._30 {
                properties {
                    color "2"
                }
            }
            left_head_light_relay._87 -> left_head_light.plus {
                properties {
                    color "1"
                }
            }
            left_head_light.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            control_line_from_ignition_1.pin -> left_head_light_switch.in {
                properties {
                    color "2"
                }
            }
            left_head_light_switch.out -> left_head_light_relay._85 {
                properties {
                    color "3"
                }
            }
            left_head_light_relay._86 -> m.ground {
                properties {
                    color "0"
                }
            }


            # Задняя люстра
            head_light_splitter.pin -> right_head_light_fuse.in {
                properties {
                    color "2"
                }
            }
            right_head_light_fuse.out -> right_head_light_relay._30 {
                properties {
                    color "1"
                }
            }
            right_head_light_relay._87 -> right_head_light.plus {
                properties {
                    color "2"
                }
            }
            right_head_light.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            control_line_from_ignition_1.pin -> right_head_light_switch.in {
                properties {
                    color "4"
                }
            }
            right_head_light_switch.out -> right_head_light_relay._85 {
                properties {
                    color "3"
                }
            }
            right_head_light_relay._86 -> m.ground {
                properties {
                    color "0"
                }
            }


            # Педаль тормоза
            light_fuse.out -> brake_pressure_sensor.in {
                properties {
                    color "6"
                }
            }
            brake_pressure_sensor.out -> stop_signal_splitter.pin {
                properties {
                    color "0"
                }
            }
            stop_signal_splitter.pin -> left_stop_signal.plus {
                properties {
                    color "1"
                }
            }
            stop_signal_splitter.pin -> right_stop_signal.plus {
                properties {
                    color "2"
                }
            }
            stop_signal_splitter.pin -> extra_stop_signal.plus {
                properties {
                    color "3"
                }
            }

            left_stop_signal.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            right_stop_signal.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            extra_stop_signal.minus -> m.ground {
                properties {
                    color "0"
                }
            }

            # Лампа заднего хода
            light_fuse.out -> reverse_lamp_sensor.in {
                properties {
                    color "10"
                }
            }
            reverse_lamp_sensor.out -> reverse_lamp.plus {
                properties {
                    color "1"
                }
            }
            reverse_lamp.minus -> m.ground {
                properties {
                    color "0"
                }
            }

            # Отопитель
            ignition_fan_fuse.out -> heater_fuse.in {
                properties {
                    color "2"
                }
            }
            heater_fuse.out -> heater_relay_1._30 {
                properties {
                    color "1"
                }
            }
            heater_fuse.out -> heater_relay_2._30 {
                properties {
                    color "3"
                }
            }
            heater_relay_1._87 -> heater_resistor.in {
                properties {
                    color "2"
                }
            }
            heater_resistor.out -> heater.plus {
                properties {
                    color "1"
                }
            }
            heater_relay_2._87 -> heater.plus {
                properties {
                    color "2"
                }
            }
            heater.minus -> m.ground {
                properties {
                    color "0"
                }
            }

            control_line_from_ignition_2.pin -> heater_switch.i {
                properties {
                    color "1"
                }
            }
            heater_switch.d -> heater_relay_1._85 {
                properties {
                    color "4"
                }
            }
            heater_switch.u -> heater_relay_2._85 {
                properties {
                    color "5"
                }
            }

            heater_relay_1._86 -> m.ground {
                properties {
                    color "0"
                }
            }
            heater_relay_2._86 -> m.ground {
                properties {
                    color "0"
                }
            }

            # Вентилятор салона
            ignition_fan_fuse.out -> interior_fan_fuse.in {
                properties {
                    color "3"
                }
            }
            interior_fan_fuse.out -> interior_fan_relay._30 {
                properties {
                    color "1"
                }
            }
            interior_fan_relay._87 -> interior_fan.plus {
                properties {
                    color "2"
                }
            }
            interior_fan.minus -> m.ground {
                properties {
                    color "0"
                }
            }

            control_line_from_ignition_2.pin -> interior_fan_switch.in {
                properties {
                    color "7"
                }
            }
            interior_fan_switch.out -> interior_fan_relay._85 {
                properties {
                    color "3"
                }
            }
            interior_fan_relay._86 -> m.ground {
                properties {
                    color "0"
                }
            }


            # Дворники и передний омыватель
            ignition_fan_fuse.out -> wipers_fuse.in {
                properties {
                    color "6"
                }
            }
            wipers_fuse.out -> wipers._1 {
                properties {
                    color "1"
                }
            }
            wipers._3 -> m.ground {
                properties {
                    color "0"
                }
            }
            wipers._2 -> wipers_relay._15 {
                properties {
                    color "2"
                }
            }
            wipers_relay.S -> right_steering_column_switch._53e {
                properties {
                    color "1"
                }
            }
            right_steering_column_switch._53 -> wipers._5 {
                properties {
                    color "3"
                }
            }
            right_steering_column_switch._53b -> wipers._6 {
                properties {
                    color "4"
                }
            }
            right_steering_column_switch.J -> wipers_relay.J {
                properties {
                    color "7"
                }
            }
            wipers_relay._15 -> right_steering_column_switch._53a {
                properties {
                    color "10"
                }
            }
            control_line_from_ignition_2.pin -> right_steering_column_switch._53ah {
                properties {
                    color "8"
                }
            }


            fuse_xxx.out -> windshield_washer_fuse.in {
                properties {
                    color "0"
                }
            }
            windshield_washer_fuse.out -> windshield_washer_relay._30 {
                properties {
                    color "1"
                }
            }
            windshield_washer_relay._87 -> windshield_washer.plus {
                properties {
                    color "2"
                }
            }
            windshield_washer_relay._87 -> wipers_relay._86 {
                properties {
                    color "5"
                }
            }

            right_steering_column_switch.W -> windshield_washer_relay._85 {
                properties {
                    color "6"
                }
            }
            windshield_washer_relay._86 -> m.ground {
                properties {
                    color "0"
                }
            }
            windshield_washer.minus -> m.ground {
                properties {
                    color "0"
                }
            }


            wipers_relay._31b -> wipers._4 {
                properties {
                    color "6"
                }
            }
            wipers_relay._31 -> m.ground {
                properties {
                    color "0"
                }
            }


            # Гудок
            ignition_fan_fuse.out -> car_horn_fuse.in {
                properties {
                    color "5"
                }
            }
            car_horn_fuse.out -> car_horn_relay._30 {
                properties {
                    color "1"
                }
            }
            car_horn_relay._87 -> car_horn.plus {
                properties {
                    color "2"
                }
            }
            car_horn.minus -> m.ground {
                properties {
                    color "0"
                }
            }
            control_line_from_ignition_2.pin -> car_horn_switch.in {
                properties {
                    color "4"
                }
            }
            car_horn_switch.out -> car_horn_relay._85 {
                properties {
                    color "3"
                }
            }
            car_horn_relay._86 -> m.ground {
                properties {
                    color "0"
                }
            }
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
