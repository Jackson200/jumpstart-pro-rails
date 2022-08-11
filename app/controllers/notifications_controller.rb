class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:show]
  after_action :mark_as_read, only: [:index]

  def index
    @pagy, @notifications = pagy(current_user.notifications.where(account: current_account).newest_first, items: (turbo_frame_request? ? 10 : 25))
    render :nav if turbo_frame_request?
  end

  def show
    @notification.mark_as_interacted!
    redirect_to @notification.to_notification.url
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to notifications_path
  end

  def mark_as_read
    @notifications.mark_as_read!
  end
end
