# == Schema Information
#
# Table name: user_connected_accounts
#
#  id                  :bigint           not null, primary key
#  access_token        :string
#  access_token_secret :string
#  auth                :text
#  expires_at          :datetime
#  provider            :string
#  refresh_token       :string
#  uid                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint
#
# Indexes
#
#  index_user_connected_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class User::ConnectedAccount < ApplicationRecord
  serialize :auth, JSON

  encrypts :access_token
  encrypts :access_token_secret

  # Associations
  belongs_to :user

  # Helper scopes for each provider
  Devise.omniauth_configs.each do |provider, _|
    scope provider, -> { where(provider: provider) }
  end

  # Look up from Omniauth auth hash
  def self.for_auth(auth)
    where(provider: auth.provider, uid: auth.uid).first
  end

  # Use this method to retrieve the latest access_token.
  # Token will be automatically renewed as necessary
  def token
    renew_token! if expired?
    access_token
  end

  # Tokens that expire very soon should be consider expired
  def expired?
    expires_at? && expires_at <= 30.minutes.from_now
  end

  # Force a renewal of the access token
  def renew_token!
    new_token = current_token.refresh!
    update(
      access_token: new_token.token,
      refresh_token: new_token.refresh_token,
      expires_at: Time.at(new_token.expires_at)
    )
  end

  def name
    auth&.dig("info", "name")
  end

  def email
    auth&.dig("info", "email")
  end

  def image_url
    auth&.dig("info", "image") || GravatarHelper.gravatar_url_for(email)
  end

  private

  def current_token
    OAuth2::AccessToken.new(
      strategy.client,
      access_token,
      refresh_token: refresh_token
    )
  end

  def strategy
    # First check the Jumpstart providers for credentials
    provider_config = Jumpstart::Omniauth.enabled_providers[provider.to_sym]

    # Fallback to the Rails credentials
    provider_config ||= Rails.application.credentials.dig(:omniauth, provider.to_sym)

    OmniAuth::Strategies.const_get(provider.classify).new(
      nil,
      provider_config[:public_key], # client id
      provider_config[:private_key] # client secret
    )
  end
end
