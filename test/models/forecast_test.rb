# == Schema Information
#
# Table name: forecasts
#
#  id           :bigint           not null, primary key
#  address      :string
#  address_hash :string
#  data         :string
#  expires_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_forecasts_on_address_hash  (address_hash)
#
require "test_helper"

class ForecastTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
