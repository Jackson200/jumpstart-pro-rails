# == Schema Information
#
# Table name: account_users
#
#  id         :bigint           not null, primary key
#  roles      :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#  user_id    :integer
#
# Indexes
#
#  index_account_users_on_account_id  (account_id)
#  index_account_users_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#

class AccountUser < ApplicationRecord
  # Add account roles to this line
  # Do NOT to use any reserved words like `user` or `account`
  ROLES = [:admin, :member]

  belongs_to :account
  belongs_to :user

  validates :user_id, uniqueness: {scope: :account_id}
  validate :owner_must_be_admin, on: :update, if: -> { admin_changed? && account_owner? }

  # Store the roles in the roles json column and cast to booleans
  store_accessor :roles, *ROLES

  # Cast roles to/from booleans
  ROLES.each do |role|
    scope role, -> { where("roles @> ?", {role => true}.to_json) }

    define_method(:"#{role}=") { |value| super ActiveRecord::Type::Boolean.new.cast(value) }
    define_method(:"#{role}?") { send(role) }
  end

  # You can use Postgres' jsonb operators to query the roles jsonb column
  # https://www.postgresql.org/docs/current/functions-json.html
  #
  # Query where roles contains:
  # scope :managers, -> { where("roles @> ?", {manager: true}.to_json) }

  def active_roles
    ROLES.select { |role| send(:"#{role}?") }.compact
  end

  def account_owner?
    account.owner_id == user_id
  end

  def owner_must_be_admin
    unless admin?
      errors.add :admin, :cannot_be_removed
    end
  end
end
