require "test_helper"

class AuthsControllerTest < ActionDispatch::IntegrationTest
  test "returns unauthorized if user not valid" do
    post api_v1_auth_url
    assert_response :unauthorized

    user = users(:one)
    post api_v1_auth_url, params: {email: user.email, password: "invalidpassword"}
    assert_response :unauthorized
  end

  test "returns an api token on successful auth" do
    user = users(:one)
    post api_v1_auth_url, params: {email: user.email, password: "password"}
    assert_response :success
    assert_not_nil response.parsed_body["token"]
  end

  test "creates a new default api token if one didn't exist" do
    user = users(:one)
    assert_difference "user.api_tokens.count" do
      post api_v1_auth_url, params: {email: user.email, password: "password"}
      assert_response :success
    end
    assert_equal user.api_tokens.find_by(name: ApiToken::DEFAULT_NAME).token, response.parsed_body["token"]
  end

  test "creates a new turbo app api token if one didn't exist" do
    user = users(:one)
    assert_difference "user.api_tokens.count" do
      post api_v1_auth_url, params: {email: user.email, password: "password"}, headers: {HTTP_USER_AGENT: "Turbo Native iOS"}
      assert_response :success
    end
    assert_equal user.api_tokens.find_by(name: ApiToken::APP_NAME).token, response.parsed_body["token"]
  end

  test "sets Devise cookie during turbo app login" do
    user = users(:one)
    post api_v1_auth_url, params: {email: user.email, password: "password"}, headers: {HTTP_USER_AGENT: "Turbo Native iOS"}
    assert_response :success

    # Set Devise cookies for Turbo Native apps
    assert_not_nil session["warden.user.user.key"]
  end

  test "returns token during turbo app login" do
    user = users(:one)
    post api_v1_auth_url, params: {email: user.email, password: "password"}, headers: {HTTP_USER_AGENT: "Turbo Native iOS"}
    assert_response :success
    assert_not_nil json_response["token"]
  end

  test "destroys notification tokens on sign out" do
    notification_token = notification_tokens(:ios)
    user = notification_token.user

    assert_difference "NotificationToken.count", -1 do
      delete api_v1_auth_url, params: {notification_token: notification_token.token}, headers: {Authorization: "token #{user.api_tokens.first.token}"}
      assert_response :success
    end
  end
end
