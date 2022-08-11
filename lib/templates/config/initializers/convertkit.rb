# ConvertKit API client
# https://github.com/excid3/convertkit-ruby
#
# Example usage
# Jumpstart::Clients.convertkit.add_subscriber_to_form(form_id, email, options={})
# Jumpstart::Clients.convertkit.add_subscriber_to_sequence(sequence_id, email, options={})
# Jumpstart::Clients.convertkit.add_subscriber_to_tag(tag_id, email, options={})

Convertkit.configure do |config|
  config.api_key = Rails.application.credentials.dig(:convertkit, :api_key)
  config.api_secret = Rails.application.credentials.dig(:convertkit, :api_secret)
end

Jumpstart::Clients.convertkit = Convertkit::Client.new
