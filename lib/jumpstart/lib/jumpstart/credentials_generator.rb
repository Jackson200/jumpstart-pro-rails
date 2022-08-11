# Credentials Generator override
# This handles the shared credentials file
require "rails/generators"
require "rails/generators/rails/credentials/credentials_generator"

Rails::Generators::CredentialsGenerator.class_eval do
  def credentials_template
    Jumpstart::Credentials.template
  end
end

# Encrypted File Generator override
# This handles the environment credentials
require "rails/generators/rails/encrypted_file/encrypted_file_generator"

Rails::Generators::EncryptedFileGenerator.class_eval do
  private

  def encrypted_file_template
    Jumpstart::Credentials.template
  end
end

module Jumpstart
  module Credentials
    def self.template
      <<~YAML
        # Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
        secret_key_base: #{SecureRandom.hex(64)}

        active_record_encryption:
          primary_key: #{SecureRandom.alphanumeric(32)}
          deterministic_key: #{SecureRandom.alphanumeric(32)}
          key_derivation_salt: #{SecureRandom.alphanumeric(32)}

        # aws:
        #   access_key_id: 123
        #   secret_access_key: 345

        # Jumpstart config
        # ----------------

        # Used for encrypting OAuth access tokens
        access_token_encryption_key: '#{Base64.encode64(SecureRandom.random_bytes(32)).strip}'

        # Login Providers via OmniAuth
        # ---------------
        omniauth:
          # Add other OmniAuth providers here

          facebook:
            # https://developers.facebook.com/apps/
            public_key: ''
            private_key: ''
            # scope: 'email'

          google_oauth2:
            # https://code.google.com/apis/console/
            public_key: ''
            private_key: ''

          github:
            # https://github.com/settings/developers
            public_key: ''
            private_key: ''
            # scope: 'user:email'

          twitter:
            # https://apps.twitter.com
            public_key: ''
            private_key: ''
            secure_image_url: 'true'

        # Mail Providers
        # --------------

        mailjet:
          # https://app.mailjet.com/account/setup
          username: ''
          password: ''
          domain: ''

        mailgun:
          # https://app.mailgun.com/app/sending/domains/<YOUR_MAILGUN_DOMAIN>/credentials
          username: ''
          password: ''

        mandrill:
          # https://mandrillapp.com/settings/index
          username: ''
          password: ''
          domain: ''

        ohmysmtp:
          # https://app.ohmysmtp.com/ -> API Tokens
          username: ''
          password: ''

        postmark:
          # https://account.postmarkapp.com/servers -> Server -> API Tokens
          # Use token as both username and password
          username: ''
          password: ''

        sendgrid:
          # https://app.sendgrid.com/settings/api_keys
          username: 'apikey' # Leave this alone, the username is actually 'apikey'
          password: ''
          domain: example.com

        sendinblue:
          # https://account.sendinblue.com/advanced/api
          username: ''
          password: ''

        ses:
          # https://console.aws.amazon.com/ses/home
          username: ''
          password: ''
          address: ''

        sparkpost:
          # https://app.sparkpost.com/account/api-keys
          username: 'SMTP_Injection'
          password: ''

        ### Payment Providers

        # Braintree Payments (Required for PayPal support)
        # https://braintreegateway.com
        # https://sandbox.braintreegateway.com
        # Webhooks should be pointed to https://domain.com/webhooks/braintree
        braintree:
          environment: ''
          public_key: ''
          private_key: ''
          merchant_id: ''

        # Stripe Payments
        # https://dashboard.stripe.com/account/apikeys
        stripe:
          public_key: ''
          private_key: ''

          # For processing Stripe webhooks
          # https://dashboard.stripe.com/account/webhooks
          # Webhooks should be pointed to https://domain.com/webhooks/stripe
          signing_secret: ''

        # Paddle Payments
        # https://vendors.paddle.com/authentication
        paddle:
          vendor_id: ''
          vendor_auth_code: ''

          # For processing Paddle webhooks
          # https://vendors.paddle.com/public-key (only base64: MII...==)
          # Webhooks should be pointed to https://domain.com/webhooks/paddle
          public_key_base64: ''

        # Paddle
        # https://vendors.paddle.com/authentication
        # https://vendors.paddle.com/public-key
        paddle:
          vendor_id: ''
          vendor_auth_code: ''
          public_key_base64: ''

        ###  Integrations

        airbrake:
          # https://airbrake.io
          project_id: ''
          project_key: ''

        appsignal:
          # https://appsignal.com App -> App Settings -> Push & deploy -> Push key
          api_key: ''

        bugsnag:
          # https://app.bugsnag.com/settings -> Projects -> API Key
          api_key: ''

        convertkit:
          # https://app.convertkit.com/account/edit#account_info
          api_key: ''
          api_secret: ''

        drip:
          # https://www.getdrip.com/user/edit
          api_key: ''
          account_id: ''

        honeybadger:
          # https://www.honeybadger.io/
          api_key: ''

        intercom:
          # https://intercom.io
          # You can find this at Settings > Installation > Web
          app_id: ''

          # Optional, used for Identity Verification
          # You can find this at Settings > Installation > Security > Enforce identity on web
          api_secret: ''

        mailchimp:
          # https://mailchimp.com/
          api_key: ''

        scout:
          # https://scoutapm.com/
          api_key: ''

        sentry:
          # https://sentry.io
          dsn: ''

        skylight:
          # https://skylight.io
          # This should be the long 40+ character token from Settings, _not_the short setup token
          # You can click "create the application manually" when setting up a new Skylight app to skip the setup token step and get your auth_token
          auth_token: ''

        rollbar:
          # https://rollbar.com/
          access_token: ''
      YAML
    end
  end
end
