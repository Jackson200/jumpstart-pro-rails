class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :amount, null: false, default: 0
      t.string :interval
      t.jsonb :details, null: false, default: {}

      t.timestamps
    end
  end
end
