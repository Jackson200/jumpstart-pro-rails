require "application_system_test_case"

class AccountSystemTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    login_as @user, scope: :user
  end

  test "can upload avatar" do
    refute @user.avatar.attached?
    visit edit_user_registration_path
    attach_file "user[avatar]", file_fixture("avatar.jpg")
    click_button "Update"
    assert_selector "img[src*='avatar.jpg']"
  end
end
