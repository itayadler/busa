class Trip < ActiveRecord::Base
  self.primary_key = :id
  has_many :calendars, primary_key: :service_id, foreign_key: :service_id
  has_many :stop_times
end
