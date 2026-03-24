require_relative 'client/errors'
require_relative 'client/geo'
require_relative 'client/weather_data'

module WeatherApiClient
  # Основной класс для взаимодействия с Weather API.
  # Предоставляет методы для получения текущей погоды и прогнозов.
  class Client
    API_KEY = "d83dc87e13390e61b47db6189845d913"

    # Получает текущую погоду для указанного города.
    #
    # @param city [String] Название города (например, "Moscow" или "London,uk").
    # @return [String] JSON-ответ от API с данными о текущей погоде.
    # @raise [WeatherApiClient::Error] Если город не найден или произошла ошибка API.
    #
    # @example Получение погоды для Москвы
    #   WeatherApiClient::Client.fetch_weather("Moscow")
    def self.fetch_weather(city)
      WeatherData.fetch_by_city(city, API_KEY)
    end

    # Получает прогноз погоды на 5 дней с шагом в 3 часа.
    #
    # @param city [String] Название города.
    # @return [String] JSON-ответ от API с данными прогноза.
    # @raise [WeatherApiClient::Error] Если API вернуло ошибку.
    #
    # @example Получение прогноза
    #   WeatherApiClient::Client.fetch_forecast("London")
    def self.fetch_forecast(city)
      WeatherData.fetch_forecast(city, API_KEY)
    end

    # Получает текущую погоду по географическим координатам.
    #
    # @param lat [Float, String] Широта.
    # @param lon [Float, String] Долгота.
    # @return [String] JSON-ответ от API.
    # @raise [WeatherApiClient::Error] Если координаты неверны или API недоступно.
    #
    # @example Поиск по координатам
    #   WeatherApiClient::Client.fetch_by_coords(55.75, 37.61)
    def self.fetch_by_coords(lat, lon)
      WeatherData.fetch_by_coords(lat, lon, API_KEY)
    end
  end
end
