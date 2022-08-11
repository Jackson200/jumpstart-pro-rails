begin
  require "stripe"
rescue LoadError
  puts "Skipping Stripe system tests because Stripe is not enabled."
  return
end

require "application_system_test_case"

class StripeSystemTest < ApplicationSystemTestCase
  setup do
    @user = users(:two)
    @account = @user.personal_account
    @account.set_payment_processor :stripe
    login_as @user, scope: :user
    switch_account(@account)

    # Only test against Stripe even if others are enabled
    @original_payment_processors = Jumpstart.config.payment_processors
    Jumpstart.config.payment_processors = [:stripe]

    @collect_billing_address = Jumpstart.config.collect_billing_address?
    Jumpstart.config.collect_billing_address = false
  end

  teardown do
    Jumpstart.config.payment_processors = @original_payment_processors
    Jumpstart.config.collect_billing_address = @collect_billing_address
  end

  test "can subscribe" do
    visit new_subscription_url(plan: plans(:personal))
    fill_stripe_payment_element_card "4242 4242 4242 4242"
    click_on "Subscribe"
    assert_selector "p", text: I18n.t("subscriptions.created")
    assert @account.payment_processor.subscribed?
  end

  test "can subscribe with SCA" do
    visit new_subscription_url(plan: plans(:personal))
    fill_stripe_payment_element_card "4000 0027 6000 3184"
    click_on "Subscribe"
    complete_stripe_sca
    assert_selector "p", text: I18n.t("subscriptions.created")
  end

  test "handles SCA and insufficient funds" do
    visit new_subscription_url(plan: plans(:personal))
    fill_stripe_payment_element_card "4000 0082 6000 3178"
    click_on "Subscribe"
    complete_stripe_sca
    assert_selector "div", text: "Your card has insufficient funds."
  end

  test "fail subscribe with SCA" do
    visit new_subscription_url(plan: plans(:personal))
    fill_stripe_payment_element_card "4000 0027 6000 3184"
    click_on "Subscribe"
    fail_stripe_sca
    assert_selector "div", text: "We are unable to authenticate your payment method. Please choose a different payment method and try again."
  end

  test "can update payment method" do
    visit new_payment_method_url
    fill_stripe_payment_element_card "4242 4242 4242 4242"
    click_on "Update Card"
    assert_selector "p", text: I18n.t("payment_methods.create.updated")
    assert_equal "Visa", @account.payment_processor.default_payment_method.brand
    assert_equal "4242", @account.payment_processor.default_payment_method.last4
  end

  test "can update payment method with SCA" do
    visit new_payment_method_url
    fill_stripe_payment_element_card "4000 0027 6000 3184"
    click_on "Update Card"
    complete_stripe_sca
    assert_selector "p", text: I18n.t("payment_methods.create.updated")
    assert_equal "Visa", @account.payment_processor.default_payment_method.brand
    assert_equal "3184", @account.payment_processor.default_payment_method.last4
  end

  test "can fail updating payment method with SCA" do
    visit new_payment_method_url
    fill_stripe_payment_element_card "4000 0027 6000 3184"
    click_on "Update Card"
    fail_stripe_sca
    assert_selector "div", text: "We are unable to authenticate your payment method. Please choose a different payment method and try again."
    assert_nil @account.payment_processor.default_payment_method
  end

  test "can swap plans" do
    old_plan_id = plans(:personal).id_for_processor(:stripe)

    @account.set_payment_processor :stripe
    @account.payment_processor.payment_method_token = payment_method.id
    subscription = @account.payment_processor.subscribe(plan: old_plan_id)

    # Swap subscription
    visit edit_subscription_url(subscription)
    click_on "Change Plan", match: :first

    # Assert we were redirected to the correct page
    assert_selector "h1", text: I18n.t("subscriptions.index.title")
    assert_not_equal old_plan_id, subscription.reload.processor_plan
  end

  test "can swap plans with SCA" do
    # Subscribe to a new plan
    visit new_subscription_url(plan: plans(:personal))
    fill_stripe_payment_element_card "4000 0027 6000 3184"
    click_on "Subscribe"
    complete_stripe_sca
    assert_selector "div", text: I18n.t("subscriptions.created")

    # Fake webhook that sets subscription status to active
    subscription = @account.payment_processor.subscription
    subscription.update(status: :active)

    old_plan_id = subscription.processor_plan

    # Swap subscription
    visit edit_subscription_url(subscription)
    click_on "Change Plan", match: :first

    # Changes are prorated so we don't have to go through SCA again

    assert_selector "h1", text: I18n.t("subscriptions.index.title")
    assert_not_equal old_plan_id, subscription.reload.processor_plan
  end

  # Subscribe with no trial
  # Redirect to payment auth page
  # Fail authentication
  # Verify that requires_payment_method on payment intent at this point
  # Then enter new card and authenticate
  # Then confirm subscribed

  private

  def payment_method
    @payment_method ||= create_payment_method
  end

  def sca_payment_method
    @sca_payment_method ||= create_payment_method(card: {number: "4000 0027 6000 3184"})
  end

  def create_payment_method(options = {})
    defaults = {
      type: "card",
      billing_details: {name: "Jane Doe"},
      card: {
        number: "4242 4242 4242 4242",
        exp_month: 9,
        exp_year: Time.now.year + 5,
        cvc: 123
      }
    }

    ::Stripe::PaymentMethod.create(defaults.deep_merge(options))
  end
end
