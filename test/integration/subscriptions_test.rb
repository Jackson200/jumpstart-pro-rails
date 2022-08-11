require "test_helper"

class Jumpstart::SubscriptionsTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:company)
    @admin = users(:one)
    @regular_user = users(:two)
    @plan = plans(:personal)
    @card_token = "tok_visa"
  end

  class AdminUsers < Jumpstart::SubscriptionsTest
    setup do
      sign_in @admin
      Jumpstart::Multitenancy.stub :selected, [] do
        switch_account(@account)
      end
    end

    test "can subscribe account" do
      Jumpstart.config.stub(:payments_enabled?, true) do
        Jumpstart.config.stub(:collect_billing_address?, false) do
          get new_subscription_path(plan: @plan)
          assert_response :success
        end
      end
    end
  end

  class RegularUsers < Jumpstart::SubscriptionsTest
    setup do
      sign_in @regular_user
      Jumpstart::Multitenancy.stub :selected, [] do
        switch_account(@account)
      end
    end

    test "cannot navigate to new_subscription page" do
      Jumpstart.config.stub(:payments_enabled?, true) do
        get new_subscription_path(plan: @plan)
        assert_redirected_to root_path
        assert_equal I18n.t("must_be_an_admin"), flash[:alert]
      end
    end

    test "cannot subscribe" do
      Jumpstart.config.stub(:payments_enabled?, true) do
        post subscriptions_path, params: {}
        assert_redirected_to root_path
        assert_equal I18n.t("must_be_an_admin"), flash[:alert]
      end
    end

    test "cannot delete subscription" do
      @account.set_payment_processor :fake_processor, allow_fake: true
      subscription = @account.payment_processor.subscribe
      Jumpstart.config.stub(:payments_enabled?, true) do
        delete subscription_cancel_path(subscription)
        assert_redirected_to root_path
        assert_equal I18n.t("must_be_an_admin"), flash[:alert]
      end
    end
  end
end
