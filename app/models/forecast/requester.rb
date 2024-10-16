# frozen_string_literal: true
require "net/http"
require "json"
require "uri"

class Forecast::Requester
  BASE_URI = "https://api.weatherapi.com/v1"
  API_KEY = ENV["API_KEY"] || "eb215054a2364e638d5202918241510"

  attr_accessor :response, :address

  def initialize(address)
    @address = address
    get_current_forecast_by_address
  end

  def get_current_forecast_by_address
    uri = URI("#{BASE_URI}/current.json")
    params = { q: @address, key: API_KEY }
    uri.query = URI.encode_www_form(params)
    @response = Net::HTTP.get_response(uri)
  end

  def parsed_response
    if valid_response?
      JSON.parse(@response.body)
    else
      { error: @response.message }
    end
  end

  def valid_response?
    @response.is_a?(Net::HTTPSuccess) ? true : false
  end
end
