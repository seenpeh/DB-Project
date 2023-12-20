 CREATE OR REPLACE FUNCTION query11(
    src VARCHAR(32),
    price INT
) RETURNS TABLE(dst VARCHAR(32), x int, y int) AS $$
declare
  cost_per_km int = (select net.cost_per_km from network as net where net.network_type = 'taxi');
  
BEGIN
    RETURN QUERY
    WITH RECURSIVE paths AS (
        SELECT
            src_station,
            dst_station,
            distance
        FROM station_sequence
        WHERE src = src_station AND distance * 1 < price

        UNION ALL

        SELECT
            paths.src_station,
            ss.dst_station,
            paths.distance + ss.distance
        FROM paths
        JOIN station_sequence ss ON paths.dst_station = ss.src_station
        WHERE (paths.distance + ss.distance) * 1 < price
    )
    SELECT s.sname, s.x, s.y 
    from station as s
    where s.sname in 
    (select DISTINCT dst_station FROM paths as dst);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM query11('Spadina', 10);