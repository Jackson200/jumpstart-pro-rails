# == Schema Information
#
# Table name: accounts
#
#  id                 :bigint           not null, primary key
#  domain             :string
#  extra_billing_info :text
#  name               :string           not null
#  personal           :boolean          default(FALSE)
#  subdomain          :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  owner_id           :integer
#
# Indexes
#
#  index_accounts_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "validates against reserved domains" do
    account = Account.new(domain: Jumpstart.config.domain)
    assert_not account.valid?
    assert_not_empty account.errors[:domain]
  end

  test "validates against reserved subdomains" do
    subdomain = Account::RESERVED_SUBDOMAINS.first
    account = Account.new(subdomain: subdomain)
    assert_not account.valid?
    assert_not_empty account.errors[:subdomain]
  end

  test "subdomain format must start with alphanumeric char" do
    account = Account.new(subdomain: "-abcd")
    assert_not account.valid?
    assert_not_empty account.errors[:subdomain]
  end

  test "subdomain format must end with alphanumeric char" do
    account = Account.new(subdomain: "abcd-")
    assert_not account.valid?
    assert_not_empty account.errors[:subdomain]
  end

  test "must be at least two characters" do
    account = Account.new(subdomain: "a")
    assert_not account.valid?
    assert_not_empty account.errors[:subdomain]
  end

  test "can use a mixture of alphanumeric, hyphen, and underscore" do
    [
      "ab",
      "12",
      "a-b",
      "a-9",
      "1-2",
      "1_2",
      "a_3"
    ].each do |subdomain|
      account = Account.new(subdomain: subdomain)
      account.valid?
      assert_empty account.errors[:subdomain]
    end
  end

  test "personal accounts enabled" do
    Jumpstart.config.stub(:personal_accounts, true) do
      user = User.create! name: "Test", email: "personalaccounts@example.com", password: "password", password_confirmation: "password", terms_of_service: true
      assert user.accounts.first.personal?
    end
  end

  test "personal accounts disabled" do
    Jumpstart.config.stub(:personal_accounts, false) do
      user = User.create! name: "Test", email: "nonpersonalaccounts@example.com", password: "password", password_confirmation: "password", terms_of_service: true
      assert_not user.accounts.first.personal?
    end
  end

  test "owner?" do
    account = accounts(:one)
    assert account.owner?(users(:one))
    refute account.owner?(users(:two))
  end

  test "can_transfer? false for personal accounts" do
    refute accounts(:one).can_transfer?(users(:one))
  end

  test "can_transfer? true for owner" do
    account = accounts(:company)
    assert account.can_transfer?(account.owner)
  end

  test "can_transfer? false for non-owner" do
    refute accounts(:company).can_transfer?(users(:two))
  end

  test "transfer ownership to a new owner" do
    account = accounts(:company)
    new_owner = users(:two)
    assert accounts(:company).transfer_ownership(new_owner.id)
    assert_equal new_owner, account.reload.owner
  end

  test "transfer ownership fails transferring to a user outside the account" do
    account = accounts(:company)
    owner = account.owner
    refute account.transfer_ownership(users(:invited).id)
    assert_equal owner, account.reload.owner
  end
end
