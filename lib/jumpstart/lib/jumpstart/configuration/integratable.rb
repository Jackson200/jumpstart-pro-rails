module Jumpstart
  class Configuration
    module Integratable
      extend ActiveSupport::Concern

      AVAILABLE_PROVIDERS = {
        "AirBrake" => "airbrake",
        "AppSignal" => "appsignal",
        "BugSnag" => "bugsnag",
        "ConvertKit" => "convertkit",
        "Drip" => "drip",
        "Honeybadger" => "honeybadger",
        "Intercom" => "intercom",
        "MailChimp" => "mailchimp",
        "Rollbar" => "rollbar",
        "Scout" => "scout",
        "Sentry" => "sentry",
        "Skylight" => "skylight"
      }.freeze

      attr_writer :integrations

      AVAILABLE_PROVIDERS.values.each do |provider|
        define_method(:"#{provider}?") do
          integrations.include?(provider)
        end
      end

      def integrations
        @integrations || []
      end

      def self.has_credentials?(integration)
        credentials_for(integration).first.last.present? if credentials_for(integration).present?
      end

      def self.credentials_for(integration)
        Jumpstart.credentials.dig(Rails.env, integration.to_sym) || Jumpstart.credentials.dig(integration.to_sym) || {}
      end
    end
  end
end
