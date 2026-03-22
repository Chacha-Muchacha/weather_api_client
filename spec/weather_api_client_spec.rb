# frozen_string_literal: true

RSpec.describe WeatherApiClient do
  it "has a version number" do
    expect(WeatherApiClient::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
