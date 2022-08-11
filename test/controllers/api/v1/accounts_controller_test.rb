require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "returns current user accounts" do
    user = users(:one)
    get api_v1_accounts_url, headers: {Authorization: "token #{user.api_tokens.first.token}"}
    assert_response :success
    assert_includes response.parsed_body.map { |t| t["name"] }, user.accounts.first.name
  end
end
