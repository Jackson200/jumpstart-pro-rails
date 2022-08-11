# == Schema Information
#
# Table name: api_tokens
#
#  id           :bigint           not null, primary key
#  expires_at   :datetime
#  last_used_at :datetime
#  metadata     :jsonb
#  name         :string
#  token        :string
#  transient    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_api_tokens_on_token    (token) UNIQUE
#  index_api_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class ApiToken < ApplicationRecord
  DEFAULT_NAME = I18n.t("api_tokens.default")
  APP_NAME = I18n.t("api_tokens.app")

  belongs_to :user

  scope :sorted, -> { order("last_used_at DESC NULLS LAST, created_at DESC") }

  has_secure_token :token

  validates :name, presence: true

  def can?(permission)
    Array.wrap(data("permissions")).include?(permission)
  end

  def cant?(permission)
    !can?(permission)
  end

  def data(key, default: nil)
    (metadata || {}).fetch(key, default)
  end

  def expired?
    expires_at? && Time.current >= expires_at
  end

  def touch_last_used_at
    return if transient?
    update(last_used_at: Time.current)
  end

  def generate_token
    loop do
      self.token = SecureRandom.hex(16)
      break unless ApiToken.where(token: token).exists?
    end
  end
end
