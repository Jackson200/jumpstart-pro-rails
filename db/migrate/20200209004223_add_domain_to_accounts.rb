class AddDomainToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :domain, :string
    add_column :accounts, :subdomain, :string
  end
end
