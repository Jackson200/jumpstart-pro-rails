$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "jumpstart/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "jumpstart"
  s.version = Jumpstart::VERSION
  s.authors = ["Jason Charnes", "Chris Oliver"]
  s.email = ["jason@thecharnes.com", "excid3@gmail.com"]
  s.homepage = "https://jumpstartrails.com"
  s.summary = "Jumpstart your Rails project."
  s.description = "Jumpstart your Rails project, build a business."
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"

  # Dev Dependencies
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "sqlite3"
end
