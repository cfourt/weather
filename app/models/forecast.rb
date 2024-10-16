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
  require 'ostruct'
  EXPIRATION = 30.minutes

  validates :address_hash, presence: true, uniqueness: true
  validates_with AddressValidator

  after_initialize :add_address_hash
  after_initialize :add_expiry_date

  attr_accessor :cached

  def initialize(attributes = {})
    super(attributes) # Pass attributes to ActiveRecord's initialize method
    self.cached = false
  end

  def self.request_forecast!(address)
    requester = Forecast::Requester.new(address)
    raise StandardError unless requester.valid_response?

    Forecast.new(address: address, data: requester.parsed_response)
  end

  def expired? = Time.current >= self.expires_at

  def cached? = self.cached

  def self.generate_address_hash(address) = Digest::MD5.hexdigest(address)

  def self.find_fresh_by(address:)
    # internally use address_hash for faster lookup
    address_hash = Forecast.generate_address_hash(address)
    forecast = Forecast.find_by(address_hash: address_hash)
    return forecast unless forecast && forecast.expired?
    nil
  end

  # prefer . access instead of .dig or [][]
  def data
    OpenStruct.new(super)
  end

  private

  def add_address_hash
    self.address_hash = Digest::MD5.hexdigest(address)
  end

  def add_expiry_date
    self.expires_at ||= EXPIRATION.from_now
  end

end
