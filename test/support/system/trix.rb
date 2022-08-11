module TrixSystemTestHelper
  extend ActiveSupport::Concern

  # fill_in_trix_editor "post_body", with: "Hello world"
  def fill_in_trix_editor(id, with:)
    find(:xpath, "//trix-editor[@input='#{id}']").click.set(with)
  end

  # find_trix_editor "post_body"
  def find_trix_editor(id)
    find(:xpath, "//*[@id='#{id}']", visible: false)
  end
end
