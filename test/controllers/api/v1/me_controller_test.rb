require "test_helper"

class MeControllerTest < ActionDispatch::IntegrationTest
  test "returns current user details" do
    user = users(:one)

    get api_v1_me_url, headers: {Authorization: "token #{user.api_tokens.first.token}"}
    assert_response :success

    assert_equal user.name, response.parsed_body["name"]
  end
end
