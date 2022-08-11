module NotificationsHelper
  def unread_notifications?
    @notifications.any? { |n| n.read_at.nil? }
  end
end
