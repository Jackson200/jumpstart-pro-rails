require "test_helper"

class Jumpstart::AccountsTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:company)
    @admin = users(:one)
    @regular_user = users(:two)
  end

  class AdminUsers < Jumpstart::AccountsTest
    setup do
      sign_in @admin
    end

    test "can edit account" do
      get edit_account_path(@account)
      assert_response :success
      assert_select "button", "Update Account"
    end

    test "can update account" do
      put account_path(@account), params: {account: {name: "Test Account 2"}}
      assert_redirected_to account_path(@account)
      follow_redirect!
      assert_select "h1", "Test Account 2"
    end

    test "can delete account" do
      assert_difference "Account.count", -1 do
        delete account_path(@account)
      end
      assert_redirected_to accounts_path
      assert_equal flash[:notice], I18n.t("accounts.destroyed")
    end

    test "cannot delete personal account" do
      account = @admin.personal_account
      assert_no_difference "Account.count" do
        delete account_path(account)
      end
      assert_equal flash[:alert], I18n.t("accounts.personal.cannot_delete")
    end
  end

  class RegularUsers < Jumpstart::AccountsTest
    setup do
      sign_in @regular_user
    end

    test "cannot edit account" do
      get edit_account_path(@account)
      assert_redirected_to account_path(@account)
    end

    test "cannot update account" do
      name = @account.name
      put account_path(@account), params: {account: {name: "Test Account Changed"}}
      assert_redirected_to account_path(@account)
      follow_redirect!
      assert_select "h1", name
    end

    test "cannot delete account" do
      assert_no_difference "Account.count" do
        delete account_path(@account)
      end
      assert_redirected_to account_path(@account)
    end
  end
end
