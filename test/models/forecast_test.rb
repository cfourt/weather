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

  test "should have address_hash automatically added" do
    forecast = Forecast.new(address: "123 Main St")
    assert forecast.valid?
  end

  test "should be invalid without address_hash" do
    forecast = Forecast.new(address: "123 Main St")
    forecast.address_hash = ''
    refute forecast.valid?
  end

  test "should add expiry date automatically" do
    forecast = Forecast.new(address: "123 Main St")
    assert forecast.expires_at.present?
  end

  test "generate_address_hash should generate an MD5 " do
    address = "123 Main St"
    hash = Forecast.generate_address_hash(address)
    md5_hash = Digest::MD5.hexdigest(address)
    assert_equal md5_hash, hash
  end

  test "#find_fresh_by should return nil, not an expired record" do
    address = "123 Main St"
    Forecast.create(address: address, expires_at: 1.minute.ago)
    assert_nil Forecast.find_fresh_by(address: address)
  end

  test "#find_fresh_by should return a non-expired record" do
    address = "678 Main St"
    created = Forecast.create!(address: address, expires_at: 10.minutes.from_now)
    assert_equal created.address_hash, Forecast.generate_address_hash(address)
    assert_not_nil Forecast.find_fresh_by(address: address)
  end

  # TODO write tests for Forecast::Requester
end
