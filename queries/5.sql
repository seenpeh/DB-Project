CREATE OR REPLACE function query5(x0 int , y0 int) returns table(sname varchar(16) , distance numeric(8 , 2)) as $$
begin
  return query
    SELECT
    station.sname,
    SQRT(POWER(x - x0, 2)::numeric + POWER(y - y0, 2)::numeric) AS distance
FROM
    station
ORDER BY
    distance ASC
LIMIT 5;

    
end;
$$ language plpgsql;

select * from query5(0, 0)