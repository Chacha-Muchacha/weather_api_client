require_relative 'client'
require_relative 'parser'

module WeatherApiClient
  class CLI
    def self.start
      puts "Welcome to Weather API Client!"
      puts "Type 'exit' to quit.\n\n"

      loop do
        print "Enter city name (or 'exit' to quit): "
        input = gets.chomp.strip
        break if input.downcase == 'exit'

        if input.empty?
          puts "Please enter a city name.\n\n"
          next
        end

        show_current_weather(input)
      end

      puts "Goodbye!"
    end

    private

    def self.show_current_weather(city)
      begin
        raw_json = WeatherApiClient::Client.fetch_weather(city)
        data = WeatherApiClient::Parser.new.parse_all_coord_city(raw_json)

        temp = data[:temperature]
        condition = data[:condition]
        humidity = data[:humidity]

        puts "\nWeather in #{city.capitalize}:"
        puts "  Temperature: #{temp}°C"
        puts "  Condition:   #{condition.capitalize}"
        puts "  Humidity:    #{humidity}%"
        puts ""
      rescue StandardError => e
        puts "Error: #{e.message}\n\n"
      end
    end
  end
end