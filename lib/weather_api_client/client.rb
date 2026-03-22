require_relative 'client/errors'
require_relative 'client/geo'
require_relative 'client/weather_data'

module WeatherApiClient
  class Client
    # Твой ключ OpenWeatherMap
    API_KEY = "d83dc87e13390e61b47db6189845d913"

    # Основной метод, который требует ТЗ
    def self.fetch_weather(city)
      # Используем модуль WeatherData для получения строки JSON
      WeatherData.fetch_by_city(city, API_KEY)
    end

    # Дополнительный метод (если захочешь узнать координаты)
    def self.fetch_location(city)
      Geo.fetch_coords(city, API_KEY)
    end
  end
end

if __FILE__ == $0 # Запустится только если запустить этот файл напрямую
  begin
    puts "Запрос погоды для Москвы..."
    json_result = WeatherApiClient::Client.fetch_weather("Moscow")
    puts WeatherApiClient::Client.fetch_location("Moscow")
    puts "Успех! Получен JSON:"
    puts json_result
  rescue WeatherApiClient::Error => e
    puts "Произошла ошибка: #{e.message}"
  end
end