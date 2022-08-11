require "test_helper"

class CurrentHelperTest < ActionView::TestCase
  attr_reader :current_user

  setup do
    @current_user = users(:one)
    Current.user = @current_user
    Current.account = accounts(:one)
  end

  test "delegates to Current" do
    assert_not_nil current_account
  end

  test "current_account_user" do
    assert_not_nil current_account_user
  end

  test "current_account_admin? returns true for an admin" do
    account_user = account_users(:two)
    @current_user = account_user.user
    Current.user = account_user.user
    Current.account = account_user.account

    assert_equal account_user, current_account_user
    assert current_account_admin?
  end

  test "current_account_admin? returns false for a non admin" do
    account_user = account_users(:company_regular_user)
    @current_user = account_user.user
    Current.user = account_user.user
    Current.account = account_user.account

    assert_not current_account_admin?
  end

  test "current account member is from current account" do
    account_user = Current.user.account_users.last
    Current.account = account_user.account
    assert_equal account_user, current_account_user
  end

  test "current_roles" do
    Current.account = accounts(:company)
    assert_equal [:admin], current_roles
  end
end
