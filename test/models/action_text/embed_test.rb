# == Schema Information
#
# Table name: action_text_embeds
#
#  id         :bigint           not null, primary key
#  fields     :jsonb
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class ActionText::EmbedTest < ActiveSupport::TestCase
  test "renders name with ActionText to_plain_text" do
    embed = action_text_embeds(:one)
    assert_equal "[#{embed.url}]", embed.attachable_plain_text_representation
  end
end
