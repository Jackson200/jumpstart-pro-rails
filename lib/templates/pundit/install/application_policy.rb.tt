# frozen_string_literal: true

class ApplicationPolicy
  # We use AccountUser for policies because it contains roles for the current account
  # This allows separate roles for each user and account.
  #
  # Defaults:
  # - Allow admins
  # - Deny everyone else

  attr_reader :account_user, :record

  def initialize(account_user, record)
    # Comment out to allow guest users
    raise Pundit::NotAuthorizedError, "must be logged in" unless account_user

    @account_user = account_user
    @record = record
  end

  def index?
    account_user.admin?
  end

  def show?
    account_user.admin?
  end

  def create?
    account_user.admin?
  end

  def new?
    create?
  end

  def update?
    account_user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    account_user.admin?
  end

  class Scope
    def initialize(account_user, scope)
      # Comment out to allow guest users
      raise Pundit::NotAuthorizedError, "must be logged in" unless account_user

      @account_user = account_user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :account_user, :scope
  end
end
