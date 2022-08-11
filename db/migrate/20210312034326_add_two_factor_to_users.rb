class AddTwoFactorToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :otp_required_for_login, :boolean
    add_column :users, :otp_secret, :string
    add_column :users, :last_otp_timestep, :integer
    # per discussion, leave as text column for time being and use serialization
    # when Rails 7 is released, encryption for this should be trivial
    add_column :users, :otp_backup_codes, :text
  end
end
