require_relative "lib/weather/version"

Gem::Specification.new do |spec|
  spec.name        = "weather"
  spec.version     = Weather::VERSION
  spec.authors     = ["vihuynh"]
  spec.email       = ["hcvi180788@gmail.com"]
  spec.homepage    = ""
  spec.summary     = "Summary of Weather."
  spec.description = "Description of Weather."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.add_dependency "pundit"
  spec.add_dependency "rails", "6.0.3.6"
  spec.add_dependency 'httparty'
  spec.add_dependency "dotenv-rails"
end
