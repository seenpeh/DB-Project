create or replace function query3(t0 timestamp, t1 timestamp) returns table(driver_id varchar(16), sum_d int) as $$
begin
  return query 
    select pt.driver_id, sum(find_distance(tr.path_id)):: integer as sum_d 
    from public_transport as pt join transportation_receipt as tr on pt.transport_id = tr.transport_id
    where tr.start_time > t0 and tr.end_time < t1
    group by pt.driver_id
    order by sum_d desc
    limit 5;
end;
$$ language plpgsql;

select * from query3('2023-10-10 10:10:10', '2023-12-13 23:59:59');