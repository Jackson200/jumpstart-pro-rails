class Users::SudoController < ActionController::Base
  before_action :authenticate_user!

  def create
    if current_user.valid_password?(params[:password])
      session[:sudo] = Time.current.to_s
      # Enforce that we stay on the same host
      redirect_to URI.parse(params[:redirect_to]).path
    else
      flash[:alert] = I18n.t("users.sudo.invalid_password")
      render :new, status: :unprocessable_entity
    end
  end
end
