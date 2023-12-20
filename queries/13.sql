create or replace function query13(t0 timestamp , t1 timestamp) returns table(fname varchar(16) ,lname varchar(16) ,ssn varchar(16)) as $$
begin
  return query
    select ct.fname, ct.lname, ct.ssn
        from citizen as ct
        where ct.ssn in 
    (select DISTINCT c1.car_owner 
    from parking_receipt as pr join car as c1 on c1.cid = pr.cid
    where pr.start_time > t0 and pr.end_time < t1
    and date(pr.start_time) + 1 in 
    (select date(pr2.start_time)
    from parking_receipt as pr2 join car as c2 on c2.cid = pr2.cid
    where pr2.start_time > t0 and pr2.end_time < t1));
end;  
$$ language plpgsql;

select * from query13('2022-1-1 00:00:00', '2023-12-13 10:10:10')

-- to check if it works
-- select * from parking_receipt order by cid, start_time