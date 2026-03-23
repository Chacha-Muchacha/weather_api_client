require 'json'



module WeatherApiClient
  class Parser
    def parse(json_string)
      JSON.parse(json_string, symbolize_names: true)
    rescue JSON::ParserError => e
      raise "Failed to parse JSON response: #{e.messadge}"
    end

    def extract_temp_coord_city(data)
      data.dig(:main, :temp)
    end

    def extract_humidity_coord_city(data)
      data.dig(:main, :humidity)
    end

    def extract_condition_coord_city(data)
      data.dig(:weather, 0, :description)
    end


    def parse_all_coord_city(json_string)
      ddata = parse(json_string)

      {

      temperature: extract_temp_coord_city(ddata),
      humidity: extract_humidity_coord_city(ddata),
      condition: extract_condition_coord_city(ddata)

      }

    end

    def extract_temp_forecast(data)
      ddata = data.dig(:list)
      return {} unless ddata 
      llist = {}
      ddata.each do |dat|
        time = dat.dig(:dt_txt)
        temperature = dat.dig(:main, :temp)
        llist[time] = temperature if time && temperature 
      end
      llist
    end

    def extract_humidity_forecast(data)
      ddata = data.dig(:list)
      return {} unless ddata 
      llist = {}
      ddata.each do |dat|
        time = dat.dig(:dt_txt)
        hhumidity = dat.dig(:main, :humidity)
        llist[time] = hhumidity if time && hhumidity
      end
      llist
    end

    def extract_condition_forecast(data)
      ddata = data.dig(:list)
      return {} unless ddata 
      llist = {}
      ddata.each do |dat|
        time = dat.dig(:dt_txt)
        condition = dat.dig(:weather, 0, :description)
        llist[time] = condition if time && condition
      end
      llist
    end

    def parse_all_forecast(json_string)
      ddata = parse(json_string)

      {

      temperature: extract_temp_forecast(ddata),
      humidity: extract_humidity_forecast(ddata),
      condition: extract_condition_forecast(ddata)

      }

    end

  end
end