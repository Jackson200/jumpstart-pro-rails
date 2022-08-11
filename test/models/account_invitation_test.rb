# == Schema Information
#
# Table name: account_invitations
#
#  id            :bigint           not null, primary key
#  email         :string           not null
#  name          :string           not null
#  roles         :jsonb            not null
#  token         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :integer          not null
#  invited_by_id :integer
#
# Indexes
#
#  index_account_invitations_on_account_id     (account_id)
#  index_account_invitations_on_invited_by_id  (invited_by_id)
#  index_account_invitations_on_token          (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (invited_by_id => users.id)
#
require "test_helper"

class AccountInvitationTest < ActiveSupport::TestCase
  setup do
    @account_invitation = account_invitations(:one)
    @account = @account_invitation.account
  end

  test "cannot invite same email twice" do
    invitation = @account.account_invitations.create(name: "whatever", email: @account_invitation.email)
    assert_not invitation.valid?
  end

  test "accept" do
    user = users(:invited)
    assert_difference "AccountUser.count" do
      account_user = @account_invitation.accept!(user)
      assert account_user.persisted?
      assert_equal user, account_user.user
    end

    assert_raises ActiveRecord::RecordNotFound do
      @account_invitation.reload
    end
  end

  test "reject" do
    assert_difference "AccountInvitation.count", -1 do
      @account_invitation.reject!
    end
  end

  test "accept sends notifications account owner and inviter" do
    assert_difference "Notification.count", 2 do
      account_invitations(:two).accept!(users(:invited))
    end
    assert_equal @account, Notification.last.account
    assert_equal users(:invited), Notification.last.params[:user]
  end
end
