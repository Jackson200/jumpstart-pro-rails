class AddOwnerTypeToPayModels < ActiveRecord::Migration[6.0]
  def change
    add_column :pay_charges, :owner_type, :string
    add_column :pay_subscriptions, :owner_type, :string

    Pay::Charge.update_all owner_type: "Account"
    Pay::Subscription.update_all owner_type: "Account"
  end
end
