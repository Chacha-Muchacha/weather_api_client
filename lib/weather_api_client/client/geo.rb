require 'httparty'

module WeatherApiClient
  class Client
    module Geo
      URL = "http://api.openweathermap.org/geo/1.0/direct"

      def self.fetch_coords(city, api_key)
        options = { query: { q: city, limit: 1, appid: api_key } }
        response = HTTParty.get(URL, options)

        if response.success? && !response.parsed_response.empty?
          # Берем первый город из списка результатов
          data = response.parsed_response.first
          { lat: data["lat"], lon: data["lon"], name: data["name"] }
        else
          raise WeatherApiClient::Error, "Город '#{city}' не найден через Geo API"
        end
      end
    end
  end
end