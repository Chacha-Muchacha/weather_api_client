require 'httparty'

module WeatherApiClient
  class Client
    API_KEY = "d83dc87e13390e61b47db6189845d913"
    BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

    def self.fetch_weather(city)
      options = { query: { q: city, appid: API_KEY, units: 'metric', lang: 'ru' } }
      # Делаем GET-запрос
      response = HTTParty.get(BASE_URL, options)
      # Проверяем результат
      if response.success?
        response.body # Возвращаем сырой JSON (строку)
      else
        error_msg = response.parsed_response['message'] || "Неизвестная ошибка"
        raise WeatherApiClient::Error, "Ошибка OpenWeatherMap API: #{error_msg}"
      end
    end
  end
end

