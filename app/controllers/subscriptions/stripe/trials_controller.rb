class Subscriptions::Stripe::TrialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan

  def show
    current_account.set_payment_processor :stripe
    @pay_subscription = current_account.payment_processor.subscribe(
      plan: @plan.id_for_processor(:stripe),
      trial_period_days: @plan.trial_period_days,
      automatic_tax: {
        enabled: @plan.automatic_tax?
      },
      promotion_code: params[:promo_code]
    )
    redirect_to root_path, notice: t("subscriptions.created")
  end

  private

  def set_plan
    @plan = Plan.without_free.find(params[:plan])
  rescue ActiveRecord::RecordNotFound
    redirect_to subscriptions_path
  end
end
