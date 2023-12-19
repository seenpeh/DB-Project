create function query2(start_time timestamp , end_time timestamp) returns table(ssn varchar(16) , sum_of_expences numeric(10 , 2)) as $$
begin
	return query
		select ssn , sum(price)
		from (( citizen
		join account on account.ssn = citizen.ssn)
		join receipt on receipt.ssn = citizen.ssn)
		where issue_time > start_time and issue_time < end_time
		group by ssn
		order by sum(price)
		limit 5;
		
end;
$$ language plpgsql;
