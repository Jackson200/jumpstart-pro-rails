require "pagy"
require "pagy/extras/trim"

module Jumpstart
  class Engine < ::Rails::Engine
    isolate_namespace Jumpstart
    engine_name "jumpstart"

    config.app_generators do |g|
      g.templates.unshift File.expand_path("../templates", __dir__)
      g.scaffold_stylesheet false
    end

    config.before_initialize do
      Jumpstart.config = Jumpstart::Configuration.load!
      Jumpstart.config.verify_dependencies!
    end

    config.to_prepare do
      Administrate::ApplicationController.helper Jumpstart::AdministrateHelpers
    end

    initializer "turbo.native.navigation.helper" do
      ActiveSupport.on_load(:action_controller_base) do
        helper Turbo::Native::Navigation
      end
    end

    initializer "jumpstart.setup" do |app|
      # Set ActiveJob from Jumpstart
      ActiveJob::Base.queue_adapter = Jumpstart::JobProcessor.queue_adapter(Jumpstart.config.job_processor)

      if Rails.env.development?
        # This makes sure we can load the Jumpstart assets in development
        config.assets.precompile << "jumpstart_manifest.js"
      end

      if Jumpstart::Multitenancy.path? || Rails.env.test?
        app.config.middleware.use Jumpstart::AccountMiddleware
      end
    end
  end
end
