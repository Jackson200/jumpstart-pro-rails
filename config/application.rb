require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require "jumpstart"

module JumpstartApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.exceptions_app = routes

    # Where the I18n library should search for translation files
    # Search nested folders in config/locales for better organization
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

    # Permitted locales available for the application
    config.i18n.available_locales = [:en]

    # Set default locale
    config.i18n.default_locale = :en

    # Use default language as fallback if translation is missing
    config.i18n.fallbacks = true

    # Prevent sassc-rails from setting sass as the compressor
    # Libsass is deprecated and doesn't support modern CSS syntax used by TailwindCSS
    config.assets.css_compressor = nil

    # Rails 7 defaults to libvips as the variant processor
    # libvips is up to 10x faster and consumes 1/10th the memory of imagemagick
    # If you need to use imagemagick, uncomment this to switch
    # config.active_storage.variant_processor = :mini_magick
  end
end
