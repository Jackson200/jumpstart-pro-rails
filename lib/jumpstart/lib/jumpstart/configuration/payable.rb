module Jumpstart
  class Configuration
    module Payable
      attr_writer :payment_processors
      attr_writer :plans
      attr_writer :monthly_plans
      attr_writer :yearly_plans

      def braintree?
        payment_processors.include? :braintree
      end

      def paypal?
        payment_processors.include? :paypal
      end

      def stripe?
        payment_processors.include? :stripe
      end

      def paddle?
        payment_processors.include? :paddle
      end

      def payments_enabled?
        payment_processors.any?
      end

      def payment_processors
        Array.wrap(@payment_processors).map(&:to_sym)
      end

      def plans
        Array.wrap(@plans)
      end

      def monthly_plans
        @monthly_plans ||= filter_plans("month")
      end

      def yearly_plans
        @yearly_plans ||= filter_plans("year")
      end

      private

      def filter_plans(frequency, default = "month")
        plans.select do |plan|
          plan.fetch(frequency, default).present?
        end
      end
    end
  end
end
