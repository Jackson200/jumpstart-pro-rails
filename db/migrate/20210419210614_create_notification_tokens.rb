class CreateNotificationTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :notification_tokens do |t|
      t.belongs_to :user
      t.string :token, null: false
      t.string :platform, null: false
      t.timestamps
    end
  end
end
