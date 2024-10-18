require "test_helper"

class ForecastRequesterJobTest < ActiveJob::TestCase

  def setup
    # TODO
    # make new fixture for a valid address, invalid address, and postal code
    # Mock the Requester, and responses

  end

  test "can initialize and request forecast for valid address" do
    skip
  #   assert match between response and valid response
  end

  test "can initialize and handle invalid address" do
    skip
    #   not sure about this one yet
  end

  test "serialized_response" do
    skip
    # should be a child of Serializer and contain fields in it's @object
  end

  test "network or server error is handled" do
    skip
  end
end
