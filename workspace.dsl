workspace "Name" "Description" {

    !identifiers hierarchical

    configuration {
        scope none
    }

    #TODO: 
    #  вывести статистику по предохранителям
    #  вывести статистику по длине проводов

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
                
                    power_fuse = fuse "Силовой предохранитель" {
                        !include "elements/fuse.dsl"
                    }
                    power_splitter = splitter "Силовой разветвитель" {
                        pin = pin "pin"
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

                # TODO нужно три датчика свести к двум!!!
                coolant_sensor = sensor "Датчик вкл э-вент охл ДВС" {
                    !include "elements/sensor.dsl"
                }
                engine_overheat_sensor = sensor "Датчик перегрева охлаждающей жидкости" {
                    !include "elements/sensor.dsl"
                }
                engine_temp_sensor = sensor "Датчик температуры охлаждающей жидкости" {
                    !include "elements/sensor.dsl"
                }

                low_oil_pressure_sensor = sensor "Датчик низкого давления масла" {
                    !include "elements/sensor.dsl"
                }
                oil_pressure_sensor = sensor "Датчик давления масла" {
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

                electric_pump = container "Электрическая помпа" {
                    tags "electric_pump"
                    !include "elements/electric_motor.dsl"
                }
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
                low_brake_fluid_sensor = sensor "Датчик недостаточного уровня тормозной жидкости" {
                    !include "elements/sensor.dsl"
                }
                fuel_level_sensor = sensor "Датчик уровня топлива" {
                    !include "elements/sensor.dsl"
                }

                group "Блок реле и предохранителей" {                
                    group "Левый блок реле и предохранителей" {
                        group "Левый блок реле" {
                            starter_relay = relay "Реле стартера" {
                                !include "elements/relay5.dsl"
                            }

                            ignition_relay = relay "Реле зажигания" {
                                !include "elements/relay.dsl"
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
                            windshield_washer_relay = relay "Реле моторчика омывайки" {
                                !include "elements/relay.dsl"
                            }

                            turn_signal_relay = relay "Реле поворотников" {
                                !include "elements/uaz/3151/turn_signal_relay_950.dsl"
                            }
                            wipers_relay = relay "Реле дворников" {
                                !include "elements/uaz/3151/wipers_relay.dsl"
                            }
                        }
                        group "Левый блок предохранителей" {
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
                            wipers_fuse = fuse "Прд. дворников" {
                                !include "elements/fuse.dsl"
                            }
                            windshield_washer_fuse = fuse "Прд. моторчика омывайки" {
                                !include "elements/fuse.dsl"
                            }
                        }
                    }
                    group "Правый блок реле и предохранителей" {
                        group "Правый блок реле" {
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
                            heater_relay_1 = relay "Реле отопителя (1-я скорость)" {
                                !include "elements/relay.dsl"
                            }
                            heater_relay_2 = relay "Реле отопителя (2-я скорость)" {
                                !include "elements/relay.dsl"
                            }
                            interior_fan_relay = relay "Реле вентилятора салона" {
                                !include "elements/relay.dsl"
                            }
                            car_horn_relay = relay "Реле гудка" {
                                !include "elements/relay.dsl"
                            }
                            electric_pump_relay = relay "Реле электрической помпы" {
                                !include "elements/relay.dsl"
                            }
                        }
                        group "Правый блок предохранителей" {
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
                            car_horn_fuse = fuse "Прд. гудка" {
                                !include "elements/fuse.dsl"
                            }
                            electric_pump_fuse = fuse "Прд. электрической помпы" {
                                !include "elements/fuse.dsl"
                            }
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
                }
                group "Блок приборов" {
                    group "Блок контрольных ламп" {
                        turn_signal_control_light = light "Контрольная лампа поворотников" {
                            !include "elements/light.dsl"
                        }
                        low_brake_fluid_warning_light = light "Контрольная лампа недостаточного уровня тормозной жидкости" {
                            !include "elements/light.dsl"
                        }
                        high_beam_control_light = light "Контрольная лампа дальнего света" {
                            !include "elements/light.dsl"
                        }
                    }

                    speedometer_backlight = light "Подсветка спидометра" {
                        !include "elements/light.dsl"
                    }

                    group "Датчик топлива" {
                        fuel_level_backlight = light "Подсветка датчика уровня топлива" {
                            !include "elements/light.dsl"
                        }
                        fuel_level_gauge = gauge "Указатель уровня топлива" {
                            !include "elements/gauge.dsl"
                        }
                    }
                    group "Датчик температуры двигателя" {
                        engine_temp_backlight = light "Подсветка датчика температуры двигателя" {
                            !include "elements/light.dsl"
                        }
                        engine_temp_gauge = gauge "Указатель температуры двигателя" {
                            !include "elements/gauge.dsl"
                        }
                        engine_overheat_control_light = light "Лампа перегрева двигателя" {
                            !include "elements/light.dsl"
                        }
                    }
                    group "Датчик давления масла в двигателе" {
                        oil_pressure_backlight = light "Подсветка датчика давления масла в двигателе" {
                            !include "elements/light.dsl"
                        }
                        oil_pressure_gauge = gauge "Указатель давления масла в двигателе" {
                            !include "elements/gauge.dsl"
                        }
                        low_oil_pressure_control_light = light "Лампа низкого давления масла в двигателе" {
                            !include "elements/light.dsl"
                        }
                    }
                    group "Вольтметр" {
                        voltmeter_backlight = light "Подсветка вольтметра" {
                            !include "elements/light.dsl"
                        }
                        voltmeter_gauge = gauge "Указатель вольтметра" {
                            !include "elements/gauge.dsl"
                        }
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
                    electric_pump_switch = switch "Выключатель электрической помпы" {
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
                    color "0"
                    length "0.3"
                    square "50"
                }
            }
            akb.plus -> starter.plus {
                tags "foreign_color"
                properties {
                    length "1.5"
                    square "50"
                    color "1"
                }
            }
            akb.plus -> winch.plus {
                tags "foreign_color"
                properties {
                    length "1.5"
                    square "50"
                    color "1"
                }
            }
            akb.plus -> power_fuse.in {
                tags "foreign_color"
                properties {
                    length "0.35"
                    square "25"
                    color "1"
                }
            }


            # Система зажигания

            generator.plus -> starter.plus {
                tags "foreign_color"
                properties {
                    #length "1.0"
                    color "1"
                }
            }
            m.ground -> generator.minus {
                properties {
                    color "0"
                    length "0.1"
                }
            }

            power_fuse.out -> power_splitter.pin {
                tags "foreign_color"
                properties {
                    color "1"
                    length "1.4"
                    square "16"
                }
            }
            power_splitter.pin -> ignition_relay._30 {
                tags "foreign_color"
                properties {
                    color "0"
                    length "0.3"
                    square "4"
                }
            }
            power_splitter.pin -> ignition_switch.in {
                tags "foreign_color"
                properties {
                    color "1"
                    length "2.5"
                    square "0.5"
                }
            }

            starter_relay_fuse.out -> generator.v {
                properties {
                    color "4"
                    length "3.0"
                    square "4"
                }
            }
    
            ignition_switch.out -> ignition_relay._85 {
                properties {
                    color "2"
                    length "2.5"
                    square "0.5"
                }
            }
            
            ignition_relay._86 -> m.ground {
                properties {
                    length "1.5"
                    square "0.5"
                    color "0"
                }
            }
            ignition_relay._87 -> starter_relay_fuse.in {
                properties {
                    length "0.3"
                    square "2.5"
                    color "3"
                }
            }
            
            starter_relay_fuse.out -> starter_relay._30 {
                properties {
                    length "0.3"
                    square "2.5"
                    color "1"
                }
            }
            starter_relay_fuse.out -> ignition.data {
                properties {
                    color "0"
                    length "3.0"
                    square "4"
                }
            }
            starter_relay_fuse.out -> start_button.in {
                properties {
                    color "2"
                    length "2.5"
                    square "0.5"
                }
            }
    
            start_button.out -> starter_relay._85 {
                properties {
                    color "3"
                    length "2.5"
                    square "0.5"
                }
            }
    
            starter_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            starter_relay._87 -> starter.st {
                properties {
                    color "6"
                    length "2.5"
                    square "4"
                }
            }
            starter_relay._88 -> control_line_from_ignition_fuse.in {
                properties {
                    color "5"
                    length "0.2"
                    square "2.5"
                }
            }
            control_line_from_ignition_fuse.out -> control_line_from_ignition_1.pin {
                properties {
                    color "1"
                    length "0.3"
                    square "2.5"
                }
            }
            control_line_from_ignition_fuse.out -> control_line_from_ignition_2.pin {
                properties {
                    color "2"
                    length "0.3"
                    square "2.5"
                }
            }


            # Лебедка
        
            winch.minus -> m.ground {
                properties {
                    length "1.5"
                    square "50"
                    color "0"
                }
            }
            # Электровентиляторы охлаждения ДВС

            coolant_fan_1.minus -> m.ground {
                properties {
                    length "0.3"
                    square "0.5"
                    color "0"
                }
            }
            coolant_fan_1_fuse.out -> coolant_fan_1_relay._30 {
                properties {
                    length "0.2"
                    square "2.5"
                    color "1"
                }
            }
            coolant_fan_1_relay._87 -> coolant_fan_1.plus {
                properties {
                    color "2"
                    length "3"
                    square "4"
                }
            }
            control_line_from_ignition_2.pin -> coolant_fan_1_relay._85 {
                properties {
                    color "3"
                    length "0.3"
                    square "0.5"
                }
            }
            power_splitter.pin -> coolant_fan_1_fuse.in {
                tags "foreign_color"
                properties {
                    color "0"
                    length "1.2"
                    square "4"
                }
            }
            coolant_fan_1_relay._86 -> coolant_control_switch.I {
                properties {
                    length "1.5"
                    square "0.5"
                    color "7"
                }
            }

            coolant_fan_2.minus -> m.ground {
                properties {
                    length "0.3"
                    square "0.5"
                    color "0"
                }
            }
            coolant_fan_2_relay._87 -> coolant_fan_2.plus {
                properties {
                    color "1"
                    length "2"
                    square "4"
                }
            }
            power_splitter.pin -> coolant_fan_2_fuse.in {
                tags "foreign_color"
                properties {
                    color "1"
                    length "1.2"
                    square "4"
                }
            }
            coolant_fan_1_relay._85 -> coolant_fan_2_relay._85 {
                properties {
                    color "6"
                    length "0.1"
                    square "0.5"
                }
            }
            coolant_fan_2_fuse.out -> coolant_fan_2_relay._30 {
                properties {
                    color "3"
                    length "0.2"
                    square "2.5"
                }
            }
            coolant_fan_2_relay._86 -> coolant_control_switch.I {
                properties {
                    length "1.5"
                    square "0.5"
                    color "5"
                }
            }

            coolant_sensor.out -> m.ground {
                tags "internal_connection"
            }
            coolant_control_switch.D -> coolant_sensor.in {
                properties {
                    color "1"
                    length "3.5"
                    square "0.5"
                }
            }
            coolant_control_switch.U -> m.ground {
                properties {
                    length "0.5"
                    square "0.5"
                    color "0"
                }
            }

            # Ближний/дальний свет
            control_line_from_ignition_1.pin -> left_steering_column_light_switch._30 {
                properties {
                    color "9"
                    length "2.5"
                    square "0.5"
                }
            }
            left_steering_column_light_switch._56a -> high_beam_relay._85 {
                properties {
                    color "1"
                    length "2.5"
                    square "0.5"
                }
            }
            left_steering_column_light_switch._56b -> low_beam_relay._85 {
                properties {
                    color "4"
                    length "3.5"
                    square "0.5"
                }
            }

            control_line_from_ignition_1.pin -> light_switch.x {
                properties {
                    color "0"
                    length "2.5"
                    square "0.5"
                }
            }
            power_splitter.pin -> light_switch._30 {
                tags "foreign_color"
                properties {
                    color "3"
                    length "2"
                    square "0.5"
                }
            }
            light_switch._58 -> speedometer_backlight.plus {
                properties {
                    color "1"
                    length "0.5"
                    square "1"
                }
            }
            light_switch._56 -> left_steering_column_light_switch._56 {
                properties {
                    color "2"
                    length "1.5"
                    square "0.5"
                }
            }
            light_switch._58 -> side_light_relay._85 {
                properties {
                    color "4"
                    length "2.5"
                    square "0.5"
                }
            }

            left_low_beam.minus -> m.ground {
                properties {
                    color "0"
                    length "1"
                    square "1.5"
                }
            }
            right_low_beam.minus -> m.ground {
                properties {
                    color "0"
                    length "1"
                    square "1.5"
                }
            }
            low_beam_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            low_beam_relay._87 -> left_low_beam.plus {
                properties {
                    color "2"
                    length "3.5"
                    square "4"
                }
            }
            low_beam_relay._87 -> right_low_beam.plus {
                properties {
                    color "3"
                    length "3.5"
                    square "4"
                }
            }
            low_beam_relay_fuse.out -> low_beam_relay._30 {
                properties {
                    color "1"
                    length "0.3"
                    square "1.5"
                }
            }
            power_splitter.pin -> low_beam_relay_fuse.in {
                properties {
                    color "9"
                    length "1.2"
                    square "6"
                }
            }

            left_high_beam.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "1"
                }
            }
            right_high_beam.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "1"
                }
            }
            high_beam_relay._87 -> left_high_beam.plus {
                properties {
                    color "2"
                    length "3.5"
                    square "2.5"
                }
            }
            high_beam_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }

            high_beam_relay._87 -> right_high_beam.plus {
                properties {
                    color "3"
                    length "3.5"
                    square "2.5"
                }
            }
            high_beam_relay_fuse.out -> high_beam_relay._30 {
                properties {
                    color "4"
                    length "0.3"
                    square "2.5"
                }
            }
            power_splitter.pin -> high_beam_relay_fuse.in {
                tags "foreign_color"
                properties {
                    color "2"
                    length "1.2"
                    square "6"
                }
            }
            high_beam_control_light.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            high_beam_relay._87 -> high_beam_control_light.plus {
                properties {
                    color "5"
                    length "0.5"
                    square "0.5"
                }
            }

            front_left_side_light.minus -> m.ground {
                properties {
                    color "0"
                    length "1"
                    square "0.5"
                }
            }
            front_right_side_light.minus -> m.ground {
                properties {
                    color "0"
                    length "1"
                    square "0.5"
                }
            }
            rear_left_side_light.minus -> m.ground {
                properties {
                    color "0"
                    length "1"
                    square "0.5"
                }
            }
            rear_right_side_light.minus -> m.ground {
                properties {
                    color "0"
                    length "1"
                    square "0.5"
                }
            }
            number_plate_light.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "1"
                }
            }

            left_front_turn_signal.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "1"
                }
            }
            left_turn_signal_repeater.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "1"
                }
            }
            left_rear_turn_signal.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "1"
                }
            }

            right_front_turn_signal.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            right_turn_signal_repeater.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            right_rear_turn_signal.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }


            side_light_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            side_light_relay._87 -> side_light_splitter.pin {
                properties {
                    color "2"
                    length "2.5"
                    square "1"
                }
            }
            side_light_splitter.pin -> front_left_side_light.plus {
                properties {
                    color "1"
                    length "3.5"
                    square "1"
                }
            }
            side_light_splitter.pin -> front_right_side_light.plus {
                properties {
                    color "3"
                    length "3.5"
                    square "1"
                }
            }
            side_light_splitter.pin -> rear_left_side_light.plus {
                properties {
                    color "4"
                    length "3.5"
                    square "1"
                }
            }
            side_light_splitter.pin -> rear_right_side_light.plus {
                properties {
                    color "5"
                    length "3.5"
                    square "1"
                }
            }
            side_light_splitter.pin -> number_plate_light.plus {
                properties {
                    color "6"
                    length "3.5"
                    square "1"
                }
            }
            side_light_relay_fuse.out -> side_light_relay._30 {
                properties {
                    color "3"
                    length "0.2"
                    square "1"
                }
            }
            power_splitter.pin -> side_light_relay_fuse.in {
                properties {
                    color "4"
                    length "1.2"
                    square "1.5"
                }
            }

            # Поворотники и аварийка
            power_splitter.pin -> turn_signal_fuse.in {
                properties {
                    color "5"
                    length "1.2"
                    square "4"
                }
            }
            turn_signal_relay.p -> left_steering_column_turn_signal_switch._49a {
                properties {
                    color "2"
                    length "2.5"
                    square "0.5"
                }
            }
            turn_signal_relay.p -> emergency_light_button.p {
                properties {
                    color "1"
                    length "2.5"
                    square "0.5"
                }
            }
            turn_signal_relay.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            left_steering_column_turn_signal_switch._49aR -> turn_signal_relay.pb {
                properties {
                    color "3"
                    length "2.5"
                    square "0.5"
                }
            }
            emergency_light_button.pb -> turn_signal_relay.pb {
                properties {
                    color "4"
                    length "2.5"
                    square "0.5"
                }
            }
            left_steering_column_turn_signal_switch._49aL -> turn_signal_relay.lb {
                properties {
                    color "5"
                    length "2.5"
                    square "0.5"
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
                    length "3"
                    square "0.5"
                }
            }
            turn_signal_control_light.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            turn_signal_relay.right -> right_turn_signal_splitter.pin {
                properties {
                    color "8"
                    length "3"
                    square "1.5"
                }
            }
            turn_signal_relay.left -> left_turn_signal_splitter.pin {
                properties {
                    color "9"
                    length "3"
                    square "1.5"
                }
            }

            emergency_light_button.plus -> turn_signal_relay.plus {
                properties {
                    color "10"
                    length "2"
                    square "2.5"
                }
            }

            # TODO тут питание должно приходить только при включенном зажигании - значит нужно поставить реле
            turn_signal_fuse.out -> emergency_light_button.pow {
                properties {
                    color "2"
                    length "2"
                    square "1.5"
                }
            }
            turn_signal_fuse.out -> emergency_light_button.emer {
                properties {
                    color "3"
                    length "2.5"
                    square "2.5"
                }
            }


            right_turn_signal_splitter.pin -> right_front_turn_signal.plus {
                properties {
                    color "1"
                    length "2"
                    square "0.75"
                }
            }
            right_turn_signal_splitter.pin -> right_turn_signal_repeater.plus {
                properties {
                    color "2"
                    length "1"
                    square "0.75"
                }
            }
            right_turn_signal_splitter.pin -> right_rear_turn_signal.plus {
                properties {
                    color "3"
                    length "4"
                    square "0.75"
                }
            }

            left_turn_signal_splitter.pin -> left_front_turn_signal.plus {
                properties {
                    color "1"
                    length "2"
                    square "0.75"
                }
            }
            left_turn_signal_splitter.pin -> left_turn_signal_repeater.plus {
                properties {
                    color "2"
                    length "1"
                    square "0.75"
                }
            }
            left_turn_signal_splitter.pin -> left_rear_turn_signal.plus {
                properties {
                    color "3"
                    length "4"
                    square "0.75"
                }
            }


            # Предохранители доп света
            power_splitter.pin -> front_head_light_fuse.in {
                properties {
                    color "7"
                    length "0.15"
                    square "5"
                }
            }
            front_head_light_fuse.in -> rear_head_light_fuse.in {
                properties {
                    color "2"
                    length "0.1"
                    square "1.5"
                }
            }
            rear_head_light_fuse.in -> left_head_light_fuse.in {
                properties {
                    color "1"
                    length "0.1"
                    square "1.5"
                }
            }
            left_head_light_fuse.in -> right_head_light_fuse.in {
                properties {
                    color "2"
                    length "0.1"
                    square "1.5"
                }
            }

            # Передняя люстра
            front_head_light_fuse.out -> front_head_light_relay._30 {
                properties {
                    color "1"
                    length "0.3"
                    square "1.5"
                }
            }
            front_head_light_relay._87 -> front_head_light.plus {
                properties {
                    color "2"
                    length "2.5"
                    square "6"
                }
            }
            front_head_light.minus -> m.ground {
                properties {
                    color "0"
                    length "2"
                    square "6"
                }
            }
            control_line_from_ignition_1.pin -> front_head_light_switch.in {
                properties {
                    color "5"
                    length "2.5"
                    square "0.5"
                }
            }
            front_head_light_switch.out -> front_head_light_relay._85 {
                properties {
                    color "3"
                    length "2.5"
                    square "0.5"
                }
            }
            front_head_light_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }


            # Задняя люстра
            rear_head_light_fuse.out -> rear_head_light_relay._30 {
                properties {
                    color "3"
                    length "0.3"
                    square "1.5"
                }
            }
            rear_head_light_relay._87 -> rear_head_light.plus {
                properties {
                    color "2"
                    length "2.5"
                    square "6"
                }
            }
            rear_head_light.minus -> m.ground {
                properties {
                    color "0"
                    length "2.5"
                    square "6"
                }
            }
            front_head_light_switch.in -> rear_head_light_switch.in {
                properties {
                    color "10"
                    length "0.1"
                    square "0.5"
                }
            }
            rear_head_light_switch.out -> rear_head_light_relay._85 {
                properties {
                    color "1"
                    length "2.5"
                    square "0.5"
                }
            }
            rear_head_light_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }

            # Левая боковая люстра
            left_head_light_fuse.out -> left_head_light_relay._30 {
                properties {
                    color "3"
                    length "0.3"
                    square "1.5"
                }
            }
            left_head_light_relay._87 -> left_head_light.plus {
                properties {
                    color "1"
                    length "3"
                    square "6"
                }
            }
            left_head_light.minus -> m.ground {
                properties {
                    color "0"
                    length "3"
                    square "6"
                }
            }
            rear_head_light_switch.in -> left_head_light_switch.in {
                properties {
                    color "2"
                    length "0.1"
                    square "0.5"
                }
            }
            left_head_light_switch.out -> left_head_light_relay._85 {
                properties {
                    color "4"
                    length "2.5"
                    square "0.5"
                }
            }
            left_head_light_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }


            # Правая люстра
            right_head_light_fuse.out -> right_head_light_relay._30 {
                properties {
                    color "1"
                    length "0.3"
                    square "1.5"
                }
            }
            right_head_light_relay._87 -> right_head_light.plus {
                properties {
                    color "2"
                    length "2"
                    square "6"
                }
            }
            right_head_light.minus -> m.ground {
                properties {
                    color "0"
                    length "2"
                    square "6"
                }
            }
            left_head_light_switch.in -> right_head_light_switch.in {
                properties {
                    color "1"
                    length "0.1"
                    square "0.5"
                }
            }
            right_head_light_switch.out -> right_head_light_relay._85 {
                properties {
                    color "3"
                    length "2.5"
                    square "0.5"
                }
            }
            right_head_light_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }


            # Педаль тормоза
            power_splitter.pin -> brake_pressure_sensor.in {
                tags "foreign_color"
                properties {
                    color "6"
                    length "3"
                    square "2.5"
                }
            }
            brake_pressure_sensor.out -> stop_signal_splitter.pin {
                properties {
                    color "0"
                    length "2.5"
                    square "4"
                }
            }
            stop_signal_splitter.pin -> left_stop_signal.plus {
                properties {
                    color "1"
                    length "1"
                    square "0.75"
                }
            }
            stop_signal_splitter.pin -> right_stop_signal.plus {
                properties {
                    color "2"
                    length "1"
                    square "0.75"
                }
            }
            stop_signal_splitter.pin -> extra_stop_signal.plus {
                properties {
                    color "3"
                    length "1"
                    square "0.75"
                }
            }

            left_stop_signal.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            right_stop_signal.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            extra_stop_signal.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }

            # Лампа заднего хода
            power_splitter.pin -> reverse_lamp_sensor.in {
                properties {
                    color "10"
                    length "3.5"
                    square "1.5"
                }
            }
            reverse_lamp_sensor.out -> reverse_lamp.plus {
                properties {
                    color "1"
                    length "3.5"
                    square "1.5"
                }
            }
            reverse_lamp.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "1.5"
                }
            }

            # Отопитель
            power_splitter.pin -> heater_fuse.in {
                properties {
                    color "2"
                    length "1.2"
                    square "4"
                }
            }
            heater_fuse.out -> heater_relay_1._30 {
                properties {
                    color "1"
                    length "0.3"
                    square "0.5"
                }
            }
            heater_fuse.out -> heater_relay_2._30 {
                properties {
                    color "3"
                    length "0.3"
                    square "0.5"
                }
            }
            heater_relay_1._87 -> heater_resistor.in {
                properties {
                    color "2"
                    length "3"
                    square "4"
                }
            }
            heater_resistor.out -> heater.plus {
                properties {
                    color "1"
                    length "0.1"
                    square "0.5"
                }
            }
            heater_relay_2._87 -> heater.plus {
                properties {
                    color "2"
                    length "3"
                    square "6"
                }
            }
            heater.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "2.5"
                }
            }

            control_line_from_ignition_2.pin -> heater_switch.i {
                properties {
                    color "1"
                    length "2.5"
                    square "0.5"
                }
            }
            heater_switch.d -> heater_relay_1._85 {
                properties {
                    color "4"
                    length "2.5"
                    square "0.5"
                }
            }
            heater_switch.u -> heater_relay_2._85 {
                properties {
                    color "5"
                    length "2.5"
                    square "0.5"
                }
            }

            heater_relay_1._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            heater_relay_2._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }

            # Вентилятор салона
            power_splitter.pin -> interior_fan_fuse.in {
                properties {
                    color "3"
                    length "1.2"
                    square "1.5"
                }
            }
            interior_fan_fuse.out -> interior_fan_relay._30 {
                properties {
                    color "1"
                    length "0.3"
                    square "0.5"
                }
            }
            interior_fan_relay._87 -> interior_fan.plus {
                properties {
                    color "2"
                    length "1"
                    square "0.5"
                }
            }
            interior_fan.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }

            control_line_from_ignition_2.pin -> interior_fan_switch.in {
                properties {
                    color "7"
                    length "2.5"
                    square "0.5"
                }
            }
            interior_fan_switch.out -> interior_fan_relay._85 {
                properties {
                    color "3"
                    length "2.5"
                    square "0.5"
                }
            }
            interior_fan_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }


            # Дворники и передний омыватель
            power_splitter.pin -> wipers_fuse.in {
                properties {
                    color "6"
                    length "1.2"
                    square "4"
                }
            }
            wipers_fuse.out -> wipers._1 {
                properties {
                    color "1"
                    length "2.5"
                    square "4"
                }
            }
            wipers._3 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "1.5"
                }
            }
            wipers._2 -> wipers_relay._15 {
                properties {
                    color "2"
                    length "2.5"
                    square "4"
                }
            }
            wipers_relay.S -> right_steering_column_switch._53e {
                properties {
                    color "1"
                    length "2.5"
                    square "4"
                }
            }
            right_steering_column_switch._53 -> wipers._5 {
                properties {
                    color "3"
                    length "1.5"
                    square "2.5"
                }
            }
            right_steering_column_switch._53b -> wipers._6 {
                properties {
                    color "4"
                    length "1.5"
                    square "2.5"
                }
            }
            right_steering_column_switch.J -> wipers_relay.J {
                properties {
                    color "7"
                    length "2.5"
                    square "0.5"
                }
            }
            wipers_relay._15 -> right_steering_column_switch._53a {
                properties {
                    color "10"
                    length "2.5"
                    square "1.5"
                }
            }
            control_line_from_ignition_2.pin -> right_steering_column_switch._53ah {
                properties {
                    color "8"
                    length "2.5"
                    square "0.5"
                }
            }


            power_splitter.pin -> windshield_washer_fuse.in {
                properties {
                    color "0"
                    length "1.2"
                    square "0.5"
                }
            }
            windshield_washer_fuse.out -> windshield_washer_relay._30 {
                properties {
                    color "1"
                    length "0.3"
                    square "0.5"
                }
            }
            windshield_washer_relay._87 -> windshield_washer.plus {
                properties {
                    color "2"
                    length "3.5"
                    square "0.5"
                }
            }
            windshield_washer_relay._87 -> wipers_relay._86 {
                properties {
                    color "5"
                    length "0.3"
                    square "0.5"
                }
            }

            right_steering_column_switch.W -> windshield_washer_relay._85 {
                properties {
                    color "6"
                    length "2.5"
                    square "0.5"
                }
            }
            windshield_washer_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            windshield_washer.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }


            wipers_relay._31b -> wipers._4 {
                properties {
                    color "6"
                    length "2.5"
                    square "0.5"
                }
            }
            wipers_relay._31 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }


            # Гудок
            power_splitter.pin -> car_horn_fuse.in {
                tags "foreign_color"
                properties {
                    color "5"
                    length "1.2"
                    square "6"
                }
            }
            car_horn_fuse.out -> car_horn_relay._30 {
                properties {
                    color "1"
                    length "0.3"
                    square "1.5"
                }
            }
            car_horn_relay._87 -> car_horn.plus {
                properties {
                    color "2"
                    length "3.5"
                    square "6"
                }
            }
            car_horn.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "6"
                }
            }
            control_line_from_ignition_2.pin -> car_horn_switch.in {
                properties {
                    color "4"
                    length "2.5"
                    square "0.5"
                }
            }
            car_horn_switch.out -> car_horn_relay._85 {
                properties {
                    color "3"
                    length "2.5"
                    square "0.5"
                }
            }
            car_horn_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }

            # Электрическая помпа
            power_splitter.pin -> electric_pump_fuse.in {
                tags "foreign_color"
                properties {
                    color "4"
                    length "1.2"
                    square "2.5"
                }
            }

            electric_pump_fuse.out -> electric_pump_relay._30 {
                properties {
                    color "1"
                    length "0.3"
                    square "0.5"
                }
            }
            electric_pump_relay._87 -> electric_pump.plus {
                properties {
                    color "2"
                    length "2.5"
                    square "2.5"
                }
            }
            electric_pump.minus -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "1.5"
                }
            }
            control_line_from_ignition_2.pin -> electric_pump_switch.in {
                properties {
                    color "5"
                    length "2.5"
                    square "0.5"
                }
            }
            electric_pump_switch.out -> electric_pump_relay._85 {
                properties {
                    color "3"
                    length "2.5"
                    square "0.5"
                }
            }
            electric_pump_relay._86 -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }

            # Датчик низкого уровня тормозной жидкости
            power_splitter.pin -> low_brake_fluid_warning_light.plus {
                properties {
                    color "1"
                    length "2"
                    square "1.5"
                }
            }
            low_brake_fluid_sensor.out -> m.ground {
                tags "internal_connection"
            }
            low_brake_fluid_warning_light.minus -> low_brake_fluid_sensor.in {
                properties {
                    color "2"
                    length "2.5"
                    square "0.5"
                }
            }

            # Подсветка приборов
            speedometer_backlight.minus -> m.ground {
                properties {
                    color "0"
                    length "0.3"
                    square "0.5"
                }
            }

            speedometer_backlight.plus -> fuel_level_backlight.plus {
                properties {
                    color "3"
                    length "0.2"
                    square "0.5"
                }
            }
            fuel_level_backlight.minus -> m.ground {
                properties {
                    color "0"
                    length "0.3"
                    square "0.5"
                }
            }

            fuel_level_backlight.plus -> engine_temp_backlight.plus {
                properties {
                    color "4"
                    length "0.2"
                    square "0.5"
                }
            }
            engine_temp_backlight.minus -> m.ground {
                properties {
                    color "0"
                    length "0.3"
                    square "0.5"
                }
            }

            engine_temp_backlight.plus -> oil_pressure_backlight.plus {
                properties {
                    color "5"
                    length "0.2"
                    square "0.5"
                }
            }
            oil_pressure_backlight.minus -> m.ground {
                properties {
                    color "0"
                    length "0.3"
                    square "0.5"
                }
            }

            oil_pressure_backlight.plus -> voltmeter_backlight.plus {
                properties {
                    color "6"
                    length "0.3"
                    square "0.5"
                }
            }
            voltmeter_backlight.minus -> m.ground {
                properties {
                    color "0"
                    length "0.3"
                    square "0.5"
                }
            }


            # Показатель уровня топлива
            fuel_level_sensor.out -> m.ground {
                properties {
                    color "0"
                    length "0.5"
                    square "0.5"
                }
            }
            fuel_level_gauge.minus -> fuel_level_sensor.in {
                properties {
                    color "1"
                    length "2.5"
                    square "0.5"
                }
            }
            low_oil_pressure_control_light.plus -> fuel_level_gauge.plus {
                properties {
                    color "3"
                    length "0.3"
                    square "0.5"
                }
            }

            # Датчик + лампа температуры двигателя
            engine_overheat_control_light.minus -> engine_overheat_sensor.in {
                properties {
                    color "0"
                    length "2.5"
                    square "0.5"
                }
            }
            engine_overheat_sensor.out -> m.ground {
                tags "internal_connection"
            }
            low_brake_fluid_warning_light.plus -> engine_overheat_control_light.plus {
                properties {
                    color "4"
                    length "0.2"
                    square "0.5"
                }
            }

            engine_temp_gauge.minus -> engine_temp_sensor.in {
                properties {
                    color "0"
                    length "2.5"
                    square "0.5"
                }
            }
            engine_temp_sensor.out -> m.ground {
                tags "internal_connection"
            }
            fuel_level_gauge.plus -> engine_temp_gauge.plus {
                properties {
                    color "5"
                    length "0.3"
                    square "0.5"
                }
            }

            # Датчик + лампа давления масла
            low_oil_pressure_control_light.minus -> low_oil_pressure_sensor.in {
                properties {
                    color "0"
                    length "2.5"
                    square "0.5"
                }
            }
            low_oil_pressure_sensor.out -> m.ground {
                tags "internal_connection"
            }
            engine_overheat_control_light.plus -> low_oil_pressure_control_light.plus {
                properties {
                    color "6"
                    length "0.3"
                    square "0.5"
                }
            }

            oil_pressure_gauge.minus -> oil_pressure_sensor.in {
                properties {
                    color "0"
                    length "2.5"
                    square "0.5"
                }
            }
            oil_pressure_sensor.out -> m.ground {
                tags "internal_connection"
            }
            engine_temp_gauge.plus -> oil_pressure_gauge.plus {
                properties {
                    color "7"
                    length "0.3"
                    square "0.5"
                }
            }

            # Датчик вольтметра
            voltmeter_gauge.minus -> m.ground {
                properties {
                    color "0"
                    length "0.3"
                    square "0.5"
                }
            }
            oil_pressure_gauge.plus -> voltmeter_gauge.plus {
                properties {
                    color "8"
                    length "0.3"
                    square "0.5"
                }
            }
        }

        // Set amper
        !include "set_consumer_amper.dsl"
        !include "switch_states.dsl"
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
