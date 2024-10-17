class ForecastRequ' esterJob < ApplicationJob

  queue_as :default

  def perform(forecast_id)
    forecast = Forecast.find(forecast_id)
    forecast.request_forecast!
    forecast.save
    puts "Fetched Forecast for #{forecast.id}"
  end
end
