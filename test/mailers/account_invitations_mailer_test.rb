require "test_helper"

class AccountInvitationsMailerTest < ActionMailer::TestCase
  test "invite" do
    account_invitation = account_invitations(:one)
    mail = AccountInvitationsMailer.with(account_invitation: account_invitation).invite
    assert_equal I18n.t("account_invitations_mailer.invite.subject", inviter: "User One", account: "Company"), mail.subject
    assert_equal [account_invitation.email], mail.to
    assert_equal [Jumpstart.config.support_email], mail.from
    assert_match I18n.t("account_invitations_mailer.invite.accept_or_decline"), mail.body.encoded
  end
end
