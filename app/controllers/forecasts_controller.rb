class ForecastsController < ApplicationController
  # before_action :set_forecast, only: %i[ show ]

  # GET /forecasts/1 or /forecasts/1.json
  def show
    @forecast = Forecast.find(params[:id])
    return @forecast unless @forecast.expired?

    Forecast.request_forecast!(@forecast.address).save
  end

  def index
    # double check these are still valid!
    @forecasts = Forecast.all.order(created_at: :desc).limit(25)
  end

  def create
    @forecast = Forecast.find_fresh_by(address: params[:address])

    # render forecast if we have it saved already
    if @forecast.present?
      flash[:info] = "Retrieving a cached forecast"
      redirect_to @forecast and return
    end

    # Otherwise, fetch a forecast, handle errors if there are any
    begin
      @forecast = Forecast.request_forecast!(params[:address])
      @forecast.save!
      flash[:info] = "Retrieving a cached forecast" if @forecast.cached?
      redirect_to @forecast and return
    rescue => e
      flash[:error] = e.message
      redirect_to forecasts_path
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_forecast
    @forecast = Forecast.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def forecast_params
    params.require(:forecast).permit(:address)
  end
end
