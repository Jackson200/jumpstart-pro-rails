class AddTrialPeriodDaysToPlans < ActiveRecord::Migration[6.0]
  def self.up
    add_column :plans, :trial_period_days, :integer
    change_column_default :plans, :trial_period_days, 0
  end

  def self.down
    remove_column :plans, :trial_period_days
  end
end
