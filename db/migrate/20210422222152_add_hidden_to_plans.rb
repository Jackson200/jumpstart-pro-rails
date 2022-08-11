class AddHiddenToPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :hidden, :boolean
  end
end
