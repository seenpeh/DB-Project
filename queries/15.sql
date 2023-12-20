create or replace function query15(t0 timestamp, t1 timestamp, dist float) returns table(s varchar(16)) as $$
begin
  return query 
    select p.ssn as s
    from passengers as p join transportation_receipt as tr on p.receipt_id = tr.receipt_id join public_transport as pt on tr.transport_id = pt.transport_id
    where tr.start_time > t0 and tr.end_time < t1 and pt.t_type = 'bus'
    group by ssn
    having sum(find_distance(tr.path_id)) < dist;
end;
$$ language plpgsql;

select * from query15('2023-12-10 00:00:00', '2023-12-12 00:00:00', 24);
-- select * from query15('2023-12-10 00:00:00', '2023-12-12 00:00:00', 23);