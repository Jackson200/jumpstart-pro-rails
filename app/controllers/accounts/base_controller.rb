class Accounts::BaseController < ApplicationController
  def require_account_admin
    account_user = @account.account_users.find_by(user: current_user)
    unless account_user&.admin?
      redirect_to @account, alert: t("accounts.admin_required")
    end
  end
end
