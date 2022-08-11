module UserAccounts
  extend ActiveSupport::Concern

  included do
    has_many :account_invitations, dependent: :nullify, foreign_key: :invited_by_id
    has_many :account_users, dependent: :destroy
    has_many :accounts, through: :account_users
    has_many :owned_accounts, class_name: "Account", foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy
    has_one :personal_account, -> { where(personal: true) }, class_name: "Account", foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy

    # Regular users should get their account created immediately
    after_create :create_default_account, unless: :skip_default_account?
    after_update :sync_personal_account_name, if: -> { Jumpstart.config.personal_accounts }

    accepts_nested_attributes_for :owned_accounts, reject_if: :all_blank

    # Used for skipping a default account on create
    attribute :skip_default_account, :boolean, default: false
  end

  def create_default_account
    # Invited users don't have a name immediately, so we will run this method twice for them
    # once on create where no name is present and again on accepting the invitation
    return unless name.present?
    return accounts.first if accounts.any?

    account = accounts.new(owner: self, name: name, personal: Jumpstart.config.personal_accounts)
    account.account_users.new(user: self, admin: true)
    account.save!
    account
  end

  def sync_personal_account_name
    if first_name_previously_changed? || last_name_previously_changed?
      # Accepting an invitation calls this when the user's name is updated
      if personal_account.nil?
        create_default_account
        reload_personal_account
      end

      # Sync the personal account name with the user's name
      personal_account.update(name: name)
    end
  end
end
