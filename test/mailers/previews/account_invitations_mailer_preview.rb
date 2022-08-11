# Preview all emails at http://localhost:3000/rails/mailers/account_invitations_mailer
class AccountInvitationsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/account_invitations_mailer/invite
  def invite
    account = Account.new(name: "Example Account")
    account_invitation = AccountInvitation.new(id: 1, token: "fake", account: account, name: "Test User", email: "test@example.com", invited_by: User.first)
    AccountInvitationsMailer.with(account_invitation: account_invitation).invite
  end
end
