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

  validates_with AddressValidator
  validates :address_hash, presence: true, uniqueness: true
  validates :data, presence: true, uniqueness: true

  before_save :add_address_hash

  attr_accessor :cached

  scope :not_expired, -> { where('updated_at > ?', EXPIRATION.ago) }

  def initialize(attributes = {})
    super(attributes) # Pass attributes to ActiveRecord's initialize method
    self.cached = false
  end

  def request_forecast!
    requester = Forecast::Requester.new(self.address)
    raise Forecast::Requester::RequestInvalidError unless requester.valid_response?

    self.data = JSON.parse requester.response.body
  end

  def expiry_date = self.updated_at + EXPIRATION

  def expired? = Time.current >= (self.updated_at + EXPIRATION)

  def cached? = self.cached

  # generates an approximation of zip code
  def generate_address_hash
    data = self.serialized_data
    string = data.location.name + data.location.region + data.location.country
    Digest::MD5.hexdigest(string)
  end

  def serialized_data
    ForecastDataSerializer.new(data)
  end

  private

  def add_address_hash
    self.address_hash = Digest::MD5.hexdigest(generate_address_hash)
  end

  def add_expiry_date
    self.expires_at ||= EXPIRATION.from_now
  end

end
