class Shape < ActiveRecord::Base
  self.primary_key = 'id'
  has_one :path
end
