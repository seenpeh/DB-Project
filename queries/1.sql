    SELECT count(*) FROM (
SELECT start_time
FROM (transportation_receipt as tr join passengers on tr.receipt_id = passengers.receipt_id) join citizen on citizen.ssn = passengers.ssn
WHERE transport_id in
		(SELECT pt.transport_id
		FROM public_transport AS pt
		WHERE pt.driver_id = '111-11-2222')
		AND tr.start_time > '2022-1-1 00:00:00' AND tr.end_time < '2024-1-1 00:00:00'
GROUP BY start_time
HAVING (count(gender = 'female')/count(gender = 'male')) >= 0.6
  ) AS subquery