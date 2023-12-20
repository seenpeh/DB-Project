create or replace function query8(t0 timestamp , t1 timestamp, parking_id varchar(16)) returns table(count int) as $$
begin
  return query
    select count(DISTINCT CONCAT(car.brand, ',', car.color))::integer
    from (( parking_receipt
    join parking on parking_receipt.pid = parking.pid)
        join car on car.cid = parking_receipt.cid)
    where parking_receipt.start_time > t0 and parking_receipt.end_time < t1
        and parking_id = parking.pid;
end;
$$ language plpgsql;

select * from query8('2023-10-10 00:00:00', '2023-12-13 00:00:00', 'parking1')