# frozen_string_literal: true

require_relative "lib/weather_api_client/version"

Gem::Specification.new do |spec|
  spec.name = "weather_api_client"
  spec.version = WeatherApiClient::VERSION
  spec.authors = ["Sergey Donets", "Egor Surnev", "Eduard Lushchevich", "Arseniy Kovalev"]
  spec.email = ["sdonec3@gmail.com"]

  spec.summary = "Console weather client for PMI-3 university project"
  spec.description = "A Ruby gem that provides current weather and 5-day forecast using OpenWeatherMap API with a colorized CLI."
  spec.homepage = "https://github.com/Chacha-Muchacha/weather_api_client"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  # Основные зависимости
  spec.add_dependency "httparty"
  spec.add_dependency "colorize"

  # Зависимости для разработки и тестирования
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Какие файлы включать в гем
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end