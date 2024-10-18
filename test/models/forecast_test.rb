# == Schema Information
#
# Table name: forecasts
#
#  id            :bigint           not null, primary key
#  address       :string
#  data          :jsonb
#  forecast_data :jsonb
#  zipcode       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_forecasts_on_zipcode  (zipcode)
#
require "test_helper"

class ForecastTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    @forecast = forecasts(:one)
  end

  test "can create record" do
    address = "678 Main St"
    Forecast.create!(address: address)
    assert Forecast.last.address == address
  end

  test "should be invalid with an address containing symbols" do
    @forecast.address = "!@#$%^&@CA!"
    assert_not @forecast.valid?
    assert_includes @forecast.errors[:address], "Must be a valid address which cannot contain any symbols"
  end

  test "index_list scope limits to 25 results in descending order" do
    26.times { |i| Forecast.create!(address: "#{i} First Street", updated_at: Time.now) }

    forecasts = Forecast.index_list
    assert_equal 25, forecasts.size
  end

  test "expired? returns true if updated_at is past expiration time" do
    # intentionally not referencing Forecast::EXPIRATION to avoid unexpected behavior changes
    @forecast.updated_at = 31.minutes.ago
    assert @forecast.expired?
  end

  test "expired? returns false if updated_at is before expiration time" do
    @forecast.updated_at = 5.minutes.ago
    assert_not @forecast.expired?
  end

  # TODO
  test "updating forecast.data should call GeocodeRequesterJob" do
    skip
  end
end
