class Api::V1::AccountsController < Api::BaseController
  def index
    @accounts = current_user.accounts
    render "accounts/index"
  end
end
