class AddUnitToPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :unit, :string
  end
end
