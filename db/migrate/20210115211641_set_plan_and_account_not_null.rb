class SetPlanAndAccountNotNull < ActiveRecord::Migration[6.1]
  def change
    add_check_constraint :plans, "name IS NOT NULL", name: "plans_name_null", validate: false
    add_check_constraint :plans, "interval IS NOT NULL", name: "plans_interval_null", validate: false
    add_check_constraint :accounts, "name IS NOT NULL", name: "accounts_name_null", validate: false
  end
end
