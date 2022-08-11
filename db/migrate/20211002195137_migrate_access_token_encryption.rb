class MigrateAccessTokenEncryption < ActiveRecord::Migration[7.0]
  def self.up
    add_column :user_connected_accounts, :access_token, :string
    add_column :user_connected_accounts, :access_token_secret, :string

    User::ConnectedAccount.reset_column_information

    User::ConnectedAccount.find_each do |user|
      migrate_access_token(user)
    end

    remove_column :user_connected_accounts, :encrypted_access_token
    remove_column :user_connected_accounts, :encrypted_access_token_iv
    remove_column :user_connected_accounts, :encrypted_access_token_secret
    remove_column :user_connected_accounts, :encrypted_access_token_secret_iv
  end

  def self.down
    add_column :user_connected_accounts, :encrypted_access_token
    add_column :user_connected_accounts, :encrypted_access_token_iv
    add_column :user_connected_accounts, :encrypted_access_token_secret
    add_column :user_connected_accounts, :encrypted_access_token_secret_iv

    remove_column :user_connected_accounts, :access_token, :string
    remove_column :user_connected_accounts, :access_token_secret, :string
  end

  private

  def migrate_access_token(user)
    user.update!(
      access_token: decrypt_field(:encrypted_access_token, user),
      access_token_secret: decrypt_field(:encrypted_access_token_secret, user)
    )
  end

  def decrypt_field(name, account)
    # Skip if empty value
    return unless account.send(:"#{name}?")

    key = Base64.decode64 Rails.application.credentials.access_token_encryption_key
    value = Base64.decode64 account.send(name)
    iv = Base64.decode64 account.send(:"#{name}_iv")

    cipher = OpenSSL::Cipher.new("aes-256-gcm")
    cipher.decrypt
    cipher.iv = iv
    cipher.key = key

    cipher.auth_tag = value[-16..]
    cipher.auth_data = ""

    cipher.update(value[0..-17]) + cipher.final
  end
end
