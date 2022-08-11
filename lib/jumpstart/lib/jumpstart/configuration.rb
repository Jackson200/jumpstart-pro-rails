require "jumpstart/configuration/gemfile"
require "jumpstart/configuration/mailable"
require "jumpstart/configuration/integratable"
require "jumpstart/configuration/payable"
require "open-uri"
require "thor"

module Jumpstart
  class Configuration
    include ActiveModel::Model
    include Thor::Actions
    include Mailable
    include Integratable
    include Payable
    include Gemfile

    # Attributes
    attr_accessor :application_name
    attr_accessor :business_name
    attr_accessor :business_address
    attr_accessor :domain
    attr_accessor :background_job_processor
    attr_accessor :email_provider
    attr_accessor :default_from_email
    attr_accessor :support_email
    attr_accessor :multitenancy
    attr_writer :omniauth_providers

    def self.load!
      if File.exist?(config_path)
        config_yaml = ERB.new(File.read(config_path)).result
        config = Psych.safe_load(config_yaml, permitted_classes: [Hash, Jumpstart::Configuration])
        return config if config.is_a?(Jumpstart::Configuration)
        new(config)
      else
        new
      end
    end

    def self.config_path
      Rails.root.join("config", "jumpstart.yml")
    end

    def self.create_default_config
      FileUtils.cp File.join(File.dirname(__FILE__), "../templates/jumpstart.yml"), config_path
    end

    def initialize(options = {})
      assign_attributes(options)
      self.application_name ||= "Jumpstart"
      self.business_name ||= "Jumpstart Company, LLC"
      self.domain ||= "example.com"
      self.support_email ||= "support@example.com"
      self.default_from_email ||= "Jumpstart <support@example.com>"
      self.job_processor ||= "async"

      self.personal_accounts = true if personal_accounts.nil?
    end

    def save
      # Creates config/jumpstart.yml
      File.write(self.class.config_path, to_yaml)

      # Updates config/jumpstart/Gemfile
      save_gemfile

      update_procfiles
      copy_configs

      generate_credentials

      # Change the Jumpstart config to the latest version
      Jumpstart.config = self
    end

    def job_processor
      (background_job_processor || "async").to_sym
    end

    def omniauth_providers
      Array.wrap(@omniauth_providers)
    end

    def register_with_account=(value)
      @register_with_account = ActiveModel::Type::Boolean.new.cast(value)
    end

    def register_with_account?
      @register_with_account.nil? ? false : ActiveModel::Type::Boolean.new.cast(@register_with_account)
    end

    def solargraph=(value)
      @solargraph = ActiveModel::Type::Boolean.new.cast(value)
    end

    def solargraph?
      @solargraph.nil? ? false : ActiveModel::Type::Boolean.new.cast(@solargraph)
    end

    def personal_accounts=(value)
      @personal_accounts = ActiveModel::Type::Boolean.new.cast(value)
    end

    def personal_accounts
      # Enabled by default
      @personal_accounts.nil? ? true : ActiveModel::Type::Boolean.new.cast(@personal_accounts)
    end

    def apns=(value)
      @apns = ActiveModel::Type::Boolean.new.cast(value)
    end

    def apns?
      ActiveModel::Type::Boolean.new.cast(@apns || false)
    end

    def fcm=(value)
      @fcm = ActiveModel::Type::Boolean.new.cast(value)
    end

    def fcm?
      ActiveModel::Type::Boolean.new.cast(@fcm || false)
    end

    def collect_billing_address=(value)
      @collect_billing_address = ActiveModel::Type::Boolean.new.cast(value)
    end

    def collect_billing_address?
      ActiveModel::Type::Boolean.new.cast(@collect_billing_address || false)
    end

    def update_procfiles
      write_procfile Rails.root.join("Procfile"), procfile_content
      write_procfile Rails.root.join("Procfile.dev"), procfile_content(dev: true)
    end

    def copy_configs
      if job_processor == :sidekiq
        copy_template("config/sidekiq.yml")
      end

      if airbrake?
        copy_template("config/initializers/airbrake.rb")
      end

      if appsignal?
        copy_template("config/appsignal.yml")
      end

      if bugsnag?
        copy_template("config/initializers/bugsnag.rb")
      end

      if convertkit?
        copy_template("config/initializers/convertkit.rb")
      end

      if drip?
        copy_template("config/initializers/drip.rb")
      end

      if honeybadger?
        copy_template("config/honeybadger.yml")
      end

      if intercom?
        copy_template("config/initializers/intercom.rb")
      end

      if mailchimp?
        copy_template("config/initializers/mailchimp.rb")
      end

      if rollbar?
        copy_template("config/initializers/rollbar.rb")
      end

      if scout?
        copy_template("config/scout_apm.yml")
      end

      if sentry?
        copy_template("config/initializers/sentry.rb")
      end

      if skylight?
        copy_template("config/skylight.yml")
      end

      if solargraph?
        URI.open "https://gist.githubusercontent.com/castwide/28b349566a223dfb439a337aea29713e/raw/715473535f11cf3eeb9216d64d01feac2ea37ac0/rails.rb" do |gist|
          File.write(Rails.root.join("config/definitions.rb"), gist.read)
        end
      end
    end

    def generate_credentials
      %w[test development staging production].each do |env|
        key_path = Pathname.new("config/credentials/#{env}.key")
        credentials_path = "config/credentials/#{env}.yml.enc"

        # Skip generating if credentials file already exists
        next if File.exist?(credentials_path)

        Rails::Generators::EncryptionKeyFileGenerator.new.add_key_file_silently(key_path)
        Rails::Generators::EncryptionKeyFileGenerator.new.ignore_key_file_silently(key_path)
        Rails::Generators::EncryptedFileGenerator.new.add_encrypted_file_silently(credentials_path, key_path, Jumpstart::Credentials.template)

        # Add the credentials if we're in a git repo
        if File.directory?(".git")
          system("git add #{credentials_path}")
        end
      end
    end

    private

    def procfile_content(dev: false)
      content = {web: "bundle exec rails s"}

      # Background workers
      if (worker_command = Jumpstart::JobProcessor.command(job_processor))
        content[:worker] = worker_command
      end

      # Add the Stripe CLI
      content[:stripe] = "stripe listen --forward-to localhost:3000/webhooks/stripe" if dev && stripe?

      content
    end

    def write_procfile(path, commands)
      commands.each do |name, command|
        new_line = "#{name}: #{command}"

        if (matches = File.foreach(path).grep(/#{name}:/)) && matches.any?
          # Warn only if lines don't match
          if (old_line = matches.first.chomp) && old_line != new_line
            Rails.logger.warn "\n'#{name}' already exists in #{path}, skipping. \nOld: `#{old_line}`\nNew: `#{new_line}`\n"
          end
        else
          File.open(path, "a") { |f| f.write("#{name}: #{command}\n") }
        end
      end
    end

    def copy_template(filename)
      # Safely copy template, so we don't blow away any customizations you made
      unless File.exist?(filename)
        FileUtils.cp(template_path(filename), Rails.root.join(filename))
      end
    end

    def template_path(filename)
      Rails.root.join("lib/templates", filename)
    end
  end
end
