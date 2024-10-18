class AddForecastToForecast < ActiveRecord::Migration[7.2]
  def change
    add_column :forecasts, :forecast_data, :jsonb
  end
end
