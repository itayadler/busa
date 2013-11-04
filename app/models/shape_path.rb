class ShapePath < ActiveRecord::Base
  belongs_to :shape
  scope :close_to, ->(longitude,latitude,distance_in_meters = 1000) {
    where(%{
      ST_DWithin(
        ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
        shape_paths.path,
        %d
      )
    } % [longitude, latitude, distance_in_meters])
  }
end
