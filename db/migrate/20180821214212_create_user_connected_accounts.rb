class CreateUserConnectedAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_connected_accounts do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :encrypted_access_token
      t.string :encrypted_access_token_iv
      t.string :encrypted_access_token_secret
      t.string :encrypted_access_token_secret_iv
      t.string :refresh_token
      t.datetime :expires_at
      t.text :auth

      t.timestamps
    end
  end
end
