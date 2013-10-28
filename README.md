busa
====

An awesome Bus app

#True story
select distinct route_id from trips inner join calendars on trips.service_id = calendars.service_id inner join stop_times on stop_times.trip_id = trips.id WHERE shape_id in (39875, 39874) AND trips.shape_id is not null AND monday=true and start_date < NOW() and end_date > NOW() and stop_sequence='1' and gtfs_time_to_datetime(arrival_time, 'Asia/Jerusalem') > now() - interval '2 hours' and gtfs_time_to_datetime(arrival_time, 'Asia/Jerusalem') < now();
