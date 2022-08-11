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
class NotificationToken < ApplicationRecord
  # Tokens for sending push notifications to mobile devices

  belongs_to :user
  validates :token, presence: true
  validates :platform, presence: true, inclusion: {in: %w[iOS Android]}

  scope :android, -> { where(platform: "Android") }
  scope :ios, -> { where(platform: "iOS") }
end
