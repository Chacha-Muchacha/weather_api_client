require_relative 'client'
require_relative 'parser'
require 'colorize'

module WeatherApiClient
  class CLI
    def self.start
      puts "🌦️  Welcome to Weather API Client! 🌍".light_blue
      puts "Type 'exit' to quit.\n\n"

      loop do
        print "Enter city name (or 'exit' to quit): "
        input = gets.chomp.strip
        break if input.downcase == 'exit'

        if input.empty?
          puts "⚠️  Please enter a city name.\n\n".yellow
          next
        end

        puts "\nWhat do you want to see?"
        puts "  1. Current weather"
        puts "  2. 5-day forecast"
        print "Your choice (1 or 2): "
        choice = gets.chomp.strip

        case choice
        when "1"
          show_current_weather(input)
        when "2"
          show_forecast(input)
        else
          puts "❌  Invalid choice, please enter 1 or 2.\n\n".red
        end
      end

      puts "👋  Goodbye!"
    end

    private

    def self.show_current_weather(city)
      begin
        raw_json = WeatherApiClient::Client.fetch_weather(city)
        data = WeatherApiClient::Parser.new.parse_all_coord_city(raw_json)

        temp = data[:temperature]
        condition = data[:condition]
        humidity = data[:humidity]

        colored_temp = colorize_temp(temp)

        puts "\n📍 Weather in #{city.capitalize}:"
        puts "  🌡️  Temperature: #{colored_temp}"
        puts "  ☁️  Condition:   #{condition.capitalize}"
        puts "  💧  Humidity:    #{humidity}%"
        puts ""
      rescue StandardError => e
        puts "❌  Error: #{e.message}\n\n".red
      end
    end

    def self.show_forecast(city)
      begin
        forecast_raw = WeatherApiClient::Client.fetch_forecast(city)
        parser = WeatherApiClient::Parser.new
        forecast_data = parser.parse_all_forecast(forecast_raw)

        temps = forecast_data[:temperature]
        conditions = forecast_data[:condition]
        humidities = forecast_data[:humidity]

        target_hours = [0, 6, 12, 18]
        forecast_by_day = {}
        temps.each do |datetime_str, temp|
          date_part, time_part = datetime_str.split(' ')
          hour = time_part.split(':')[0].to_i
          next unless target_hours.include?(hour)

          forecast_by_day[date_part] ||= {}
          forecast_by_day[date_part][hour] = {
            temp: temp,
            condition: conditions[datetime_str],
            humidity: humidities[datetime_str],
            time: time_part
          }
        end

        puts "\n📅 5-day forecast (every 6 hours):\n\n"
        forecast_by_day.sort.first(5).each do |date, hours_data|
          puts "📆 #{date}:"
          [0, 6, 12, 18].each do |hour|
            data = hours_data[hour]
            if data
              colored_temp = colorize_temp(data[:temp])
              puts "   #{data[:time]}  🌡️ #{colored_temp}  ☁️ #{data[:condition].capitalize}  💧 #{data[:humidity]}%"
            else
              puts "   #{hour}:00  ⚠️  Data not available"
            end
          end
          puts ""
        end
      rescue StandardError => e
        puts "❌  Error fetching forecast: #{e.message}\n\n".red
      end
    end

    def self.colorize_temp(temp)
      if temp > 20
        "#{temp}°C".red
      elsif temp < 0
        "#{temp}°C".blue
      else
        "#{temp}°C".green
      end
    end
  end
end
