require "test_helper"

class Jumpstart::AdminTest < ActionDispatch::IntegrationTest
  test "cannot access /admin logged out" do
    assert_raises ActionController::RoutingError do
      get "/admin"
    end
  end

  test "cannot access /admin as regular user" do
    assert_raises ActionController::RoutingError do
      sign_in users(:one)
      get "/admin"
    end
  end

  test "can access /admin as admin user" do
    sign_in users(:admin)
    get "/admin"
    assert_response :success
  end
end
