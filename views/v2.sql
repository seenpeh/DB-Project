create or replace view v2 as
(
    select pp.sname, count(p.ssn)
    from transportation_receipt as tr join position_in_path as pp on tr.path_id = pp.path_id 
    join passengers as p on p.receipt_id = tr.receipt_id

    where
	(pp.pos = 'start' or pp.pos = 'end')
	and extract(day from age(current_date, tr.end_time)) = 0 and
    extract(month from age(current_date, tr.end_time)) = 0 and
    extract(year from age(current_date, tr.end_time)) = 0 
    group by pp.sname
  
);

select * from v2;