class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :account, null: false
      t.belongs_to :recipient, polymorphic: true, null: false
      t.string :type
      t.jsonb :params
      t.datetime :read_at

      t.timestamps
    end
  end
end
