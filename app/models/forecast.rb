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
class Forecast < ApplicationRecord
  EXPIRATION = 30.minutes.freeze

  attr_accessor :cached

  scope :not_expired, -> { where("updated_at > ?", EXPIRATION.ago) }
  scope :index_list, -> { not_expired.order(created_at: :desc).limit(25) }

  validate :validate_address

  after_update_commit { broadcast_update_to "forecast" }
  before_save :request_zipcode_async, if: :will_save_change_to_data?

  def initialize(attributes = {})
    super(attributes) # Pass attributes to ActiveRecord's initialize method
    self.cached = false
  end

  def request_forecast!
    requester = Forecast::Requester.new(self.address)
    raise Forecast::Requester::RequestInvalidError unless requester.valid_response?

    self.data = JSON.parse(requester.response.body)
  end

  def request_zipcode!
    requester = Forecast::GeocodeRequester.new(self.address)
    binding.b
    raise Forecast::GeocodeRequester::RequestInvalidError unless requester.valid_response?

    self.zipcode = requester.parse_for_zipcode
  end

  def request_forecast_async = ForecastRequesterJob.perform_now(self.id)

  def request_zipcode_async = GeocodeRequesterJob.perform_now(self.id)

  def expiry_date = self.updated_at + EXPIRATION

  def expired? = Time.current >= (self.updated_at + EXPIRATION)

  def cached? = self.cached

  def serialized_data = ForecastDataSerializer.new(data)

  private

  def validate_address
    return if address.match?(/\A[A-Za-z0-9'\.\-\s,]+\z/)

    self.errors.add(:address, "Must be a valid address which cannot contain any symbols")
  end

end
