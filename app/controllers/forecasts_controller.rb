class ForecastsController < ApplicationController

  # GET /forecasts/1 or /forecasts/1.json
  def show
    @forecast = Forecast.find(params[:id])
    retrieve_or_indicate_cache_is_valid
    @forecast.reload
  end

  def index
    @forecasts = Forecast.index_list
  end

  def create
    @forecast = find_by_address_or_zip

    # render forecast if we have it saved already
    if @forecast.present?
      retrieve_or_indicate_cache_is_valid
      redirect_to @forecast and return
    end

    @forecast = Forecast.new(address: params[:address])

    unless @forecast.valid?
      flash.now[:error] = @forecast.errors.full_messages.to_sentence
      return render :index
    end

    respond_to do |format|
      if @forecast.save
        @forecast.request_forecast_async # requires ID
        format.html { redirect_to @forecast }
        format.json { render :show, status: :ok, location: @forecast }
      else
        @forecasts = Forecast.index_list
        format.html { render :index, error: @forecast.errors.full_messages.to_sentence }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def retrieve_or_indicate_cache_is_valid
    return @forecast.request_forecast_async if @forecast.expired?

    flash[:info] = "Retrieving a cached forecast"
  end

  def find_by_address_or_zip
    return Forecast.find_by(zipcode: params[:address]) if param_is_zipcode?

     Forecast.find_by(address: params[:address])
  end

  def param_is_zipcode?
    params[:address].match? /\d{5}/
  end

  # Only allow a list of trusted parameters through.
  def forecast_params
    params.require(:forecast).permit(:address)
  end
end
