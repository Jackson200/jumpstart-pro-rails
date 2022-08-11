class NotificationChannel < Noticed::NotificationChannel
  # Inherits functionality from Noticed::NotificationChannel
  # https://github.com/excid3/noticed/blob/master/app/channels/noticed/notification_channel.rb
  #
  # def mark_as_read(data) (from Noticed)
  # * Accepts { ids: [1,2,3, ...]

  def mark_as_interacted(data)
    current_user.notifications.where(id: data["ids"]).mark_as_interacted!
  end
end
