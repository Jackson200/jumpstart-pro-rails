class Subscriptions::StripeController < ApplicationController
  # Handles Stripe PaymentElement callback

  before_action :authenticate_user!
  before_action :require_current_account_admin
  before_action :set_subscription, only: [:show]

  def show
    @pay_subscription = Pay::Stripe::Subscription.sync(@pay_subscription.processor_id)

    if @pay_subscription.active?
      current_account.set_payment_processor :stripe
      redirect_to root_path, notice: t("subscriptions.created")
    else
      redirect_to root_path, alert: t("something_went_wrong")
    end
  end

  private

  def set_subscription
    @pay_subscription = current_account.subscriptions.find_by_prefix_id(params[:subscription_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to subscriptions_path
  end
end
