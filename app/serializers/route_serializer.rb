class RouteSerializer < ActiveModel::Serializer
  attributes :id, :route_short_name, :route_long_name, :route_desc, :route_type
  has_one :agency
end

