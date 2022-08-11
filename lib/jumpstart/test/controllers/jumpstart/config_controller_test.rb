require "test_helper"

module Jumpstart
  class ConfigControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get create" do
      get config_create_url
      assert_response :success
    end
  end
end
