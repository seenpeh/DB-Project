create or replace view v3 as
(
    select pt.transport_id, count(DISTINCT(p.ssn))
    from public_transport as pt join transportation_receipt as tr on pt.transport_id = tr.transport_id
    join passengers as p on tr.receipt_id = p.receipt_id
    where pt.t_type = 'subway'
    group by pt.transport_id
);

select * from v3;