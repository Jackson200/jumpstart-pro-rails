require "test_helper"

class Jumpstart::AccountsAccountInvitationsTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:company)
    @admin = users(:one)
    @regular_user = users(:two)
  end

  class AdminUsers < Jumpstart::AccountsAccountInvitationsTest
    setup do
      sign_in @admin
    end

    test "can view invite form" do
      get new_account_account_invitation_path(@account)
      assert_response :success
    end

    test "can invite account members" do
      name, email = "Account Member", "new-member@example.com"
      assert_difference "@account.account_invitations.count" do
        post account_account_invitations_path(@account), params: {account_invitation: {name: name, email: email, admin: "0"}}
      end
      assert_not @account.account_invitations.last.admin?
    end

    test "can invite account members with roles" do
      name, email = "Account Member", "new-member@example.com"
      assert_difference "@account.account_invitations.count" do
        post account_account_invitations_path(@account), params: {account_invitation: {name: name, email: email, admin: "1"}}
      end
      assert @account.account_invitations.last.admin?
    end

    test "can cancel invitation" do
      assert_difference "@account.account_invitations.count", -1 do
        delete account_account_invitation_path(@account, @account.account_invitations.last)
      end
    end
  end

  class RegularUsers < Jumpstart::AccountsAccountInvitationsTest
    setup do
      sign_in @regular_user
    end

    test "cannot view invite form" do
      get new_account_account_invitation_path(@account)
      assert_response :redirect
    end

    test "cannot invite account members" do
      assert_no_difference "@account.account_invitations.count" do
        post account_account_invitations_path(@account), params: {account_invitation: {name: "test", email: "new-member@example.com", admin: "0"}}
      end
    end

    test "can cancel invitation" do
      assert_no_difference "@account.account_invitations.count" do
        delete account_account_invitation_path(@account, @account.account_invitations.last)
      end
    end
  end
end
