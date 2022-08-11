# == Schema Information
#
# Table name: notification_tokens
#
#  id         :bigint           not null, primary key
#  platform   :string           not null
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_notification_tokens_on_user_id  (user_id)
#
require "test_helper"

class NotificationTokenTest < ActiveSupport::TestCase
  test "ios" do
    assert_includes NotificationToken.ios, notification_tokens(:ios)
  end

  test "android" do
    assert_includes NotificationToken.android, notification_tokens(:android)
  end
end
