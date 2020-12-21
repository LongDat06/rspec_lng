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

  spec.add_dependency "rails", "~> 6.1.0"
end
