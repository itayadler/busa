class Path < ActiveRecord::Base
  belongs_to :shape
  scope :close_to, ->(latitude,longitude,distance_in_meters = 1000) {
    where(%{
      ST_DWithin(
        ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
        paths.path,
        %d
      )
    } % [longitude, latitude, distance_in_meters])
  }
end
