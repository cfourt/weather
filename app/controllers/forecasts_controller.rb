class ForecastsController < ApplicationController

  # GET /forecasts/1 or /forecasts/1.json
  def show
    @forecast = Forecast.find(params[:id])
    return @forecast unless @forecast.expired?

    @forecast.request_forecast!
    @forecast.reload
  end

  def index
    @forecasts = Forecast.all.not_expired.order(created_at: :desc).limit(25)
  end

  def create
    @forecast = Forecast.find_by(address: params[:address])

    # render forecast if we have it saved already
    if @forecast.present?
      flash[:info] = "Retrieving a cached forecast"
      redirect_to @forecast and return
    end

    @forecast = Forecast.new(address: params[:address])
    @forecast.request_forecast!

    respond_to do |format|
      if @forecast.save
        format.html { redirect_to @forecast }
        format.json { render :show, status: :ok, location: @forecast }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def forecast_params
    params.require(:forecast).permit(:address)
  end
end
