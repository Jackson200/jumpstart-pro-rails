# == Schema Information
#
# Table name: api_tokens
#
#  id           :bigint           not null, primary key
#  expires_at   :datetime
#  last_used_at :datetime
#  metadata     :jsonb
#  name         :string
#  token        :string
#  transient    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_api_tokens_on_token    (token) UNIQUE
#  index_api_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require "test_helper"

class ApiTokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
