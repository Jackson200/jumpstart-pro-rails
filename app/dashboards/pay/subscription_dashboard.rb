require "administrate/base_dashboard"

class Pay::SubscriptionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    customer: Field::BelongsTo.with_options(class_name: "Pay::Customer"),
    name: Field::String,
    processor_id: Field::String,
    processor_plan: Field::String,
    quantity: Field::Number,
    trial_ends_at: Field::DateTime,
    ends_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    status: Field::String,
    prorate: Field::Boolean,
    active?: Field::Boolean,
    cancelled?: Field::Boolean
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :customer,
    :name,
    :status,
    :active?,
    :cancelled?
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :customer,
    :active?,
    :name,
    :processor_id,
    :processor_plan,
    :quantity,
    :status,
    :trial_ends_at,
    :ends_at,
    :created_at,
    :updated_at,
    :prorate
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :customer,
    :name,
    :processor_id,
    :processor_plan,
    :quantity,
    :trial_ends_at,
    :ends_at,
    :prorate
  ].freeze

  # Overwrite this method to customize how subscriptions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(subscription)
  #   "Pay::Subscription ##{subscription.id}"
  # end
end
