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

  test "should have zipcode eventually added" do
    skip
  end

  test "#find_fresh_by should return nil, not an expired record" do
    address = "123 Main St"
    Forecast.create(address: address)
    assert_nil Forecast.find_fresh_by(address: address)
  end

  # TODO
  test "#find_fresh_by should return a non-expired record" do
    address = "678 Main St"
    Forecast.create!(address: address)
    # assert_not_nil Forecast.find_fresh_by(address: address)
  end

  # TODO write tests for Forecast::Requester
end
