# Used to fetch forecast information for a specified location

class ForecastRequesterJob < ApplicationJob

  queue_as :default

  def perform(forecast_id)
    forecast = Forecast.find(forecast_id)
    forecast.request_and_assign_forecast_data!
    forecast.save
    puts "Fetched Forecast for #{forecast.id}"
  end
end
