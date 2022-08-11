class ValidatePlanAndAccountNotNull < ActiveRecord::Migration[6.1]
  def change
    validate_check_constraint :plans, name: "plans_name_null"
    validate_check_constraint :plans, name: "plans_interval_null"
    validate_check_constraint :accounts, name: "accounts_name_null"

    # in Postgres 12+, you can then safely set NOT NULL on the column
    change_column_null :plans, :name, false
    change_column_null :plans, :interval, false
    change_column_null :accounts, :name, false
    remove_check_constraint :plans, name: "plans_name_null"
    remove_check_constraint :plans, name: "plans_interval_null"
    remove_check_constraint :accounts, name: "accounts_name_null"
  end
end
