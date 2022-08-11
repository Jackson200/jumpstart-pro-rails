module SubscriptionsHelper
  def braintree_env
    Rails.env.production? ? "production" : "sandbox"
  end

  def pricing_cta(plan)
    if plan.trial_period_days?
      t(".start_trial")
    else
      t(".get_started")
    end
  end

  def payment_method_details(object)
    case object.payment_method_type
    when "paypal"
      object.email || "PayPal"
    when "card"
      "#{object.brand.titleize} ending in #{object.last4}"
    end
  end

  def show_payment_processor?(processor_name, plan: nil)
    return unless Jumpstart.config.payment_processors.include?(processor_name)

    # Make sure we have a Plan ID for the payment processor
    return false if plan && !plan.id_for_processor(processor_name).present?

    # If a user has active subscriptions, only let them use that payment processor for new payments
    # Also show if user is on the fake processor (for trial)
    if current_account.subscriptions.active.any? && current_account.payment_processor
      ["fake_processor", processor_name.to_s].include?(current_account.payment_processor.processor)

    # Otherwise show all options
    else
      true
    end
  end

  # Paddle can only update payment method when subscribed
  # Only works with active or paused subscriptions.
  # Cancelled subscriptions are permanent and cannot be updated.
  def show_paddle_payment_method_form?(payment_processor)
    return false unless payment_processor&.paddle?
    (subscription = payment_processor.subscription) && (subscription.active? || subscription.paused?)
  end
end
