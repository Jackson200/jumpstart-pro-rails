module Authorization
  # Adds authorization with Pundit to controllers

  extend ActiveSupport::Concern
  include Pundit::Authorization

  # Use AccountUser since it determines the roles for the current Account
  def pundit_user
    current_account_user
  end

  private

  # You can also customize the messages using the policy and action to generate the I18n key
  # https://github.com/varvet/pundit#creating-custom-error-messages
  def user_not_authorized
    flash[:alert] = t("unauthorized")
    redirect_back fallback_location: root_path
  end
end
