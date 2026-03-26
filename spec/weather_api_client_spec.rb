# frozen_string_literal: true

require "weather_api_client"

RSpec.describe WeatherApiClient::Parser do
  let(:parser) { WeatherApiClient::Parser.new }

  let(:fake_json) do
    '{ "main": { "temp": 15.5, "humidity": 60 }, "weather": [ { "description": "ясно" } ] }'
  end

  it "успешно извлекает температуру из JSON" do
    result = parser.parse_all_coord_city(fake_json)
    expect(result[:temperature]).to eq(15.5)
  end

  it "успешно извлекает влажность из JSON" do
    result = parser.parse_all_coord_city(fake_json)
    expect(result[:humidity]).to eq(60)
  end

  it "успешно извлекает описание погоды" do
    result = parser.parse_all_coord_city(fake_json)
    expect(result[:condition]).to eq("ясно")
  end
end