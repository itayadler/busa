class TripSerializer < ActiveModel::Serializer
  attributes :id, :shape_id
  has_one :route
end

