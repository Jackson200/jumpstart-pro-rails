require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "returns unauthorized if user not valid" do
    patch api_v1_password_url
    assert_response :unauthorized
  end

  test "changes password on success" do
    user = users(:one)
    patch api_v1_password_url, params: {user: {current_password: "password", password: "new_password", password_confirmation: "new_password"}}, headers: {Authorization: "token #{user.api_tokens.first.token}"}
    assert_response :success
    user.reload
    assert user.valid_password?("new_password")
  end

  test "errors if current password doesn't match" do
    user = users(:one)
    patch api_v1_password_url, params: {user: {current_password: "wrong_password", password: "new_password", password_confirmation: "new_password"}}, headers: {Authorization: "token #{user.api_tokens.first.token}"}
    assert_response :unprocessable_entity
    assert_not_nil json_response.dig("error")
  end

  test "errors if password confirmation doesn't match" do
    user = users(:one)
    patch api_v1_password_url, params: {user: {current_password: "password", password: "new_password", password_confirmation: "wrong_password"}}, headers: {Authorization: "token #{user.api_tokens.first.token}"}
    assert_response :unprocessable_entity
    assert_not_nil json_response.dig("error")
  end
end
