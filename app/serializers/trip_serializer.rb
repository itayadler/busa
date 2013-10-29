class TripSerializer < ActiveModel::Serializer
  attributes :id
  has_one :route
end

