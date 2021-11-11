require_relative "lib/analytic/version"

Gem::Specification.new do |spec|
  spec.name        = "analytic"
  spec.version     = Analytic::VERSION
  spec.authors     = ["Kevin"]
  spec.email       = ["comictvn@gmail.com"]
  spec.homepage    = ""
  spec.summary     = "Summary of Analytic."
  spec.description = "Description of Analytic."
  spec.license     = "MIT"
  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "6.0.3.6"
  spec.add_dependency "mongoid"
  spec.add_dependency "creek"
  spec.add_dependency "shrine", "~> 3.0"
  spec.add_dependency 'shrine-mongoid', "~> 1.0"
  spec.add_dependency "shared"
  spec.add_dependency 'mongoid_search'
  spec.add_dependency 'content_disposition', '~> 1.0'
  spec.add_dependency 'wisper'
  spec.add_dependency "pundit"
  spec.add_dependency "xlsxwriter"
end
