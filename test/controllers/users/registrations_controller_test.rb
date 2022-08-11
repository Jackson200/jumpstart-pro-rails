require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include InvisibleCaptcha

  setup do
    @user_params = {user:
                        {name: "Test User",
                         email: "user@test.com",
                         password: "TestPassword",
                         terms_of_service: "1"}}

    # With this feature enabled, we also need to submit an account
    if Jumpstart.config.register_with_account?
      @user_params[:user][:owned_accounts_attributes] = [{name: "Test Account"}]
    end
  end

  class BasicRegistrationTest < Users::RegistrationsControllerTest
    test "successfully registration form render" do
      get new_user_registration_path
      assert_response :success
      assert response.body.include?("user[name]")
      assert response.body.include?("user[email]")
      assert response.body.include?("user[password]")
      assert response.body.include?(InvisibleCaptcha.sentence_for_humans)
    end

    test "successful user registration" do
      assert_difference "User.count" do
        post user_registration_url, params: @user_params
      end
    end

    test "failed user registration" do
      assert_no_difference "User.count" do
        post user_registration_url, params: {}
      end
    end
  end

  class InvibleCaptchaTest < Users::RegistrationsControllerTest
    test "honeypot is not filled and user creation succeeds" do
      assert_difference "User.count" do
        post user_registration_url, params: @user_params.merge(honeypotx: "")
      end
    end

    test "honeypot is filled and user creation fails" do
      assert_no_difference "User.count" do
        post user_registration_url, params: @user_params.merge(honeypotx: "spam")
      end
    end
  end

  class RegisterWithAccountTest < Users::RegistrationsControllerTest
    test "doesn't prompt for account details on sign up if disabled" do
      Jumpstart.config.stub(:register_with_account?, false) do
        get new_user_registration_path
        assert_no_match I18n.t("helpers.label.account.name"), response.body
      end
    end

    test "prompts for account details on sign up if enabled" do
      Jumpstart.config.stub(:register_with_account?, true) do
        get new_user_registration_path
        assert_select "label", text: I18n.t("helpers.label.account.name")
      end
    end
  end
end
