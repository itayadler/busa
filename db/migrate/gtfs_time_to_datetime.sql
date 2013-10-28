CREATE OR REPLACE FUNCTION GTFS_Time_To_DateTime (time_text text, tz text) returns timestamp with time zone as $$
  DECLARE
    hour integer;
    new_time text;
    result timestamp with time zone;
  BEGIN
    hour := cast(split_part(time_text, ':', 1) as integer);
    IF hour >= 24 THEN
      new_time := (hour - 24) || ':' || split_part(time_text, ':', 2) || ':' || split_part(time_text, ':', 3);
      result := timezone(tz, cast(cast(current_date as text) || ' ' || new_time as timestamp));
      result := result + interval '1 day';
    ELSE
      result := timezone(tz, cast(cast(current_date as text) || ' ' || time_text as timestamp));
    END IF;
    RETURN result;
  END;
$$ LANGUAGE plpgsql;
