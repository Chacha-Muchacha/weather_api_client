require 'httparty'

module WeatherApiClient
  class Client
    module WeatherData
      URL = "https://api.openweathermap.org/data/2.5/weather"

      def self.fetch_by_city(city, api_key)
        options = {
          query: {
            q: city,
            appid: api_key,
            units: 'metric',
            lang: 'ru'
          }
        }
        response = HTTParty.get(URL, options)

        if response.success?
          response.body
        else
          error_msg = response.parsed_response['message'] || "Ошибка сервера"
          raise WeatherApiClient::Error, "Ошибка погоды: #{error_msg}"
        end
      end
    end
  end
end