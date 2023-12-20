CREATE OR REPLACE function query2(start_time timestamp , end_time timestamp) returns table(ssn varchar(16) , sum_of_expences numeric(10 , 2)) as $$
begin
	return query
		select citizen.breadwinner , sum(receipt.price)
		from (( citizen
		join account on account.acc_owner = citizen.ssn)
		join receipt on receipt.acc_id = citizen.ssn)
		where issue_time > start_time and issue_time < end_time
		group by citizen.breadwinner
		order by sum(price) desc
		limit 5;
		
end;
$$ language plpgsql;

select * from query2('2023-1-1 00:00:00', '2023-12-14 00:00:00')