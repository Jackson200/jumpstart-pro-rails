require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "should get index" do
    get notifications_url
    assert_response :success
  end

  test "should redirect to index if notification missing" do
    get notification_url(111111)
    assert_response :redirect
    assert_redirected_to notifications_url
  end
end
