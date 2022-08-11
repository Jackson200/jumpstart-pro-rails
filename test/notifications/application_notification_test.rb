require "test_helper"

class ApplicationNotificationTest < ActiveSupport::TestCase
  test "cleans up iOS device tokens" do
    assert_difference "NotificationToken.count", -1 do
      ApplicationNotification.new.cleanup_device_token(
        token: notification_tokens(:ios).token,
        platform: "iOS"
      )
    end
  end

  test "cleans up FCM Android device tokens" do
    assert_difference "NotificationToken.count", -1 do
      ApplicationNotification.new.cleanup_device_token(
        token: notification_tokens(:ios).token,
        platform: "fcm"
      )
    end
  end
end
