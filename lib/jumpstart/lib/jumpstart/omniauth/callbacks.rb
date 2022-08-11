module Jumpstart
  module Omniauth
    module Callbacks
      Devise.omniauth_configs.keys.each do |provider|
        define_method provider do
          redirect_to root_path, alert: t("something_went_wrong") if auth.nil?

          if connected_account.present?
            # Account has already been connected before
            handle_previously_connected(connected_account)

          elsif user_signed_in?
            # User is signed in, but hasn't connected this account before
            attach_account

          elsif User.exists?(email: auth.info.email)
            # We haven't seen this account before, but we have an existing user with a matching email
            flash.alert = t(".account_exists")
            redirect_to new_user_session_path

          else
            # We've never seen this user before, so let's sign them up
            create_user
          end
        end
      end

      def failure
        redirect_to root_path, alert: t("something_went_wrong")
      end

      private

      def handle_previously_connected(connected_account)
        # Update connected account attributes
        connected_account.update(connected_account_params)
        run_connected_callback(connected_account)
        success_message!(kind: auth.provider)

        if user_signed_in?
          # Already connected account, we can just update the data
          redirect_to after_connect_redirect_path
        else
          # Account was already connected, so we can sign in the user
          sign_in_and_redirect connected_account.user, event: :authentication
        end
      end

      def create_user
        user = User.new(
          email: auth.info.email,
          terms_of_service: true,
          name: auth.info.name
        )
        user.password = ::Devise.friendly_token[0, 20] if user.respond_to?(:password=)
        user.skip_confirmation!
        user.connected_accounts.new(connected_account_params)

        user.save!

        run_connected_callback(user.connected_accounts.last)

        sign_in_and_redirect(user, event: :authentication)
        success_message!(kind: auth.provider)
      end

      def attach_account
        connected_account = current_user.connected_accounts.create(connected_account_params)
        run_connected_callback(connected_account)

        redirect_to after_connect_redirect_path
        success_message!(kind: auth.provider)
      end

      def run_connected_callback(connected_account)
        method = "#{auth.provider.underscore}_connected"
        send(method.to_sym, connected_account) if respond_to?(method)
      end

      def auth
        @auth ||= request.env["omniauth.auth"]
      end

      def omniauth_params
        request.env["omniauth.params"]
      end

      def expires_at
        Time.at(auth.credentials.expires_at) if auth.credentials.expires_at.present?
      end

      def success_message!(kind:)
        return unless is_navigational_format?
        set_flash_message(:notice, :success, kind: t("shared.oauth.#{kind}"))
      end

      def connected_account
        @connected_account ||= User::ConnectedAccount.for_auth(auth)
      end

      def after_connect_redirect_path
        user_connected_accounts_path
      end

      def connected_account_params
        # Clean auth hash credentials
        auth_hash = auth.to_hash
        auth_hash.delete("credentials")
        auth_hash["extra"]&.delete("access_token")

        {
          provider: auth.provider,
          uid: auth.uid,
          access_token: auth.credentials.token,
          access_token_secret: auth.credentials.secret,
          expires_at: expires_at,
          refresh_token: auth.credentials.refresh_token,
          auth: auth_hash
        }
      end
    end
  end
end
