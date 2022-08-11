require "application_system_test_case"

class LoginSystemTest < ApplicationSystemTestCase
  test "can login" do
    Capybara.app_host = "http://lvh.me"
    Capybara.always_include_port = true

    visit new_user_session_path

    fill_in "user[email]", with: users(:one).email
    fill_in "user[password]", with: "password"

    find('input[name="commit"]').click

    assert_selector "p", text: I18n.t("devise.sessions.signed_in")
  end

  test "two factor required" do
    Capybara.app_host = "http://lvh.me"
    Capybara.always_include_port = true

    visit new_user_session_path

    fill_in "user[email]", with: users(:twofactor).email
    fill_in "user[password]", with: "password"

    find('input[name="commit"]').click

    assert_selector "h1", text: I18n.t("users.two_factor.header")
  end

  test "two factor success with otp password" do
    Capybara.app_host = "http://lvh.me"
    Capybara.always_include_port = true

    visit new_user_session_path

    fill_in "user[email]", with: users(:twofactor).email
    fill_in "user[password]", with: "password"

    find('input[name="commit"]').click

    fill_in "otp_attempt", with: users(:twofactor).current_otp

    find('input[name="commit"]').click

    assert_selector "p", text: I18n.t("devise.sessions.signed_in")
  end

  test "two factor success with otp backup code" do
    Capybara.app_host = "http://lvh.me"
    Capybara.always_include_port = true

    visit new_user_session_path

    fill_in "user[email]", with: users(:twofactor).email
    fill_in "user[password]", with: "password"

    find('input[name="commit"]').click

    fill_in "otp_attempt", with: users(:twofactor).otp_backup_codes[0]

    find('input[name="commit"]').click

    assert_selector "p", text: I18n.t("devise.sessions.signed_in")
  end

  test "two factor fails with no input" do
    Capybara.app_host = "http://lvh.me"
    Capybara.always_include_port = true

    visit new_user_session_path

    fill_in "user[email]", with: users(:twofactor).email
    fill_in "user[password]", with: "password"

    find('input[name="commit"]').click

    fill_in "otp_attempt", with: ""
    find('input[name="commit"]').click

    assert_selector "p", text: I18n.t("users.sessions.create.incorrect_verification_code")
  end

  test "two factor fails with bad input" do
    Capybara.app_host = "http://lvh.me"
    Capybara.always_include_port = true

    visit new_user_session_path

    fill_in "user[email]", with: users(:twofactor).email
    fill_in "user[password]", with: "password"

    find('input[name="commit"]').click

    fill_in "otp_attempt", with: "abcdefghij"
    find('input[name="commit"]').click

    assert_selector "p", text: I18n.t("users.sessions.create.incorrect_verification_code")
  end
end
