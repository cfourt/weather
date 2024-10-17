# frozen_string_literal: true

# == Example Payload
#
# #<ForecastSerializer:0x000000011fb52af0
#  @instance_options={},
#  @object=
#   {"current"=>
#     {"uv"=>2.4,
#      "cloud"=>100,
#      "is_day"=>1,
#      "temp_c"=>19.3,
#      "temp_f"=>66.7,
#      "vis_km"=>16.0,
#      "gust_kph"=>11.7,
#      "gust_mph"=>7.3,
#      "humidity"=>68,
#      "wind_dir"=>"SSE",
#      "wind_kph"=>9.0,
#      "wind_mph"=>5.6,
#      "condition"=>{"code"=>1009, "icon"=>"//cdn.weatherapi.com/weather/64x64/day/122.png", "text"=>"Overcast"},
#      "precip_in"=>0.0,
#      "precip_mm"=>0.0,
#      "vis_miles"=>9.0,
#      "dewpoint_c"=>11.9,
#      "dewpoint_f"=>53.5,
#      "feelslike_c"=>19.3,
#      "feelslike_f"=>66.7,
#      "heatindex_c"=>17.7,
#      "heatindex_f"=>63.8,
#      "pressure_in"=>29.97,
#      "pressure_mb"=>1015.0,
#      "wind_degree"=>164,
#      "windchill_c"=>17.7,
#      "windchill_f"=>63.8,
#      "last_updated"=>"2024-10-16 11:30",
#      "last_updated_epoch"=>1729103400},
#    "location"=>
#     {"lat"=>38.7522,
#      "lon"=>-121.2869,
#      "name"=>"Roseville",
#      "tz_id"=>"America/Los_Angeles",
#      "region"=>"California",
#      "country"=>"United States of America",
#      "localtime"=>"2024-10-16 11:31",
#      "localtime_epoch"=>1729103515}},
#  @root=nil,

class ForecastDataSerializer < ActiveModel::Serializer
  LOCATION_KEYS = %w[lat lon name tz_id region country localtime localtime_epoch]
  CURRENT_KEYS = %w[uv cloud is_day temp_c temp_f vis_km gust_kph gust_mph humidity wind_dir wind_kph wind_mph condition precip_in precip_mm vis_miles dewpoint_c dewpoint_f feelslike_c feelslike_f heatindex_c heatindex_f pressure_in pressure_mb wind_degree windchill_c windchill_f last_updated last_updated_epoch]
  attributes(LOCATION_KEYS + CURRENT_KEYS)
  # attributes(%i(LOCATION_KEYS + CURRENT_KEYS))

  def location = object["location"]

  def current = object["current"]

  # Location accessors
  def latitude = location["lat"]

  def longitude = location["lon"]

  def name = location["name"]

  def tz_id = location["tz_id"]

  def region = location["region"]

  def country = location["country"]

  def localtime = location["localtime"]

  def localtime_epoch = location["localtime_epoch"]

  # Current accessors
  def uv = current["uv"]

  def cloud = current["cloud"]

  def is_day = current["is_day"]

  def temp_c = current["temp_c"]

  def temp_f = current["temp_f"]

  def vis_km = current["vis_km"]

  def gust_kph = current["gust_kph"]

  def gust_mph = current["gust_mph"]

  def humidity = current["humidity"]

  def wind_dir = current["wind_dir"]

  def wind_kph = current["wind_kph"]

  def wind_mph = current["wind_mph"]

  def condition = current["condition"]

  def precip_in = current["precip_in"]

  def precip_mm = current["precip_mm"]

  def vis_miles = current["vis_miles"]

  def dewpoint_c = current["dewpoint_c"]

  def dewpoint_f = current["dewpoint_f"]

  def feelslike_c = current["feelslike_c"]

  def feelslike_f = current["feelslike_f"]

  def heatindex_c = current["heatindex_c"]

  def heatindex_f = current["heatindex_f"]

  def pressure_in = current["pressure_in"]

  def pressure_mb = current["pressure_mb"]

  def wind_degree = current["wind_degree"]

  def windchill_c = current["windchill_c"]

  def windchill_f = current["windchill_f"]

  def last_updated = current["last_updated"]

  def last_updated_epoch = current["last_updated_epoch"]
end
