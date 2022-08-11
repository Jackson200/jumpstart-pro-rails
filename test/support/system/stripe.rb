module StripeSystemTestHelper
  extend ActiveSupport::Concern

  # Test cards:
  # 4242 4242 4242 4242 - succeeds without authentication
  # 4000 0027 6000 3184 - requires authentication
  # 4000 0000 0000 9995 - declined with insufficient_funds
  def fill_stripe_payment_element_card(card, expiry: "1234", cvc: "123", postal: "12345", selector: 'iframe[title="Secure payment input frame"]')
    find_frame(selector) do
      card.to_s.chars.each do |piece|
        find_field("number", disabled: :all).send_keys(piece)
      end

      find_field("expiry").send_keys expiry
      find_field("cvc").send_keys cvc
      find_field("postalCode").send_keys postal
    end
  end

  def fill_stripe_elements(card:, expiry: "1234", cvc: "123", postal: "12345", selector: '[data-stripe-target="card"] > div > iframe')
    find_frame(selector) do
      card.to_s.chars.each do |piece|
        find_field("cardnumber").send_keys(piece)
      end

      find_field("exp-date").send_keys expiry
      find_field("cvc").send_keys cvc
      find_field("postal").send_keys postal
    end
  end

  def complete_stripe_sca
    find_frame("body > div > iframe:first-of-type") do
      sleep 1
      find_frame("#challengeFrame") do
        find_frame("iframe[name='acsFrame']") do
          click_on "Complete authentication"
        end
      end
    end
  end

  def fail_stripe_sca
    find_frame("body > div > iframe:first-of-type") do
      sleep 1
      find_frame("#challengeFrame") do
        find_frame("iframe[name='acsFrame']") do
          click_on "Fail authentication"
        end
      end
    end
  end

  def find_frame(selector, &block)
    using_wait_time(15) do
      frame = first(selector, visible: :all)
      within_frame(frame) do
        block.call
      end
    end
  end
end
