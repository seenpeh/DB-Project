create or replace function query7(start_time_var timestamp , end_time_var timestamp) returns table(ssn varchar(16)) as $$
begin
  return query
    select passengers.ssn
        from ((transportation_receipt
        join public_transport on public_transport.transport_id = transportation_receipt.transport_id)
        join passengers on passengers.receipt_id = transportation_receipt.receipt_id)
        where transportation_receipt.start_time > start_time_var and transportation_receipt.end_time < end_time_var
    group by passengers.ssn
        having SUM(CASE WHEN public_transport.t_type = 'subway' THEN transportation_receipt.end_time - transportation_receipt.start_time ELSE '0' END) >
                SUM(CASE WHEN public_transport.t_type = 'bus' THEN transportation_receipt.end_time - transportation_receipt.start_time ELSE '0' END);
    
end;
$$ language plpgsql;

select * from query7('2023-12-07 00:00:00', '2023-12-12 23:59:59');

-- to check if it works well:

-- select * from query7('2023-12-07 00:00:00', '2023-12-10 23:59:59');

-- select ssn, end_time - start_time, passengers.receipt_id, transport_id, end_time AS issue_time
-- from passengers join transportation_receipt on passengers.receipt_id = transportation_receipt.receipt_id
-- WHERE passengers.ssn in (select * from query7('2023-12-07 00:00:00', '2023-12-10 23:59:59'))
-- AND ((transport_id LIKE 'subway%') OR (transport_id LIKE 'bus%'))
-- order by ssn, issue_time