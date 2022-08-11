class BillingAddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_account
  before_action :set_billing_address, only: [:edit, :update, :destroy]

  def new
    @billing_address = current_account.build_billing_address
  end

  def create
    @billing_address = current_account.build_billing_address(billing_address_params)

    if @billing_address.save
      redirect_to subscriptions_path, notice: t("subscriptions.billing_address.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @billing_address.update(billing_address_params)
      redirect_to subscriptions_path, notice: t("subscriptions.billing_address.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @billing_address.destroy
    redirect_to subscriptions_path, status: :see_other, notice: t("subscriptions.billing_address.destroyed")
  end

  private

  def billing_address_params
    params.require(:address).permit(:line1, :line2, :city, :state, :country, :postal_code)
  end

  def set_billing_address
    @billing_address = current_account.billing_address
  end
end
