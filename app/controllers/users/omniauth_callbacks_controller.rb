class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Jumpstart::Omniauth::Callbacks

  # Jumpstart Pro's Callbacks module handles:
  #
  #   1. Registering with OAuth
  #   2. Connecting OAuth when logged in
  #   3. Logging in with OAuth
  #   4. Rejecting OAuth if user already has account, but hasn't connected this OAuth account yet

  # For extra processing on the account that was just connected,
  # simply define a method like the following examples:
  #
  # def github_connected(connected_account)
  # end
  #
  # def twitter_connected(connected_account)
  # end
  #
  # etc...

  # To change the redirect URL after an account is connected, you can override the following methods:
  #
  # After sign up and sign in with OAuth
  # def after_sign_in_path_for(resource)
  #   root_path
  # end
  #
  # After connecting an OAuth account while logged in
  # def after_connect_redirect_path
  #   user_connected_accounts_path
  # end
end
