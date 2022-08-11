# == Schema Information
#
# Table name: user_connected_accounts
#
#  id                  :bigint           not null, primary key
#  access_token        :string
#  access_token_secret :string
#  auth                :text
#  expires_at          :datetime
#  provider            :string
#  refresh_token       :string
#  uid                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint
#
# Indexes
#
#  index_user_connected_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require "test_helper"

class User::ConnectedAccountTest < ActiveSupport::TestCase
  test "handles access token secrets" do
    ca = User::ConnectedAccount.new(access_token_secret: "test")
    assert_equal "test", ca.access_token_secret
  end

  test "handles empty access token secrets" do
    assert_nothing_raised do
      User::ConnectedAccount.new(access_token_secret: "")
    end
  end

  test "expired if token expired in the past" do
    ca = User::ConnectedAccount.new(expires_at: 1.hour.ago)
    assert ca.expired?
  end

  test "expiring if token expires soon" do
    ca = User::ConnectedAccount.new(expires_at: 4.minutes.from_now)
    assert ca.expired?
  end

  test "not expiring if token expires in the future" do
    ca = User::ConnectedAccount.new(expires_at: 1.day.from_now)
    assert_not ca.expired?
  end

  test "not expiring if token has no expiration" do
    ca = User::ConnectedAccount.new(expires_at: nil)
    assert_not ca.expired?
  end
end
