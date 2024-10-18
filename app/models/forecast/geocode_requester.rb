# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

# Use GeocodeRequester to interface with HERE API to receive location information.
# It is primarily used for requesting a zip code (postal code).
# Current refers to the current conditions at a location, while Forecast is the upcoming weather
# Example usage:
#   geo_requester = Forecast::GeocodeRequester.new(forecast.address)
#   geo_requester.parse_for_zipcode => json_api_response
#
# # Note that on initialization, the request is sent. Refactor as appropriate if the expectations on GeocodeRequester change.
#
# For error checking, use #valid_response?
# RequestInvalidError can be used for specific handling

class Forecast::GeocodeRequester
  class RequestInvalidError < RuntimeError; end

  BASE_URI = "https://geocode.search.hereapi.com/v1/".freeze
  API_KEY = (ENV["HERE_API_KEY"] || "RUIsEe39r2gySGLNw6WyyHzvqOlHJxAsloc-M9g1jhE").freeze

  attr_accessor :response, :address

  def initialize(address)
    @address = address
    request_geocode_information!
  end

  def request_geocode_information!
    uri = URI("#{BASE_URI}/geocode")
    params = { q: @address, apiKey: API_KEY }
    uri.query = URI.encode_www_form(params)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    @response = http.request(request)
  end

  def parse_for_zipcode
    zip = serialized_response.zipcode
    return "" if zip.nil?

    # return only the first 5 of the zip-code, note: only have tested within USA
    zip.match /\d{5}/
  end

  def serialized_response
    return { error: @response.message } unless valid_response?

    GeocodeSerializer.new(JSON.parse(@response.body))
  end

  def valid_response? = @response.is_a?(Net::HTTPSuccess)
end
