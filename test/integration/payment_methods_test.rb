require "test_helper"

class PaymentMethodsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @user.personal_account.pay_customers.destroy_all
    switch_account @user.personal_account
  end

  test "user can add a payment method without a processor set" do
    get new_payment_method_path
    assert_response :success
  end

  test "fake processor sees a message" do
    @user.personal_account.set_payment_processor :fake_processor, allow_fake: true
    get new_payment_method_path
    assert_response :success
    assert_match ERB::Util.h(I18n.t("payment_methods.forms.fake_processor.message")), response.body
  end
end
