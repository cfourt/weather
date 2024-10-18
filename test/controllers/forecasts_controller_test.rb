require "test_helper"

class ForecastsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forecast = forecasts(:one)
  end

  test "should get index" do
    get forecasts_url
    assert_response :success
  end

  test "should not create forecast for existing record" do
    assert_no_difference("Forecast.count") do
      post forecasts_url, params: { address: @forecast.address }
    end

    assert_redirected_to forecast_url(Forecast.last)
  end

  test "should show forecast" do
    skip
    # need to update to use serializer
    get forecast_url(@forecast)
    assert_response :success
  end

  test "should return a zip cache hit early" do
    skip
  end
end
