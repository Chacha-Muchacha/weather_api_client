require 'httparty'

module WeatherApiClient
  class Client
    module WeatherData
      CURRENT_URL  = "https://api.openweathermap.org/data/2.5/weather"
      FORECAST_URL = "https://api.openweathermap.org/data/2.5/forecast"

      # 1. Погода по названию города (то, что было)
      def self.fetch_by_city(city, api_key)
        params = { q: city, units: 'metric', lang: 'ru' }
        make_request(CURRENT_URL, params, api_key)
      end

      # 2. Погода по точным координатам (широта и долгота)
      def self.fetch_by_coords(lat, lon, api_key)
        params = { lat: lat, lon: lon, units: 'metric', lang: 'ru' }
        make_request(CURRENT_URL, params, api_key)
      end

      # 3. Прогноз погоды на 5 дней (шаг 3 часа)
      def self.fetch_forecast(city, api_key)
        params = { q: city, units: 'metric', lang: 'ru' }
        make_request(FORECAST_URL, params, api_key)
      end

      private

      # Вспомогательный метод, чтобы не писать HTTParty.get и проверки каждый раз
      def self.make_request(url, params, api_key)
        options = { query: params.merge(appid: api_key) }

        response = HTTParty.get(url, options)

        if response.success?
          response.body
        else
          error_detail = response.parsed_response['message'] rescue "Ошибка сервера"
          raise WeatherApiClient::Error, "Ошибка API (#{response.code}): #{error_detail}"
        end
      end
    end
  end
end