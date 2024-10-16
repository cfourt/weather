module ForecastsHelper
  def data_list(data)
    data.map do |key, value|
      content_tag(:dt, key) + content_tag(:dd, value)
    end.join().html_safe
  end

  def current_forecast_data_list(data)
    data.map do |key, value|
      next unless current_forecast_keys_to_display.include?(key)
      content_tag(:dt, "#{icon_map(key)} #{forecast_labelize(key)}", class: "fs-2") + content_tag(:dd, value, class: "fs-2")
    end.join().html_safe
  end

  def location_data_list(data)
    data.map do |key, value|
      next unless location_keys_to_display.include?(key)
      content_tag(:dt, location_labelize(key), class: "fs-4") + content_tag(:dd, value, class: "fs-4")
    end.join().html_safe
  end

  def location_keys_to_display
    Forecast::Payload::LOCATION_KEYS - ["localtime_epoch"]
  end

  def current_forecast_keys_to_display
    Forecast::Payload::CURRENT_KEYS -
      %w[condition is_day temp_c gust_kph wind_kph precip_mm dewpoint_c feelslike_c heatindex_c pressure_mb windchill_c last_updated_epoch last_updated]
  end

  def icon_map(key)
    case key
    when /uv/; "☀️"
    when /cloud/; "☁️"
    when /temp/; "🌡️"
    when /vis/; "👁️"
    when /precip/; "🌧️"
    when /dewpoint/; nil
    when /pressure/; "💎"
    when /wind_degree/; "🧭"
    when /wind_chill/; "🥶"
    end
  end

  def location_labelize(key)
    case key
    when /lat/; "Latitude"
    when /lon/; "Longitude"
    when /name/; "Location"
    when /tz_id/; "Timezone"
    when /region/; "Region"
    when /country/; "Country"
    when /localtime/; "Local time"
    end
  end

  def forecast_labelize(key)
    case key
    when /uv/; "UV"
    when /cloud/; "Cloud"
    when /temp/; "Temperature"
    when /feels/; "Feels like"
    when /vis/; "Visibility"
    when /precip/; "Precipitation"
    when /dewpoint/; "Dew point"
    when /pressure/; "Pressure"
    when /wind_degree/; "Wind degree"
    when /wind_chill/; "Wind chill"
    when /gust/; "Gust"
    when /humidity/; "Humidity"
    when /wind_dir/; "Wind direction"
    when /wind_mph/; "Wind (mph)"
    when /heat_index/; "Heat index"
    when /windchill_f/; "Wind-chill"
    else
      key
    end
  end
end
