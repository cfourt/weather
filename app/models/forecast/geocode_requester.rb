# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

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
    # return only the first 5 of the zip-code, note: limited to USA!
    zip.match /\d{5}/
  end

  def serialized_response
    return { error: @response.message } unless valid_response?

    GeocodeSerializer.new(JSON.parse(@response.body))
  end

  def valid_response? = @response.is_a?(Net::HTTPSuccess)
end
