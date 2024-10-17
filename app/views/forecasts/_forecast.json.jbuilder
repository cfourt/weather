json.extract! forecast, :id, :address, :zipcode, :data, :created_at, :updated_at
json.url forecast_url(forecast, format: :json)
