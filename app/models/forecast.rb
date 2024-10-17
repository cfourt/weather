# == Schema Information
#
# Table name: forecasts
#
#  id           :bigint           not null, primary key
#  address      :string
#  address_hash :string
#  data         :jsonb
#  expires_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_forecasts_on_address_hash  (address_hash)
#
class Forecast < ApplicationRecord
  EXPIRATION = 30.minutes

  validate :validate_address

  before_save :add_address_hash # requires :data to be there

  attr_accessor :cached

  scope :not_expired, -> { where("updated_at > ?", EXPIRATION.ago) }
  scope :index_list, -> { not_expired.order(created_at: :desc).limit(25) }

  def initialize(attributes = {})
    super(attributes) # Pass attributes to ActiveRecord's initialize method
    self.cached = false
  end

  def request_forecast!
    requester = Forecast::Requester.new(self.address)
    raise Forecast::Requester::RequestInvalidError unless requester.valid_response?

    self.data = JSON.parse(requester.response.body)
  end

  def expiry_date = self.updated_at + EXPIRATION

  def expired? = Time.current >= (self.updated_at + EXPIRATION)

  def cached? = self.cached

  def serialized_data
    ForecastDataSerializer.new(data)
  end

  def add_address_hash
    self.address_hash = Digest::MD5.hexdigest(generate_address_hash)
  end

  private

  # generates an approximation of zip code
  def generate_address_hash
    string = self.serialized_data.name +
      self.serialized_data.region +
      self.serialized_data.country
    Digest::MD5.hexdigest(string)
  end

  def add_expiry_date
    self.expires_at ||= EXPIRATION.from_now
  end

  def validate_address
    return if address.match?(/\A[A-Za-z0-9'\.\-\s,]+\z/)

    self.errors.add(:address, "Must be a valid address which cannot contain any symbols")
  end

end
