class Accounts::TransfersController < Accounts::BaseController
  before_action :set_account
  before_action :require_account_owner!

  def update
    if @account.transfer_ownership(params[:user_id])
      redirect_to @account, notice: t(".success")
    else
      redirect_to edit_account_path(@account), alert: t(".invalid")
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = current_user.accounts.find_by!(id: params[:account_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to accounts_path
  end

  def require_account_owner!
    redirect_to @account, alert: t(".not_allowed") unless @account.owner?(current_user)
  end
end
