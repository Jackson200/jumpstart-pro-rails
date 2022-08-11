class StaticController < ApplicationController
  def index
  end

  def about
  end

  def pricing
    redirect_to root_path, alert: t(".no_plans") unless Plan.without_free.exists?

    plans = Plan.visible.sorted
    @monthly_plans = plans.select(&:monthly?)
    @yearly_plans = plans.select(&:yearly?)
  end

  def terms
  end

  def privacy
  end
end
