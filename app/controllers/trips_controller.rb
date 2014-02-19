class TripsController < ActionController::API
  def index
    lat, lon, radius = get_query_route_params(params.slice(:lat, :lon, :radius))

    if lat.blank? || lon.blank? #TODO: need to add validation to the lat and lon?
      render json: { error_message: 'Missing argument: A valid lat or lon must be specified' }, status: 400
    end

    shape_ids = []
    trip_stop_ids = []
    shape_path_time = Benchmark.realtime { shape_ids = ShapePath.close_to(lon, lat, radius).map(&:shape_id).uniq }
    stop_path_time = Benchmark.realtime { trip_stop_ids = StopPath.close_to(lon, lat, radius*2).map(&:trip_id).uniq }
    puts "shape path time #{shape_path_time}"
    puts "stop path time #{stop_path_time}"
    start_date = Calendar.arel_table[:start_date]
    end_date = Calendar.arel_table[:end_date]
    stop_sequence = StopTime.arel_table[:stop_sequence]
    weekday = Calendar.arel_table[Time.now.strftime('%A').downcase.to_sym]
    shape_id = Trip.arel_table[:shape_id]
    route_id = Route.arel_table[:id]
    trip_id = Trip.arel_table[:id]
    now = Time.now
    trips = Trip \
      .joins([:stop_times, :calendars]) \
      .includes([:stop_times, :route]) \
      .where(shape_id.in(shape_ids).or(trip_id.in(trip_stop_ids))) \
      .where(weekday.eq(true)) \
      .where(start_date.lt(now)) \
      .where(end_date.gt(now)) \
      .where(stop_sequence.eq(1)) \
      .where("gtfs_time_to_datetime(stop_times.arrival_time, 'Asia/Jerusalem') > now() - interval '2 hours' AND gtfs_time_to_datetime(stop_times.arrival_time, 'Asia/Jerusalem') < now()") 
    result = trips.to_a
    result_by_shape_ids = result.reject { |t| t.shape_id == nil }.uniq(&:shape_id)
    result_by_trip_id = result.select { |t| t.shape_id == nil }.uniq { |t| t.route.route_desc }
    result = result_by_shape_ids + result_by_trip_id
    render json: result, root: false
  end

  def show
    render json: Trip.includes([:stop_times]).where(id: params[:trip_id]).first, serializer: ShowTripSerializer, root: false
  end

  private

  def get_query_route_params(query_params)
    lat = query_params[:lat]
    lon = query_params[:lon]
    radius = query_params[:radius] || 100 #default is 100 meters
    [lat, lon, radius.to_i]
  end
end


