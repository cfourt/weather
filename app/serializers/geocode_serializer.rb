# frozen_string_literal: true

class GeocodeSerializer < ActiveModel::Serializer
  attributes %i[title id result_type house_number_type address position access map_view scoring]

  # TODO - handle multiple items
  def zipcode
    object["items"].first.dig "address", "postalCode"
  end

end
