require 'json'



module WeatherApiClient
  class Parser


    # Преобразует JSON строку в Ruby объект (Hash)
    #
    # @param json_string [String] JSON строка
    # @return [Hash] хэш с символическими ключами
    # @raise [RuntimeError] при ошибке парсинга JSON
    #
    # @example Успешный парсинг
    #   parser.parse('{"city": "Moscow", "temp": 15.5}')
    #   # => { city: "Moscow", temp: 15.5 }
    #
    def parse(json_string)
      JSON.parse(json_string, symbolize_names: true)
    rescue JSON::ParserError => e
      raise "Failed to parse JSON response: #{e.messadge}"
    end
    

    # Извлекает температуру из данных текущей погоды
    #
    # @param data [Hash] хэш с данными текущей погоды
    # @return [Float, nil] температура в градусах Цельсия или nil если данные отсутствуют
    #
    # @example
    #   data = { main: { temp: 22.5 } }
    #   parser.extract_temp_coord_city(data)  # => 22.5
    #
    def extract_temp_coord_city(data)
      data.dig(:main, :temp)
    end
    

    # Извлекает влажность из данных текущей погоды
    #
    # @param data [Hash] хэш с данными текущей погоды
    # @return [Integer, nil] влажность в процентах или nil если данные отсутствуют
    #
    # @example
    #   data = { main: { humidity: 65 } }
    #   parser.extract_humidity_coord_city(data)  # => 65
    #
    def extract_humidity_coord_city(data)
      data.dig(:main, :humidity)
    end


    # Извлекает описание погодных условий из данных текущей погоды
    #
    # @param data [Hash] хэш с данными текущей погоды
    # @return [String, nil] описание погоды (например, "clear sky") или nil если данные отсутствуют
    #
    # @example
    #   data = { weather: [{ description: "clear sky" }] }
    #   parser.extract_condition_coord_city(data)  # => "clear sky"
    #
    def extract_condition_coord_city(data)
      data.dig(:weather, 0, :description)
    end




    # Парсит JSON и извлекает все основные данные о текущей погоде
    #
    # Этот метод объединяет парсинг JSON и извлечение всех ключевых параметров
    # в одном вызове для удобства использования.
    #
    # @param json_string [String] JSON строка от API с данными текущей погоды
    # @return [Hash] хэш с ключами :temperature, :humidity, :condition
    #
    # @example
    #   json = '{"main": {"temp": 22.5, "humidity": 65}, "weather": [{"description": "clear sky"}]}'
    #   result = parser.parse_all_coord_city(json)
    #   # => { temperature: 22.5, humidity: 65, condition: "clear sky" }
    #
    # @note Если какие-то данные отсутствуют, соответствующий ключ будет иметь значение nil
    #
    def parse_all_coord_city(json_string)
      ddata = parse(json_string)

      {

      temperature: extract_temp_coord_city(ddata),
      humidity: extract_humidity_coord_city(ddata),
      condition: extract_condition_coord_city(ddata)

      }

    end



    # Извлекает прогноз температуры из данных 5-дневного прогноза
    #
    # @param data [Hash] хэш с данными прогноза погоды
    # @return [Hash] хэш, где ключ - время (dt_txt), значение - температура
    # @return [Hash] пустой хэш, если данные отсутствуют
    #
    # @example
    #   data = {
    #     list: [
    #       { dt_txt: "2024-01-15 12:00:00", main: { temp: 20.5 } },
    #       { dt_txt: "2024-01-16 12:00:00", main: { temp: 18.2 } }
    #     ]
    #   }
    #   parser.extract_temp_forecast(data)
    #   # => { "2024-01-15 12:00:00" => 20.5, "2024-01-16 12:00:00" => 18.2 }
    #
    def extract_temp_forecast(data)
      ddata = data.dig(:list)
      return {} unless ddata 
      llist = {}
      ddata.each do |dat|
        time = dat.dig(:dt_txt)
        temperature = dat.dig(:main, :temp)
        llist[time] = temperature if time && temperature 
      end
      llist
    end



    # Извлекает прогноз влажности из данных 5-дневного прогноза
    #
    # @param data [Hash] хэш с данными прогноза погоды
    # @return [Hash] хэш, где ключ - время (dt_txt), значение - влажность в процентах
    # @return [Hash] пустой хэш, если данные отсутствуют
    #
    # @example
    #   data = {
    #     list: [
    #       { dt_txt: "2024-01-15 12:00:00", main: { humidity: 65 } },
    #       { dt_txt: "2024-01-16 12:00:00", main: { humidity: 70 } }
    #     ]
    #   }
    #   parser.extract_humidity_forecast(data)
    #   # => { "2024-01-15 12:00:00" => 65, "2024-01-16 12:00:00" => 70 }
    #
    def extract_humidity_forecast(data)
      ddata = data.dig(:list)
      return {} unless ddata 
      llist = {}
      ddata.each do |dat|
        time = dat.dig(:dt_txt)
        hhumidity = dat.dig(:main, :humidity)
        llist[time] = hhumidity if time && hhumidity
      end
      llist
    end


    # Извлекает прогноз погодных условий из данных 5-дневного прогноза
    #
    # @param data [Hash] хэш с данными прогноза погоды
    # @return [Hash] хэш, где ключ - время (dt_txt), значение - описание погоды
    # @return [Hash] пустой хэш, если данные отсутствуют
    #
    # @example
    #   data = {
    #     list: [
    #       { dt_txt: "2024-01-15 12:00:00", weather: [{ description: "clear sky" }] },
    #       { dt_txt: "2024-01-16 12:00:00", weather: [{ description: "light rain" }] }
    #     ]
    #   }
    #   parser.extract_condition_forecast(data)
    #   # => { "2024-01-15 12:00:00" => "clear sky", "2024-01-16 12:00:00" => "light rain" }
    #
    def extract_condition_forecast(data)
      ddata = data.dig(:list)
      return {} unless ddata 
      llist = {}
      ddata.each do |dat|
        time = dat.dig(:dt_txt)
        condition = dat.dig(:weather, 0, :description)
        llist[time] = condition if time && condition
      end
      llist
    end



    # Парсит JSON и извлекает все основные данные о прогнозе погоды
    #
    # Этот метод объединяет парсинг JSON и извлечение всех параметров прогноза
    # (температура, влажность, условия) в одном вызове для удобства использования.
    #
    # @param json_string [String] JSON строка от API с данными прогноза погоды
    # @return [Hash] хэш с ключами :temperature, :humidity, :condition,
    #   каждый из которых содержит хэш с временными метками и соответствующими значениями
    #
    # @example
    #   json = '{
    #     "list": [
    #       {
    #         "dt_txt": "2024-01-15 12:00:00",
    #         "main": { "temp": 20.5, "humidity": 65 },
    #         "weather": [{ "description": "clear sky" }]
    #       }
    #     ]
    #   }'
    #   
    #   result = parser.parse_all_forecast(json)
    #   # => {
    #   #   temperature: { "2024-01-15 12:00:00" => 20.5 },
    #   #   humidity: { "2024-01-15 12:00:00" => 65 },
    #   #   condition: { "2024-01-15 12:00:00" => "clear sky" }
    #   # }
    #
    # @note Если данные прогноза отсутствуют, все значения будут пустыми хэшами
    #
    def parse_all_forecast(json_string)
      ddata = parse(json_string)

      {

      temperature: extract_temp_forecast(ddata),
      humidity: extract_humidity_forecast(ddata),
      condition: extract_condition_forecast(ddata)

      }

    end

  end
end