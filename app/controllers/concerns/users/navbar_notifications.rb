module Users
  module NavbarNotifications
    extend ActiveSupport::Concern

    included do
      before_action :set_notifications, if: :user_signed_in?
    end

    def set_notifications
      # Counts to send to native apps
      @account_unread = current_user.notifications.unread.where(account: current_account).count
      @total_unread = current_user.notifications.unread.where(account: [nil, current_account]).count
    end
  end
end
