module ForecastsHelper
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
    str = case key
          when /lat/; "Latitude"
          when /lon/; "Longitude"
          when /name/; "Location"
          when /tz_id/; "Timezone"
          when /region/; "Region"
          when /country/; "Country"
          when /localtime/; "Local time"
          end
    str + ":"
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
