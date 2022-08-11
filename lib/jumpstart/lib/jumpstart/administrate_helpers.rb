module Jumpstart
  module AdministrateHelpers
    def charge_processor_url(charge)
      case charge.customer.processor
      when "stripe"
        "#{stripe_base_url}/payments/#{charge.processor_id}"
      when "braintree"
        "#{braintree_base_url}/transactions/#{charge.processor_id}"
      end
    end

    def customer_processor_url(user)
      case user.processor
      when "stripe"
        "#{stripe_base_url}/customers/#{user.processor_id}"
      when "braintree"
        "#{braintree_base_url}/customers/#{user.processor_id}"
      end
    end

    def subscription_processor_url(subscription)
      case subscription.customer.processor
      when "stripe"
        "#{stripe_base_url}/subscriptions/#{subscription.processor_id}"
      when "braintree"
        "#{braintree_base_url}/subscriptions/#{subscription.processor_id}"
      end
    end

    private

    def stripe_base_url
      url = "https://dashboard.stripe.com"
      url += "/test" if Pay::Stripe.public_key.start_with?("pk_test")
      url
    end

    def braintree_base_url
      config = Pay.braintree_gateway.config
      merchant_id = config.merchant_id
      environment = (config.environment.to_s == "sandbox" ? "sandbox" : "www")

      "https://#{environment}.braintreegateway.com/merchants/#{merchant_id}"
    end
  end
end
