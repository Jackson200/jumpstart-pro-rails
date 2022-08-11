# This migration comes from pay (originally 20200603134434)
class AddDataToPayModels < ActiveRecord::Migration[4.2]
  def change
    add_column :pay_subscriptions, :data, Pay::Adapter.json_column_type
    add_column :pay_charges, :data, Pay::Adapter.json_column_type
  end
end
