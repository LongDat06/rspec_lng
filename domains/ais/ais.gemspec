require_relative "lib/ais/version"

Gem::Specification.new do |spec|
  spec.name        = "ais"
  spec.version     = Ais::VERSION
  spec.authors     = ["vihuynh"]
  spec.email       = ["hcvi180788@gmail.com"]
  spec.homepage    = ""
  spec.summary     = "Summary of Ais."
  spec.description = "Description of Ais."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "6.0.3.4"
  spec.add_dependency "dotenv-rails"
  spec.add_dependency 'fast_jsonapi', '~> 1.3'
  spec.add_dependency 'httparty'
  spec.add_dependency 'pagy', '~> 3.10'
  spec.add_dependency 'enumerize'
  spec.add_dependency "shared"
  spec.add_dependency "activerecord-import"
  spec.add_dependency "ruby-gmail"
end
