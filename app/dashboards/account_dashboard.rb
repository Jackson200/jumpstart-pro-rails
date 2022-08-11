require "administrate/base_dashboard"

class AccountDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    owner: Field::BelongsTo.with_options(class_name: "User"),
    pay_customers: Field::HasMany.with_options(class_name: "Pay::Customer"),
    charges: Field::HasMany.with_options(class_name: "Pay::Charge"),
    subscriptions: Field::HasMany.with_options(class_name: "Pay::Subscription"),
    account_users: Field::HasMany,
    users: Field::HasMany,
    avatar: Field::ActiveStorage,
    id: Field::Number,
    name: Field::String,
    personal: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    extra_billing_info: Field::Text
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :owner,
    :name,
    :personal,
    :account_users
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :owner,
    :pay_customers,
    :charges,
    :subscriptions,
    :account_users,
    :users,
    :avatar,
    :name,
    :personal,
    :created_at,
    :updated_at,
    :extra_billing_info
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :owner,
    :name,
    :personal,
    :extra_billing_info
  ].freeze

  # Overwrite this method to customize how accounts are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(account)
    account.name.to_s
  end
end
