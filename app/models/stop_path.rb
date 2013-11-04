class StopPath < ActiveRecord::Base
  belongs_to :trip
  scope :close_to, ->(longitude,latitude,distance_in_meters = 1000) {
    where(%{
      ST_DWithin(
        stop_paths.points,
        ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
        %d
      )
    } % [longitude, latitude, distance_in_meters])
  }
end

