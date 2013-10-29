class StopSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :parent_station, :lat, :lon
end
