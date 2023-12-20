create function query4(t0 timestamp , t1 timestamp, wanted varchar(32)) returns table(count int, month numeric, year numeric) as $$
begin
  return query
    select count(*)::integer, EXTRACT(MONTH FROM transportation_receipt.start_time) AS month, 
  EXTRACT(YEAR FROM transportation_receipt.start_time) as year
    from transportation_receipt join path on transportation_receipt.path_id = path.path_id
    where transportation_receipt.start_time > t0 and transportation_receipt.end_time < t1 and 
    transportation_receipt.path_id in 
    (select path_id from position_in_path
    where position_in_path.sname = wanted and position_in_path.pos = 'start'
    union
    select path_id from position_in_path
    where position_in_path.sname = wanted and position_in_path.pos = 'end')
  group by month, year;
end;
$$ language plpgsql;

select * from query4('2023-07-1 00:00:00', '2024-1-1 00:00:00', 'Wellesley')

-- to check if it works:
-- select * from transportation_receipt order by end_time