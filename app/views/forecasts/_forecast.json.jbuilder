json.extract! forecast, :id, :address, :address_hash, :data, :expires_at, :created_at, :updated_at
json.url forecast_url(forecast, format: :json)
