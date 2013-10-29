class StopTime < ActiveRecord::Base
  self.primary_key = 'trip_id'
  belongs_to :trip
  belongs_to :stop
end
