module Jumpstart
  class Configuration
    module Gemfile
      # Manages dependencies in the Jumpstart Pro Gemfile

      extend ActiveSupport::Concern

      def gemfile_path
        Rails.root.join("config/jumpstart/Gemfile")
      end

      def save_gemfile
        gems = dependencies

        content = ""
        content += format_dependencies(gems[:main]) if gems[:main].any?
        content += "\n\ngroup :test do\n#{format_dependencies(gems[:test], spacing: "  ")}\nend" if gems[:test].any?
        content += "\n\ngroup :development do\n#{format_dependencies(gems[:development], spacing: "  ")}\nend" if gems[:development].any?

        FileUtils.mkdir_p Rails.root.join("config/jumpstart")
        File.write(gemfile_path, content)
      end

      def dependencies
        gems = {main: [], test: [], development: []}
        gems[:main] += Array.wrap(omniauth_providers).map { |provider|
          case provider
          when "twitter"
            {name: "omniauth-#{provider}", github: "excid3/omniauth-twitter"}
          when "facebook"
            {name: "omniauth-#{provider}", github: "excid3/omniauth-facebook"}
          else
            {name: "omniauth-#{provider}"}
          end
        }
        gems[:main] += [{name: "airbrake"}] if airbrake?
        gems[:main] += [{name: "appsignal"}] if appsignal?
        gems[:main] += [{name: "convertkit-ruby", github: "excid3/convertkit-ruby", require: "convertkit"}] if convertkit?
        gems[:main] += [{name: "gibbon"}] if mailchimp?
        gems[:main] += [{name: "drip-ruby", require: "drip"}] if drip?
        gems[:main] += [{name: "honeybadger"}] if honeybadger?
        gems[:main] += [{name: "intercom-rails"}] if intercom?
        gems[:main] += [{name: "rollbar"}] if rollbar?
        gems[:main] += [{name: "scout_apm"}] if scout?
        gems[:main] += [{name: "bugsnag"}] if bugsnag?
        if sentry?
          gems[:main] += [{name: "sentry-ruby"}, {name: "sentry-rails"}]
          gems[:main] += [{name: "sentry-sidekiq"}] if job_processor == :sidekiq
        end
        gems[:main] += [{name: "skylight"}] if skylight?
        gems[:main] += [{name: "stripe"}] if stripe?
        gems[:main] += [{name: "braintree"}] if braintree? || paypal?
        gems[:main] += [{name: "paddle_pay"}] if paddle?

        # Add background job processor
        case job_processor.to_s
        when "async"
          # Skip
        when "delayed_job"
          gems[:main] += [{name: "delayed_job_active_record"}]
        else
          gems[:main] += [{name: job_processor.to_s}]
        end

        gems[:development] += [{name: "solargraph-rails", version: "~> 0.2.0.pre"}] if solargraph?

        # Turbo Native dependencies
        gems[:main] += [{name: "apnotic"}] if apns?
        gems[:main] += [{name: "googleauth"}] if fcm?

        gems
      end

      def format_dependencies(group, spacing: "")
        group.map { |details|
          name = details.delete(:name)
          version = details.delete(:version)
          require_gem = details.delete(:require)
          options = details.map { |k, v| "#{k}: '#{v}'" }.join(", ")
          line = spacing + "gem '#{name}'"
          line += ", '#{version}'" if version.present?
          line += ", #{options}" if options.present?

          case require_gem
          when true, false
            line += ", require: #{require_gem}"
          when String
            line += ", require: '#{require_gem}'"
          end

          line
        }.join("\n")
      end

      def verify_dependencies!
        content = File.read gemfile_path

        dependencies.each do |group, items|
          unless items.all? { |dependency| content.include?(dependency[:name].to_s) }
            save_gemfile
            puts "It looks like your Jumpstart dependencies are out of sync. We've updated your Jumpstart Gemfile to match the dependencies you have selected.\nRun 'bundle' to install them and then restart your app."
            exit 1
          end
        end
      end
    end
  end
end
