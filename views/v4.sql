create or replace view v4 as
(
  select * from house
  where house.house_id in 
  (select h.house_id
  from house as h
  join service_receipt as sr on sr.house_id = h.house_id
  join receipt as r on r.receipt_id = sr.receipt_id
  where extract(month from age(current_date, sr.date)) = 0 and
    extract(year from age(current_date, sr.date)) = 0 
   and sr.type = 'electricity'
  group by h.house_id
  having sum(r.price) > 500)
);

select * from v4;