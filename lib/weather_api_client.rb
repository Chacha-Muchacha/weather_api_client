# frozen_string_literal: true

require_relative "weather_api_client/version"
require_relative "weather_api_client/client/rb"
require_relative "weather_api_client/parser"
require_relative "weather_api_client/cli"

module WeatherApiClient
  class Error < StandardError; end
  
  # Это метод, который можно будет вызвать из консоли
  def self.run
    CLI.start
  end
end