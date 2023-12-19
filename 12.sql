select citizen.ssn , avg(price)
  FROM ((((( citizen 
    join car on car.car_owner = citizen.ssn)
    join passengers on citizen.ssn = passengers.ssn)
    join transportation on transportation.t_id = passengers.t_id)
    join transportation_receipt on transportation_receipt.t_id = transportation.t_id)
    join receipt on receipt.receipt_id = transportation_receipt.receipt_id)
    
  group by citizen.ssn