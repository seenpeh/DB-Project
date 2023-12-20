create or replace function query_6(t0 timestamp, t1 timestamp) returns table(id varchar, count integer) as $$
begin
  return query 
    select passengers.ssn, count(DISTINCT position_in_path.sname)::integer as count
    from passengers join transportation_receipt on passengers.receipt_id = transportation_receipt.receipt_id 
    join position_in_path on transportation_receipt.path_id = position_in_path.path_id
    where transportation_receipt.start_time > t0 and transportation_receipt.end_time < t1 
    and position_in_path.pos in ('start', 'end')
    group by passengers.ssn
    order by count desc
    limit 5;
end;
$$ language plpgsql;

select * from query_6('2023-1-1 00:00:00', '2023-12-13 10:12:14')

-- to check if it works:
-- insert into passengers values(133 , '999-99-9999');

-- update transportation_receipt
-- set  start_time='2023-11-11 22:22:00',
-- end_time='2023-11-11 23:22:00',
-- path_id='Spa_ttc->BYoung1',
-- transport_id='subway1'
-- WHERE receipt_id = 133;