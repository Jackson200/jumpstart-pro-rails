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
class Notification < ApplicationRecord
  include Noticed::Model

  belongs_to :account

  def self.mark_as_interacted!
    update(interacted_at: Time.current, updated_at: Time.current)
  end

  def mark_as_interacted!
    update(interacted_at: Time.current)
  end
end
