class ApplicationNotification < Noticed::Base
  # Delivery methods and helpers used by all notifications can be defined here.
  deliver_by :database, format: :to_database

  # Include the user's personal account by default, but allow overriding with params
  def to_database
    {
      account: params[:account] || recipient.personal_account,
      type: self.class.name,
      params: params.except(:account)
    }
  end

  # Used for sending notifications to a recipients iOS devices
  def ios_device_tokens(user)
    user.notification_tokens.ios.pluck(:token)
  end

  # Used for sending notifications to a recipients Android devices
  def android_device_tokens(user)
    user.notification_tokens.android.pluck(:token)
  end

  # Remove notification token when a user removes the app from their device
  def cleanup_device_token(token:, platform:)
    NotificationToken.where(token: token, platform: (platform == "fcm" ? "Android" : platform)).destroy_all
  end
end
