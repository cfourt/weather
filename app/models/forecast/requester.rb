# frozen_string_literal: true
require "net/http"
require "json"
require "uri"

# Use Requester to interface with WeatherAPI to receive forecast information
# Current refers to the current conditions at a location, while Forecast is the upcoming weather
# Example usage:
#   requester = Forecast::Requester.new(forecast.address)
#   requester.response.body => json_api_response
#
# Note that on initialization, the request is sent. Refactor as appropriate if the expectatinos on Requester change.
#
# For error checking, use #valid_response?
# RequestInvalidError can be used for specific handling

class Forecast::Requester
  class RequestInvalidError < RuntimeError; end

  BASE_URI = "https://api.weatherapi.com/v1"
  API_KEY = ENV["API_KEY"] || "eb215054a2364e638d5202918241510"

  attr_accessor :current_response, :address, :forecast_response

  def initialize(address)
    @address = address
  end

  def get_current_weather_by_address!
    uri = URI("#{BASE_URI}/current.json")
    params = { q: @address, key: API_KEY }
    uri.query = URI.encode_www_form(params)
    @response = Net::HTTP.get_response(uri)
    raise RequestInvalidError unless valid_response?

    JSON.parse(@response.body)
  end

  def get_forecast_by_address!
    uri = URI("#{BASE_URI}/forecast.json")
    params = { q: @address, key: API_KEY, days: 3 }
    uri.query = URI.encode_www_form(params)
    @forecast_response = Net::HTTP.get_response(uri)
    raise RequestInvalidError unless valid_forecast_response?

    JSON.parse(@forecast_response.body)
  end

  def serialized_response
    return { error: @response.message } unless valid_response?

    ForecastDataSerializer.new(@response.body)
  end

  def serialized_forecast_response
    return { error: @forecast_response.message } unless valid_forecast_response?

    ForecastDataSerializer.new(@forecast_response.body)
  end

  def valid_response? = @response.is_a?(Net::HTTPSuccess)

  def valid_forecast_response? = @forecast_response.is_a?(Net::HTTPSuccess)

end
