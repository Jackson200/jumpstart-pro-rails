class Api::V1::UsersController < Api::BaseController
  skip_before_action :authenticate_api_token!, only: [:create]
  before_action :configure_permitted_parameters, only: [:create]

  def create
    user = User.new(devise_parameter_sanitizer.sanitize(:sign_up))

    # If registering with an account, add the AccountUser with admin role
    if Jumpstart.config.register_with_account?
      account = user.owned_accounts.first_or_initialize
      account.account_users.new(user: user, admin: true)
    end

    if user.save
      if turbo_native_app?
        user.remember_me = true
        sign_in user
        render json: {
          token: user.api_tokens.first_or_create(name: ApiToken::APP_NAME).token
        }
      else
        api_token = user.api_tokens.first_or_create(name: ApiToken::DEFAULT_NAME)
        render json: {
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            api_tokens: [{
              id: api_token.id,
              name: api_token.name,
              token: api_token.token
            }]
          }
        }
      end
    else
      render json: {
        errors: user.errors,
        error: user.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end
  end

  private

  def devise_parameter_sanitizer
    @devise_parameter_sanitizer ||= Devise::ParameterSanitizer.new(User, :user, params)
  end
end
