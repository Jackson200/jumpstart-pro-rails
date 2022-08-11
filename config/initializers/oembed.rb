# See the Ruby OEmbed GitHub for more details
# https://github.com/ruby-oembed/ruby-oembed

# Facebook/Instagram requires an `OEMBED_FACEBOOK_TOKEN` env var.
# This token is either a Facebook App Access Token (recommended) or Client Access Token.

OEmbed::Providers.register_all
OEmbed::Providers.register_fallback(
  OEmbed::ProviderDiscovery,
  OEmbed::Providers::Noembed
)

Rails.application.config.to_prepare do
  ActionText::ContentHelper.allowed_tags += %w[iframe script blockquote time]
  ActionText::ContentHelper.allowed_attributes += ["data-id", "data-flickr-embed", "target"]
end
