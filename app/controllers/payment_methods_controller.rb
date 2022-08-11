class PaymentMethodsController < ApplicationController
  include SubscriptionsHelper

  before_action :authenticate_user!
  before_action :set_payment_processor
  before_action :set_setup_intent, only: [:new], if: -> { Jumpstart.config.stripe? }

  def new
  end

  def create
    payment_processor = current_account.set_payment_processor(params[:processor])
    payment_processor.update_payment_method(params[:payment_method_token])
    redirect_to subscriptions_path, notice: t(".updated")
  end

  private

  def set_payment_processor
    @payment_processor = current_account.payment_processor
  end

  def set_setup_intent
    # User may not be using Stripe currently, so we have to check their payment processor
    return unless show_payment_processor?(:stripe)

    payment_processor = current_account.add_payment_processor(:stripe)
    @client_secret = payment_processor.create_setup_intent.client_secret
  end
end
