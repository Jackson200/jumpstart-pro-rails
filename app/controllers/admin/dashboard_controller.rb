module Admin
  class DashboardController < Admin::ApplicationController
    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
    def show
      @total_revenue = total_revenue
      @last_12_mos = last_12_mos
      @last_month = last_month
      @this_month = this_month
      @users = ::User.all.count
      @subscriptions = ::Pay::Subscription.active.count
    end

    def total_revenue
      revenue_in_cents = ::Pay::Charge.sum(:amount)
      refunds_in_cents = ::Pay::Charge.sum(:amount_refunded)
      (revenue_in_cents - refunds_in_cents) / 100.0
    end

    def last_12_mos
      revenue_for_range 12.months.ago..Time.current
    end

    def last_month
      month = Time.current.prev_month
      revenue_for_range month.beginning_of_month..month.end_of_month
    end

    def this_month
      month = Time.current
      revenue_for_range month.beginning_of_month..month.end_of_month
    end

    def revenue_for_range(range)
      revenue_in_cents = ::Pay::Charge.where(created_at: range).sum(:amount)
      refunds_in_cents = ::Pay::Charge.where(created_at: range).sum(:amount_refunded)
      (revenue_in_cents - refunds_in_cents) / 100.0
    end
  end
end
