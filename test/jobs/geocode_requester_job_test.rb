require "test_helper"

class GeocodeRequesterJobTest < ActiveJob::TestCase

  def setup
    # TODO
    # make new fixture for a valid address, invalid address, and postal code
    # Mock the Requester, and possible responses, valid and invalid
  end

  test "can initialize and request zip code for valid record" do
    skip
    #   assert match between response and valid response
  end

  test "can handle invalid record or malformed address" do
    skip
    #   not sure about this one yet
  end

  test "serialized_response should respond to #zipcode" do
    skip
    # should be a child of Serializer and contain fields in it's @object
  end

  test "network or server error is handled" do
    skip
  end
end
