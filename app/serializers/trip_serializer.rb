class TripSerializer < ActiveModel::Serializer
  attributes :id, :shape_id, :origin, :destination
  has_one :route

  attr_accessor :_stops

  def origin
    StopTime.includes(:stop).where(trip_id: object.id).where(stop_sequence: 1).first.stop.name
  end

  def destination
    max_seq = StopTime.includes(:stop).where(trip_id: object.id).maximum(:stop_sequence)
    StopTime.includes(:stop).where(trip_id: object.id).where(stop_sequence: max_seq).first.stop.name
  end

  def stops
    self._stops ||= object.stop_times.sort_by { |st| st.stop_sequence }.map(&:stop)
  end

end

