CREATE OR REPLACE FUNCTION query10(citizen_ssn character varying)
RETURNS TABLE (month_year character varying, total_expense numeric) AS
$$
BEGIN
    RETURN QUERY
    SELECT 
        TO_CHAR(issue_time, 'YYYY-MM')::character varying AS month_year,
        SUM(price) AS total_expense
    FROM receipt
    WHERE acc_id IN (
        SELECT acc_owner
        FROM account
        WHERE acc_owner = citizen_ssn
    )
    GROUP BY TO_CHAR(issue_time, 'YYYY-MM')
    ORDER BY TO_CHAR(issue_time, 'YYYY-MM') DESC;

END;
$$
LANGUAGE plpgsql;

SELECT * FROM query10('111-11-1111');

-- to check if it works:
-- select * from receipt
-- where receipt.acc_id = '111-11-1111'
-- order by issue_time