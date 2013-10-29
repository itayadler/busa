class StopSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :parent_station, :lat, :lon, :stop_sequence

  def stop_sequence
    object.stop_time.stop_sequence
  end
end
