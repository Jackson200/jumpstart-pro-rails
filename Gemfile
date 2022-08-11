source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.0.0"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails", ">= 3.4.1"

# Use postgresql as the database for Active Record
gem "pg"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
# gem "turbo-rails", "~> 1.0", ">= 1.0.1"
# gem "turbo-rails", github: "hotwired/turbo-rails", branch: "turbo-7-2-0"
gem "turbo-rails", github: "marcelolx/turbo-rails", branch: "@hotwired/turbo/c4e0aba"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", "~> 1.0", ">= 1.0.2"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", github: "excid3/jbuilder", branch: "partial-paths" # "~> 2.11"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.12"

# Security update
gem "nokogiri", ">= 1.12.5"

group :development, :test do
  # Start debugger with binding.b [https://github.com/ruby/debug]
  gem "debug", ">= 1.0.0", platforms: %i[mri mingw x64_mingw]

  # Optional other debugging tools
  # gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # gem "pry-rails"

  gem "annotate", github: "excid3/annotate_models", branch: "rails7"
  gem "letter_opener_web", "~> 2.0"
  gem "standard", require: false
  gem "erb_lint", require: false

  # Security tooling to
  # gem "brakeman"
  # gem "bundler-audit", github: "rubysec/bundler-audit"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console", ">= 4.1.0"

  # A fully configurable and extendable Git hook manager
  gem "overcommit", require: false

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler", ">= 2.3.3"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# Jumpstart dependencies
gem "jumpstart", path: "lib/jumpstart", group: :omit

gem "acts_as_tenant", "~> 0.5.1"
gem "administrate", github: "excid3/administrate", branch: "jumpstart" # '~> 0.10.0'
gem "administrate-field-active_storage", "~> 0.4.1"
gem "cssbundling-rails", "~> 1.1.0"
gem "country_select", "~> 8.0"
gem "devise", "~> 4.8", ">= 4.8.1"
gem "devise-i18n", "~> 1.10"
gem "inline_svg", "~> 1.6"
gem "invisible_captcha", "~> 2.0"
gem "jsbundling-rails", "~> 1.0.0"
gem "local_time", "~> 2.1"
gem "name_of_person", "~> 1.0"
gem "noticed", "~> 1.5"
gem "oj", "~> 3.8", ">= 3.8.1"
gem "omniauth", "~> 2.0", ">= 2.0.4"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "pagy", "~> 5.1"
gem "pay", "~> 5.0.0"
gem "pg_search", "~> 2.3"
gem "prawn", github: "prawnpdf/prawn"
gem "prefixed_ids", "~> 1.2"
gem "pretender", "~> 0.4.0"
gem "pundit", "~> 2.1"
gem "receipts", "~> 2.0.0"
gem "responders", github: "excid3/responders", branch: "fix-redirect-status-config"
gem "rotp", "~> 6.2"
gem "rqrcode", "~> 2.1"
gem "ruby-oembed", "~> 0.16.0", require: "oembed"
gem "whenever", "~> 1.0", require: false

# Jumpstart manages a few gems for us, so install them from the extra Gemfile
if File.exist?("config/jumpstart/Gemfile")
  eval_gemfile "config/jumpstart/Gemfile"
end

# We recommend using strong migrations when your app is in production
# gem "strong_migrations", "~> 0.7.6"
