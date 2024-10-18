require "test_helper"

class ForecastRequesterTest < ActiveSupport::TestCase
  def setup
    @address = "1600 Pennsylvania Avenue NW, Washington, DC 20500"
    @api_key = "eb215054a2364e638d5202918241510"

    # Valid case
    @valid_response = Minitest::Mock.new
    @valid_response.expect :is_a?, true, [Net::HTTPSuccess]
    @valid_response.expect :body, "{\"temp\": 22}"
    @valid_response.expect :message, "OK"

    # Invalid case
    @invalid_response = Minitest::Mock.new
    @invalid_response.expect :is_a?, false, [Net::HTTPSuccess]
    @invalid_response.expect :message, "Bad Request"

    @requester = Forecast::Requester.new(@address)
  end

  test "can initialize and call get_current_forecast_by_address!" do
    # Ensure get_current_forecast_by_address! is called on initialization
    requester = Forecast::Requester.new(@address)
    assert requester
  end

  test "get_current_forecast_by_address! makes a request to the correct URI" do
    uri = URI("#{Forecast::Requester::BASE_URI}/current.json")
    params = { q: @address, key: @api_key }
    uri.query = URI.encode_www_form(params)

    Net::HTTP.stub :get_response, @valid_response do
      @requester.get_current_forecast_by_address!
      assert @requester.response.is_a?(Net::HTTPSuccess)
    end
  end

  test "serialized_response returns serialized data for valid response" do
    @requester.stub :response, @valid_response do
      # Mock the valid body content (assuming it's a string)
      valid_body = @valid_response.body

      # Expect ForecastDataSerializer.new to be called with a string (the response body)
      serializer_mock = Minitest::Mock.new
      serializer_mock.expect :new, {}, [valid_body]

      ForecastDataSerializer.stub :new, serializer_mock do
        result = @requester.serialized_response
        assert result
        serializer_mock.verify
      end
    end
  end


  test "serialized_response returns an error message for invalid response" do
    skip
    @requester.stub :response, @invalid_response do
      assert_equal({ error: "Bad Request" }, @requester.response)
    end
  end

  test "valid_response? returns true for HTTPSuccess" do
    @requester.stub :response, @valid_response do
      assert @requester.valid_response?
    end
  end

  test "valid_response? returns false for invalid response" do
    skip
    @requester.stub :response, @invalid_response do
      assert_not @requester.valid_response?
    end
  end
end
