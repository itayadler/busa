class ShowTripSerializer < ActiveModel::Serializer
  attributes :id
  has_one :route
  has_one :path
  has_many :stops

  def stops
    object.stops.sort { |a,b| a.stop_time.stop_sequence <=> b.stop_time.stop_sequence }
  end
end

