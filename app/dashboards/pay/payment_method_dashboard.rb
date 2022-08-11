require "administrate/base_dashboard"

class Pay::PaymentMethodDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    customer: Field::BelongsTo.with_options(class_name: "Pay::Customer"),
    processor_id: Field::String,
    type: Field::String,
    default: Field::Boolean,
    data: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :customer,
    :processor_id,
    :type,
    :default
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :customer,
    :processor_id,
    :default,
    :data,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :customer,
    :processor_id,
    :type,
    :default,
    :data
  ].freeze

  # Overwrite this method to customize how customers are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(payment_method)
  #   "Pay::PaymentMethod ##{payment_method.id}"
  # end
end
