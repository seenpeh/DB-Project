create or replace view v1 as
(
select * from citizen
where ssn in 
(select public_transport.driver_id
from transportation_receipt join public_transport
on transportation_receipt.transport_id = public_transport.transport_id
where public_transport.t_type = 'bus' and 
extract(month from age(current_date, transportation_receipt.end_time)) = 0 and
extract(year from age(current_date, transportation_receipt.end_time)) = 0 
group by public_transport.driver_id 
-- علت تقسیم ۳۰ در خط پایین این است که متوسط در ماه خواسته شده است. ما گمان می‌کنیم منظور از متوسط، همان در روز است.
having sum(find_distance(transportation_receipt.path_id)) /30 > 1)
)

select * from v1;