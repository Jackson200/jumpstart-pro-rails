require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "returns errors if invalid params submitted" do
    post api_v1_users_url, params: {}
    assert_response :unprocessable_entity
    assert response.parsed_body["errors"]
    assert_equal ["can't be blank"], response.parsed_body["errors"]["email"]
  end

  test "returns user and api token on success" do
    email = "api-user@example.com"

    Jumpstart.config.stub(:register_with_account?, false) do
      assert_difference "User.count" do
        post api_v1_users_url, params: {user: {email: email, name: "API User", password: "password", password_confirmation: "password", terms_of_service: "1"}}
        assert_response :success
      end
    end

    assert response.parsed_body["user"]
    assert_equal email, response.parsed_body.dig("user", "email")
    assert_not_nil response.parsed_body.dig("user", "api_tokens").first["token"]
  end

  test "turbo native registration" do
    Jumpstart.config.stub(:personal_accounts, true) do #### HERE ####
      Jumpstart.config.stub(:register_with_account?, false) do #### HERE ####
        assert_difference "User.count" do
          post api_v1_users_url, params: {user: {email: "api-user@example.com", name: "API User", password: "password", password_confirmation: "password", terms_of_service: "1"}}, headers: {HTTP_USER_AGENT: "Turbo Native iOS"}
          assert_response :success
        end
      end
    end

    user = User.last

    # Account name should match user's name
    assert_equal "API User", user.personal_account.name

    # Set Devise cookies for Turbo Native apps
    assert_not_nil session["warden.user.user.key"]

    # Returns an API token
    assert_equal user.api_tokens.find_by(name: ApiToken::APP_NAME).token, response.parsed_body["token"]
  end

  test "registration with account" do
    Jumpstart.config.stub(:register_with_account?, true) do
      assert_difference "Account.count" do
        post api_v1_users_url, params: {user: {email: "api-user@example.com", name: "API User", password: "password", password_confirmation: "password", terms_of_service: "1", owned_accounts_attributes: [{name: "Test Account"}]}}, headers: {HTTP_USER_AGENT: "Turbo Native iOS"}
        assert_response :success
      end

      user = User.last
      # Should not have created a personal account
      assert_nil user.personal_account
      # Account should use name from request
      assert_equal "Test Account", user.accounts.last.name
      # User should be an admin on their account
      assert user.account_users.last.admin
    end
  end
end
