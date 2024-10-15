class AddressValidator < ActiveModel::Validator
  def validate(record)
    return if record.address =~ /^[A-Za-z0-9'\.\-\s\,]/

    record.errors.add(:address, "Must be a valid address which cannot contain any symbols")
  end
end
