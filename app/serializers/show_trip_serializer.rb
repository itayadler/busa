class ShowTripSerializer < ActiveModel::Serializer
  attributes :id, :direction_id, :stops
  has_one :route
  has_one :path

  def stops
    object.stop_times.sort { |a,b| a.stop_sequence <=> b.stop_sequence }.map do |stop_time|
      stop_time.as_json.merge(stop_time.stop.as_json).except("trip_id", "departure_time")
    end
  end
end

