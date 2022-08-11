class Subscriptions::BillingAddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_current_account_admin
  before_action :set_plan

  layout "checkout"

  def show
  end

  def update
    @billing_address = current_account.billing_address || current_account.build_billing_address
    if @billing_address.update(billing_address_params)
      redirect_to new_subscription_path(plan: @plan.id, step: :payment, promo_code: params[:promo_code])
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_plan
    @plan = Plan.without_free.find(params[:plan])
  rescue ActiveRecord::RecordNotFound
    redirect_to pricing_path
  end

  def billing_address_params
    params.require(:address).permit(:line1, :line2, :city, :state, :country, :postal_code)
  end
end
