class Trip < ActiveRecord::Base
  self.primary_key = :id
  has_many :calendars, primary_key: :service_id, foreign_key: :service_id
  has_many :stop_times
  has_many :stops, :through => :stop_times
  belongs_to :shape
  belongs_to :route
  has_one :path, :through => :shape
end
