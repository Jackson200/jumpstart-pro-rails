require "test_helper"

class Jumpstart::MultitenancyTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @account = accounts(:company)
    sign_in @user
  end

  test "domain multitenancy" do
    Jumpstart::Multitenancy.stub :selected, ["domain"] do
      get user_root_path
      assert_select "a", text: @user.name

      host! @account.domain
      sign_in @user

      get user_root_path
      assert_select "a", text: @account.name
    end
  end

  test "subdomain multitenancy" do
    Jumpstart::Multitenancy.stub :selected, ["subdomain"] do
      get user_root_path
      assert_select "a", text: @user.name

      host! "#{@account.subdomain}.example.com"
      sign_in @user

      get user_root_path
      assert_select "a", text: @account.name
    end
  end

  test "script path multitenancy" do
    Jumpstart::Multitenancy.stub :selected, ["path"] do
      get "/"
      assert_select "a", text: @user.name

      get "/#{@account.id}/"
      assert_select "a", text: @account.name
    end
  end

  test "session multitenancy" do
    Jumpstart::Multitenancy.stub :selected, [] do
      get user_root_path
      assert_select "a", text: @user.name

      switch_account(@account)

      get user_root_path
      assert_select "a", text: @account.name
    end
  end
end
