require "rollbar"

Rollbar.configure do |config|
  config.access_token = Rails.application.credentials.dig(:rollbar, :access_token)
  # Other Configuration Settings
end
