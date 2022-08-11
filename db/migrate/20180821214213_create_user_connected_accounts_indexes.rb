class CreateUserConnectedAccountsIndexes < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :user_connected_accounts, :encrypted_access_token_iv, unique: true, algorithm: :concurrently, name: :index_connected_accounts_access_token_iv
    add_index :user_connected_accounts, :encrypted_access_token_secret_iv, unique: true, algorithm: :concurrently, name: :index_connected_accounts_access_token_secret_iv
  end
end
