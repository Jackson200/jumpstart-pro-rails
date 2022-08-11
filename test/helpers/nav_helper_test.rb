require "test_helper"

class NavHelperTest < ActionView::TestCase
  include NavHelper

  attr_reader :request

  test "accepts block" do
    block_link = nav_link_to("/block") { "Block Link" }
    assert_equal %(<a href="/block">Block Link</a>), block_link
  end

  test "accepts block with classes" do
    block_link = nav_link_to("/block-class", class: "nav") { "Block Link with Classes" }
    assert_equal %(<a class="nav" href="/block-class">Block Link with Classes</a>), block_link
  end

  test "test_link_with_url" do
    link = nav_link_to("GoRails", "https://gorails.com")
    assert_equal %(<a href="https://gorails.com">GoRails</a>), link
  end

  test "test_link_with_classes" do
    link = nav_link_to("Link with Classes", "/link-class", class: "nav")
    assert_equal %(<a class="nav" href="/link-class">Link with Classes</a>), link
  end

  test "test_link_with_data_attributes" do
    link = nav_link_to("Link with data attrs", "/link-attrs", class: "nav", data: {test: "foo"})
    assert_equal %(<a class="nav" data-test="foo" href="/link-attrs">Link with data attrs</a>), link
  end

  test "test_link_active_class" do
    request.path = "/link-active"
    link = nav_link_to("Link active", "/link-active")
    assert_equal %(<a class="active" href="/link-active">Link active</a>), link
  end

  test "test_link_custom_active_class" do
    request.path = "/custom-active-class"
    link = nav_link_to("Custom active class", "/custom-active-class", active_class: "custom_active")
    assert_equal %(<a class="custom_active" href="/custom-active-class">Custom active class</a>), link
  end

  test "test_link_custom_inactive_class" do
    link = nav_link_to("Custom inactive class", "/custom-inactive", inactive_class: "custom_inactive")
    assert_equal %(<a class="custom_inactive" href="/custom-inactive">Custom inactive class</a>), link
  end

  test "test_link_starts_with_active_class" do
    request.path = "/foo/1/bar/1"
    link = nav_link_to("Starts with", "/starts", starts_with: "/foo")
    assert_equal %(<a class="active" href="/starts">Starts with</a>), link
  end
end
