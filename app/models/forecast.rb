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

# Forecast
# The primary class for fetching weather/forecast information
# .forecast_data is used for storing upcoming weather, while .data is used for storing the current weather and location information
# "!" methods (e.g. request_and_assign_forecast_data!) trigger immediate requests, use async methods to schedule jobs and allow immediate returns
#
#
# TODO
# - Refactor current weather and location information into different fields for more clear and scalable access
# - Remove cached virtual attribute, it is deprecated
# - Consolidate forecast and current requests into one call
# - Simply data storage to retain only required information (e.g. no need to retain pressure or other forecast data)

class Forecast < ApplicationRecord
  EXPIRATION = 30.minutes.freeze

  attr_accessor :cached

  scope :not_expired, -> { where("updated_at > ?", EXPIRATION.ago) }
  scope :index_list, -> { not_expired.order(created_at: :desc).limit(25) }

  validate :validate_address

  after_update_commit { broadcast_update_to "forecast" }
  before_save :request_zipcode_async, if: :will_save_change_to_data?

  def initialize(attributes = {})
    super(attributes)
    self.cached = false
  end

  def request_and_assign_forecast_data!
    requester = Forecast::Requester.new(self.address)
    self.data = requester.get_current_weather_by_address!

    requester.get_forecast_by_address!
    self.forecast_data = requester.get_forecast_by_address!
  end

  def request_and_assign_zipcode!
    requester = Forecast::GeocodeRequester.new(self.address)
    raise Forecast::GeocodeRequester::RequestInvalidError unless requester.valid_response?

    self.zipcode = requester.parse_for_zipcode
  end

  def request_forecast_async = ForecastRequesterJob.perform_now(self.id)

  def request_zipcode_async = GeocodeRequesterJob.perform_now(self.id)

  def expiry_date = self.updated_at + EXPIRATION

  def expired? = Time.current >= (self.updated_at + EXPIRATION)

  def cached? = self.cached

  def serialized_current_weather_data = ForecastDataSerializer.new(data)

  # TODO
  # def serialized_forecast_data = ForecastDataSerializer.new(forecast_data)

  private

  def validate_address
    return if address.match?(/\A[A-Za-z0-9'\.\-\s,]+\z/)

    self.errors.add(:address, "Must be a valid address which cannot contain any symbols")
  end

end
