class PaymentMethods::StripeController < ApplicationController
  before_action :authenticate_user!
  before_action :set_setup_intent

  def show
    if @setup_intent.status == "succeeded"
      pay_payment_method = Pay::Stripe::PaymentMethod.sync(@setup_intent.payment_method)
      pay_payment_method.make_default!
      redirect_to root_path, notice: t("payment_methods.create.updated")
    else
      redirect_to root_path, alert: t("something_went_wrong")
    end
  end

  private

  def set_setup_intent
    @setup_intent = ::Stripe::SetupIntent.retrieve(params[:setup_intent])
  end
end
