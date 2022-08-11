# == Schema Information
#
# Table name: notifications
#
#  id             :bigint           not null, primary key
#  interacted_at  :datetime
#  params         :jsonb
#  read_at        :datetime
#  recipient_type :string           not null
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :integer          not null
#  recipient_id   :integer          not null
#
# Indexes
#
#  index_notifications_on_account_id                       (account_id)
#  index_notifications_on_recipient_type_and_recipient_id  (recipient_type,recipient_id)
#
require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  setup do
    Notification.delete_all
  end

  test "notifications with user param are destroyed when user destroyed" do
    user = users(:one)
    AcceptedInvite.with(user: user, account: accounts(:one)).deliver(users(:two))

    assert_difference "Notification.count", -1 do
      user.destroy
    end
  end

  test "notifications with account are destroyed when account destroyed" do
    account = accounts(:one)
    AcceptedInvite.with(user: users(:one), account: account).deliver(users(:two))

    assert_difference "Notification.count", -1 do
      account.destroy
    end
  end
end
