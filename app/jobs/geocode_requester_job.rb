class GeocodeRequesterJob < ApplicationJob
  queue_as :default

  def perform(forecast_id)
    forecast = Forecast.find(forecast_id)
    forecast.request_and_assign_zipcode!
    forecast.save
    puts "Fetched zip for #{forecast.id}"
  end
end
