class CreateAccountUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :account_users do |t|
      t.belongs_to :account, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.jsonb :roles, null: false, default: {}

      t.timestamps
    end
  end
end
