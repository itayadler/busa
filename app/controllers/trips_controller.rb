class TripsController < ActionController::API
  def index
    lat, lon, radius = get_query_route_params(params.slice(:lat, :lon, :radius))

    if lat.blank? || lon.blank? #TODO: need to add validation to the lat and lon?
      render json: { error_message: 'Missing argument: A valid lat or lon must be specified' }, status: 400
    end

    shape_ids = Path.close_to(lon, lat, radius).map(&:shape_id)
    start_date = Calendar.arel_table[:start_date]
    end_date = Calendar.arel_table[:end_date]
    stop_sequence = StopTime.arel_table[:stop_sequence]
    weekday = Calendar.arel_table[Time.now.strftime('%A').downcase.to_sym]
    shape_id = Trip.arel_table[:shape_id]
    route_id = Route.arel_table[:id]
    now = Time.now
    trips = Trip \
      .joins([:stop_times, :calendars]) \
      .where(shape_id.in(shape_ids)) \
      .where(shape_id.not_eq(nil)) \
      .where(weekday.eq(true)) \
      .where(start_date.lt(now)) \
      .where(end_date.gt(now)) \
      .where(stop_sequence.eq(1)) \
      .where("gtfs_time_to_datetime(stop_times.arrival_time, 'Asia/Jerusalem') > now() - interval '2 hours' AND gtfs_time_to_datetime(stop_times.arrival_time, 'Asia/Jerusalem') < now()") 
    render json: trips, root: false
  end

  def show
    render json: Trip.includes(:stop_times => :stop).where(id: params[:id]).first, serializer: ShowTripSerializer, root: false
  end

  private

  def get_query_route_params(query_params)
    lat = query_params[:lat]
    lon = query_params[:lon]
    radius = query_params[:radius] || 100 #default is 100 meters
    [lat, lon, radius]
  end
end


