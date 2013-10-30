class ShowTripSerializer < ActiveModel::Serializer
  attributes :id, :direction_id, :stops, :shape_id
  has_one :route
  has_one :path

  def stops
    object.stop_times.sort { |a,b| a.stop_sequence <=> b.stop_sequence }.map do |stop_time|
      json = stop_time.as_json.merge(stop_time.stop.as_json).except("trip_id", "departure_time")
      json["arrival_time"] = gtfs_time(json["arrival_time"])
      json
    end
  end

  def gtfs_time(time_str)
    hours, minutes, seconds = time_str.split(':')
    hours_int = hours.to_i
    if hours_int > 23
      Time.parse("#{hours_int - 24}:#{minutes}:#{seconds}") + 1.day
    else
      Time.parse(time_str)
    end
  end
end

