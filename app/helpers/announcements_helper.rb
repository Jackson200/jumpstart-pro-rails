module AnnouncementsHelper
  # Use the explicit class names so purgecss can find them
  def announcement_color(announcement)
    case announcement.kind
    when "new"
      "announcement-new"
    when "update"
      "announcement-update"
    when "improvement"
      "announcement-improvement"
    when "fix"
      "announcement-fix"
    else
      "announcement-update"
    end
  end

  def unread_announcements_class(user)
    announcement = Announcement.order(published_at: :desc).first
    return if announcement.nil?

    # Highlight announcements for anyone not logged in, cuz tempting
    if user.nil? || user.announcements_read_at.nil? ||
        user.announcements_read_at < announcement.published_at
      "unread-announcements"
    end
  end
end
