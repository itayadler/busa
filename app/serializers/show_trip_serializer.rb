class ShowTripSerializer < ActiveModel::Serializer
  attributes :id, :direction_id
  has_one :route
  has_one :path
  has_many :stops

  def stops
    object.stop_times.sort { |a,b| a.stop_sequence <=> b.stop_sequence }.map(&:stop)
  end
end

