require 'json'

module WeatherApiClient
  # Класс для парсинга и извлечения данных из ответов OpenWeather API.
  class Parser
    # Преобразует строку JSON в хэш с символьными ключами.
    # @param json_string [String] JSON-ответ.
    # @return [Hash] десериализованные данные.
    # @raise [RuntimeError] если формат JSON невалиден.
    def parse(json_string)
      JSON.parse(json_string, symbolize_names: true)
    rescue JSON::ParserError => e
      raise "Failed to parse JSON response: #{e.message}"
    end

    # Извлекает данные о текущей погоде.
    # @param json_string [String] JSON-ответ.
    # @return [Hash] хэш с температурой, влажностью и описанием.
    def parse_all_coord_city(json_string)
      ddata = parse(json_string)
      {
        temperature: ddata.dig(:main, :temp),
        humidity: ddata.dig(:main, :humidity),
        condition: ddata.dig(:weather, 0, :description)
      }
    end

    # Извлекает данные прогноза на 5 дней.
    # @param json_string [String] JSON-ответ.
    # @return [Hash] хэш со списками температур, влажности и состояний по времени.
    def parse_all_forecast(json_string)
      ddata = parse(json_string)
      {
        temperature: extract_forecast_field(ddata, [:main, :temp]),
        humidity: extract_forecast_field(ddata, [:main, :humidity]),
        condition: extract_forecast_field(ddata, [:weather, 0, :description])
      }
    end

    private

    # Универсальный метод для извлечения полей из списка прогнозов.
    # @param data [Hash] спарсенный JSON.
    # @param keys [Array] путь к полю в структуре данных.
    # @return [Hash] словарь { время => значение }.
    def extract_forecast_field(data, keys)
      list = data.dig(:list)
      return {} unless list
      
      result = {}
      list.each do |entry|
        time = entry.dig(:dt_txt)
        value = entry.dig(keys[0], keys[1]) if keys.size == 2
        value = entry.dig(keys[0], 0, keys[2]) if keys.size == 3 # для weather[0].description
        
        result[time] = value if time && value
      end
      result
    end
  end
end