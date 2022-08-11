class Subscriptions::ResumesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_current_account_admin
  before_action :set_subscription

  def show
  end

  def update
    @subscription.resume
    redirect_to subscriptions_path
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :show, status: :unprocessable_entity
  end

  private

  def set_subscription
    @subscription = current_account.subscriptions.find_by_prefix_id(params[:subscription_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to subscriptions_path
  end
end
