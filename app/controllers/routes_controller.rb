class RoutesController < ActionController::API
  def index
    lat, lon = [params[:lat], params[:lon]]
    start_date = Calendar.arel_table[:start_date]
    end_date = Calendar.arel_table[:end_date]
    stop_sequence = StopTime.arel_table[:stop_sequence]
    weekday = Calendar.arel_table[Time.now.strftime('%A').downcase.to_sym]
    shape_id = Trip.arel_table[:shape_id]
    route_id = Route.arel_table[:id]
    Route \
      .select(route_id).distinct \
      .joins([:trips => [:stop_times, :calendars]]) \
      .where(shape_id.in([39875, 39874])) \
      .where(shape_id.not_eq(nil)) \
      .where(weekday.eq(true)) \
      .where(start_date.lt(Time.now)) \
      .where(end_date.gt(Time.now)) \
      .where(stop_sequence.eq(1)) \
      .where("gtfs_time_to_datetime(stop_times.arrival_time, 'Asia/Jerusalem') > now() - interval '2 hours' AND gtfs_time_to_datetime(stop_times.arrival_time, 'Asia/Jerusalem') < now()") 
  end
end

