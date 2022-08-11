class Account::OwnershipNotification < ApplicationNotification
  deliver_by :action_cable, format: :to_websocket, channel: "NotificationChannel"

  # Name of the previous owner. We only use the name in case the user gets deleted.
  params :previous_owner

  # Account being transferred
  params :account

  def to_websocket
    {
      html: ApplicationController.render(partial: "notifications/notification", locals: {notification: record})
    }
  end

  def message
    t "notifications.account_transferred", previous_owner: params[:previous_owner], account: record.account.name
  end

  def url
    account_path(record.account)
  end

  def user
    params[:user]
  end
end
