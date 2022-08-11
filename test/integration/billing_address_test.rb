require "test_helper"

class BillingAddressTest < ActionDispatch::IntegrationTest
  setup do
    @regular_user = users(:two)
    @updating_address_user = users(:one)
  end

  test "can see section for adding/updating billing address on own account" do
    Jumpstart.config.stub(:payments_enabled?, true) do
      Jumpstart.config.stub(:collect_billing_address?, true) do
        sign_in @regular_user
        get subscriptions_path
        assert_select "h5#billing-address", I18n.t("subscriptions.billing_address.billing_address")
      end
    end
  end

  test "can add a billing address" do
    Jumpstart.config.stub(:payments_enabled?, true) do
      Jumpstart.config.stub(:collect_billing_address?, true) do
        assert_difference("Address.count", 1) do
          sign_in @regular_user
          post billing_address_url, params: {
            address: {
              address_type: :billing,
              line1: "123 Test Dr",
              line2: "Apt# 702",
              city: "NewTestCity",
              country: "US",
              state: "TestState",
              postal_code: "12345",
              addressable: @regular_user.accounts.first
            }
          }
        end
      end
    end
  end

  test "cannot add a billing address without postal_code and country" do
    Jumpstart.config.stub(:payments_enabled?, true) do
      Jumpstart.config.stub(:collect_billing_address?, true) do
        sign_in @regular_user
        post billing_address_url, params: {
          address: {
            address_type: :billing,
            line1: "123 Test Dr",
            line2: "Apt# 702",
            city: "NewTestCity",
            state: "TestState",
            addressable: @regular_user.accounts.first
          }
        }

        assert_response :unprocessable_entity
      end
    end
  end

  test "cannot update a billing address without postal_code and country" do
    Jumpstart.config.stub(:payments_enabled?, true) do
      Jumpstart.config.stub(:collect_billing_address?, true) do
        sign_in @regular_user
        post billing_address_url, params: {
          address: {
            address_type: :billing,
            line1: "123 Test Dr",
            line2: "Apt# 702",
            city: "NewTestCity",
            state: "TestState",
            addressable: @regular_user.accounts.first
          }
        }

        assert_response :unprocessable_entity
      end
    end
  end

  test "can update a billing address" do
    Jumpstart.config.stub(:payments_enabled?, true) do
      Jumpstart.config.stub(:collect_billing_address?, true) do
        sign_in @updating_address_user
        patch billing_address_url, params: {
          address: {
            line1: "456 Pickup Sticks Lane"
          }
        }

        assert_equal "456 Pickup Sticks Lane", @updating_address_user.personal_account.billing_address.line1
      end
    end
  end
end
