SELECT receipt.acc_id, AVG(receipt.price)
FROM receipt
WHERE receipt.r_type = 'transportation'
AND receipt.acc_id in (select car_owner from car)
GROUP BY receipt.acc_id
ORDER BY AVG(receipt.price) DESC