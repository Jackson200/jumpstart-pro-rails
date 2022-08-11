Pay.setup do |config|
  config.application_name = Jumpstart.config.application_name
  config.business_name = Jumpstart.config.business_name
  config.business_address = Jumpstart.config.business_address
  config.support_email = Jumpstart.config.support_email

  config.routes_path = "/"
end

module SubscriptionExtensions
  extend ActiveSupport::Concern

  included do
    # Generates hash IDs with a friendly prefix so users can't guess hidden plan IDs on checkout
    # https://github.com/excid3/prefixed_ids
    has_prefix_id :sub
  end

  def plan
    @plan ||= Plan.where("details @> ?", {"#{customer.processor}_id": processor_plan}.to_json).first
  end

  def plan_interval
    plan.interval
  end

  def amount_with_currency(**options)
    total = quantity == 0 ? plan.amount : plan.amount * quantity
    Pay::Currency.format(total, **{currency: plan.currency}.merge(options))
  end
end

module ChargeExtensions
  extend ActiveSupport::Concern

  included do
    # Generates hash IDs with a friendly prefix so users can't guess hidden plan IDs on checkout
    # https://github.com/excid3/prefixed_ids
    has_prefix_id :ch
  end
end

Rails.configuration.to_prepare do
  Pay::Subscription.include SubscriptionExtensions
  Pay::Charge.include ChargeExtensions
end
