require_relative 'client/errors'
require_relative 'client/geo'
require_relative 'client/weather_data'

module WeatherApiClient
  class Client
    API_KEY = "d83dc87e13390e61b47db6189845d913"

    # Текущая погода по городу
    def self.fetch_weather(city)
      WeatherData.fetch_by_city(city, API_KEY)
    end

    # Прогноз по городу
    def self.fetch_forecast(city)
      WeatherData.fetch_forecast(city, API_KEY)
    end

    # Погода по координатам
    def self.fetch_by_coords(lat, lon)
      WeatherData.fetch_by_coords(lat, lon, API_KEY)
    end
  end
end
