# This migration comes from pay (originally 20170503131610)
class AddFieldsToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :processor, :string
    add_column :accounts, :processor_id, :string
    add_column :accounts, :trial_ends_at, :datetime
    add_column :accounts, :card_type, :string
    add_column :accounts, :card_last4, :string
    add_column :accounts, :card_exp_month, :string
    add_column :accounts, :card_exp_year, :string
    add_column :accounts, :extra_billing_info, :text
  end
end
