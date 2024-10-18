# == Schema Information
#
# Table name: forecasts
#
#  id         :bigint           not null, primary key
#  address    :string
#  data       :jsonb
#  zipcode    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_forecasts_on_zipcode  (zipcode)
#
require "test_helper"

class ForecastTest < ActiveSupport::TestCase

  # TODO test the eventual completeness of the record through sidekiq
  test "should have zipcode eventually added" do
    skip
  end

  test "can create record" do
    address = "678 Main St"
    Forecast.create!(address: address)
    assert Forecast.last.address == address
  end
end
