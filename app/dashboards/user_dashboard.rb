require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    name: Field::String.with_options(searchable: false),
    email: Field::String,
    password: Field::Password.with_options(searchable: false),
    password_confirmation: Field::Password.with_options(searchable: false),
    accounts: Field::HasMany,
    connected_accounts: Field::HasMany.with_options(class_name: "User::ConnectedAccount"),
    avatar: Field::ActiveStorage,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    confirmation_token: Field::String,
    confirmed_at: Field::DateTime,
    confirmation_sent_at: Field::DateTime,
    unconfirmed_email: Field::String,
    admin: Field::Boolean,
    time_zone: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    invitation_token: Field::String,
    invitation_created_at: Field::DateTime,
    invitation_sent_at: Field::DateTime,
    invitation_accepted_at: Field::DateTime,
    invitation_limit: Field::Number,
    invitations_count: Field::Number,
    terms_of_service: Field::Boolean,
    accepted_terms_at: Field::DateTime,
    accepted_privacy_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :email,
    :accounts,
    :connected_accounts
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :email,
    :accounts,
    :connected_accounts,
    :time_zone,
    :avatar,
    :reset_password_token,
    :reset_password_sent_at,
    :remember_created_at,
    :confirmation_token,
    :confirmed_at,
    :confirmation_sent_at,
    :unconfirmed_email,
    :admin,
    :accepted_terms_at,
    :accepted_privacy_at,
    :created_at,
    :updated_at,
    :invitation_token,
    :invitation_created_at,
    :invitation_sent_at,
    :invitation_accepted_at,
    :invitation_limit,
    :invitations_count
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :email,
    :admin
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    user.email.to_s
  end
end
