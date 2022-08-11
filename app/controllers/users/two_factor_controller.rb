class Users::TwoFactorController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_backup_codes
  before_action :ensure_otp_secret

  def show
    redirect_to edit_user_password_path
  end

  def backup_codes
  end

  def verify
  end

  def create
    if current_user.verify_and_consume_otp!(params[:code])
      current_user.enable_two_factor!
      redirect_to edit_account_password_path, notice: t(".enabled")
    else
      flash.now[:alert] = t("users.sessions.create.incorrect_verification_code")
      render :verify, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.disable_two_factor!
    redirect_to edit_account_password_path, status: :see_other, notice: t(".disabled")
  end

  private

  def ensure_backup_codes
    current_user.generate_otp_backup_codes! unless current_user.otp_backup_codes?
  end

  def ensure_otp_secret
    current_user.set_otp_secret!
  end
end
