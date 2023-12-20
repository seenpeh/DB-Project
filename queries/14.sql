CREATE OR REPLACE FUNCTION min_distance_between_stations(
    src VARCHAR(32),
    dst VARCHAR(32)
) RETURNS INT AS $$
DECLARE
    min_distance INT;
BEGIN
    WITH RECURSIVE paths AS (
        SELECT
            src_station,
            dst_station,
            distance
        FROM station_sequence
        WHERE src = src_station
        
        UNION ALL
        
        SELECT
            paths.src_station,
            station_sequence.dst_station,
            paths.distance + station_sequence.distance
        FROM paths
        JOIN station_sequence ON paths.dst_station = station_sequence.src_station
          AND paths.distance + station_sequence.distance < 20
    )
    SELECT MIN(distance) INTO min_distance
    FROM paths
    WHERE dst_station = dst;

    RETURN min_distance;
END;
$$ LANGUAGE plpgsql;

select * from min_distance_between_stations('Spadina','Bay');
-- The answer must be 9 instead of 11