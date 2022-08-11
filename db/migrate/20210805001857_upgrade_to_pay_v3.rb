class UpgradeToPayV3 < ActiveRecord::Migration[6.0]
  # Models to migrate from Pay v2 to Pay v3
  MODELS = [Account]

  def self.up
    Pay::Subscription.where(processor: "jumpstart").update_all(processor: "fake_processor")

    MODELS.each do |klass|
      klass.where.not(processor: nil).find_each do |record|
        # Use the fake processor from Pay instead of the jumpstart placeholder
        record.update(processor: "fake_processor") if record.processor == "jumpstart"

        # Migrate to Pay::Customer
        pay_customer = Pay::Customer.where(owner: record, processor: record.processor, processor_id: record.processor_id).first_or_initialize
        pay_customer.update!(
          default: true,
          data: {
            stripe_account: record.try(:stripe_account),
            braintree_account: record.try(:braintree_account)
          }
        )
      end

      # Migrate generic trials
      # Anyone on a generic trial gets a fake processor subscription with the same end timestamp
      klass.where("trial_ends_at >= ?", Time.current).find_each do |record|
        # Make sure we don't have any conflicts when setting fake processor as the default
        Pay::Customer.where(owner: record, default: true).update_all(default: false)

        pay_customer = Pay::Customer.where(owner: record, processor: :fake_processor, default: true).first_or_create!
        pay_customer.subscribe(
          trial_ends_at: record.trial_ends_at,
          ends_at: record.trial_ends_at,

          # Appease the null: false on processor before we remove columns
          processor: :fake_processor
        )
      end
    end

    # Associate Pay::Charges with new Pay::Customer
    Pay::Charge.find_each do |charge|
      # Since customers can switch between payment processors, we have to find or create
      owner = charge.owner_type&.constantize&.find_by(id: charge.owner_id)
      unless owner
        Rails.logger.info "Skipping orphaned Pay::Charge ##{charge.id}"
        next
      end

      customer = Pay::Customer.where(owner: owner, processor: charge.processor).first_or_create!

      # Data column should be a hash. If we find a string instead, replace it
      charge.data = {} if charge.data.is_a?(String)

      case charge.card_type.downcase
      when "paypal"
        charge.update!(customer: customer, payment_method_type: :paypal, brand: "PayPal", email: charge.card_last4)
      else
        charge.update!(customer: customer, payment_method_type: :card, brand: charge.card_type, last4: charge.card_last4, exp_month: charge.card_exp_month, exp_year: charge.card_exp_year)
      end
    end

    # Associate Pay::Subscriptions with new Pay::Customer
    Pay::Subscription.find_each.each do |subscription|
      # Since customers can switch between payment processors, we have to find or create
      owner = subscription.owner_type&.constantize&.find_by(id: subscription.owner_id)
      unless owner
        Rails.logger.info "Skipping orphaned Pay::Subscription ##{subscription.id}"
        next
      end

      # Use the fake processor from Pay instead of the jumpstart placeholder
      subscription.processor = "fake_processor" if subscription.processor == "jumpstart"
      customer = Pay::Customer.where(owner: owner, processor: subscription.processor).first_or_create!

      # Data column should be a hash. If we find a string instead, replace it
      subscription.data = {} if subscription.data.is_a?(String)
      subscription.update!(customer: customer)
    end

    # Drop unneeded columns
    remove_column :pay_charges, :owner_type
    remove_column :pay_charges, :owner_id
    remove_column :pay_charges, :processor
    remove_column :pay_charges, :card_type
    remove_column :pay_charges, :card_last4
    remove_column :pay_charges, :card_exp_month
    remove_column :pay_charges, :card_exp_year
    remove_column :pay_subscriptions, :owner_type
    remove_column :pay_subscriptions, :owner_id
    remove_column :pay_subscriptions, :processor

    MODELS.each do |klass|
      remove_column klass.table_name, :processor
      remove_column klass.table_name, :processor_id
      remove_column klass.table_name, :pay_data, if_exists: true
      remove_column klass.table_name, :card_type
      remove_column klass.table_name, :card_last4
      remove_column klass.table_name, :card_exp_month
      remove_column klass.table_name, :card_exp_year
      remove_column klass.table_name, :trial_ends_at
    end
  end

  def self.down
    add_column :pay_charges, :owner_type, :string
    add_column :pay_charges, :owner_id, :integer
    add_column :pay_charges, :processor, :string
    add_column :pay_subscriptions, :owner_type, :string
    add_column :pay_subscriptions, :owner_id, :integer
    add_column :pay_subscriptions, :processor, :string

    MODELS.each do |klass|
      add_column klass.table_name, :processor, :string
      add_column klass.table_name, :processor_id, :string
      add_column klass.table_name, :pay_data, Pay::Adapter.json_column_type
      add_column klass.table_name, :card_type, :string
      add_column klass.table_name, :card_last4, :string
      add_column klass.table_name, :card_exp_month, :string
      add_column klass.table_name, :card_exp_year, :string
      add_column klass.table_name, :trial_ends_at, :datetime
    end
  end
end
