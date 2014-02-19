class StopSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :parent_station, :lat, :lon, :city

  def city
    object.stop_city.city
  end
end
