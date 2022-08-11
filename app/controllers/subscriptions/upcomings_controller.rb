class Subscriptions::UpcomingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_current_account_admin
  before_action :set_subscription

  def show
    @invoice = @subscription.upcoming_invoice
  end

  private

  def set_subscription
    @subscription = current_account.subscriptions.find_by_prefix_id(params[:subscription_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to subscriptions_path
  end
end
