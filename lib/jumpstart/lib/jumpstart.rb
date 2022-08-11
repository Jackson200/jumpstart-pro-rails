require "jumpstart/credentials_generator"
require "jumpstart/engine"

module Jumpstart
  autoload :AccountMiddleware, "jumpstart/account_middleware"
  autoload :Clients, "jumpstart/clients"
  autoload :Configuration, "jumpstart/configuration"
  autoload :Controller, "jumpstart/controller"
  autoload :JobProcessor, "jumpstart/job_processor"
  autoload :Mailer, "jumpstart/mailer"
  autoload :Mentions, "jumpstart/mentions"
  autoload :Multitenancy, "jumpstart/multitenancy"
  autoload :Omniauth, "jumpstart/omniauth"
  autoload :SubscriptionExtensions, "jumpstart/subscription_extensions"
  autoload :AdministrateHelpers, "jumpstart/administrate_helpers"

  mattr_accessor :config
  @@config = {}

  def self.restart
    run_command "rails restart"
  end

  # https://stackoverflow.com/a/25615344/277994
  def self.bundle
    run_command "bundle"
  end

  def self.run_command(command)
    Bundler.with_original_env do
      system command
    end
  end

  def self.find_plan(id)
    return if id.nil?
    config.plans.find { |plan| plan["id"].to_s == id.to_s }
  end

  def self.processor_plan_id_for(id, interval, processor)
    find_plan(id)[interval]["#{processor}_id"]
  end

  def self.credentials
    Rails.application.credentials
  end

  # Commands to be run after bundle install
  def self.post_install
    run_command("solargraph bundle") if config.solargraph?

    if JobProcessor.delayed_job? && !File.exist?("bin/delayed_job")
      run_command("rails g delayed_job:active_record")
      run_command("rails db:migrate")
    end
  end
end
