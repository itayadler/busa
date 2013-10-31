class TripSerializer < ActiveModel::Serializer
  attributes :id, :shape_id, :origin, :destination
  has_one :route

  attr_accessor :_stops

  def origin
    self.stops.first.name
  end

  def destination
    self.stops.last.name
  end

  def stops
    self._stops ||= object.stop_times.sort { |a,b| a.stop_sequence <=> b.stop_sequence }.map(&:stop)
  end

end

