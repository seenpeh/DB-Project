

-- when a car enters parking
CREATE OR REPLACE FUNCTION create_parking_receipt()
RETURNS TRIGGER AS $$
DECLARE acc_id_var varchar(16);
BEGIN

IF (SELECT capacity FROM parking WHERE NEW.pid = parking.pid) <= 0 THEN
 RAISE EXCEPTION 'THE PARKING IS FULL, SORRY';
 return null;
END IF;

IF (SELECT start_time FROM parking WHERE NEW.pid = parking.pid) > (SELECT CAST(NEW.start_time AS TIME))
OR (SELECT end_time FROM parking WHERE NEW.pid = parking.pid) < (SELECT CAST(NEW.end_time AS TIME))
 THEN
 RAISE EXCEPTION 'NOT IN WORKING HOURS OF THE PARKING';
 return null;
END IF;

IF NEW.start_time IS NOT NULL THEN

 
 acc_id_var := (SELECT car_driver FROM car WHERE cid = NEW.cid);
 
 INSERT INTO receipt
 VALUES (NEW.receipt_id, NULL , NULL ,'parking', acc_id_var);

 UPDATE parking
 SET capacity = capacity - 1
 WHERE pid = NEW.pid;
  
END IF;
RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER parking_receipt_trigger
BEFORE INSERT ON parking_receipt
FOR EACH ROW
EXECUTE FUNCTION create_parking_receipt();




----------------------------------------------



-- when a car leaves parking
CREATE OR REPLACE FUNCTION create_finish_parking()
RETURNS TRIGGER AS $$
DECLARE money_amount numeric(10 , 2);
BEGIN

	IF NEW.end_time is not null THEN
	
		money_amount := (SELECT 
  			ceiling (  (EXTRACT(HOUR FROM (AGE(NEW.end_time , NEW.start_time))) * 3600
  			+ EXTRACT(Minute FROM (AGE(NEW.end_time, NEW.start_time))) * 60
  			+ EXTRACT(second FROM (AGE(NEW.end_time, NEW.start_time)))) / 3600.0) 
						 * price_per_hour FROM parking where parking.pid = new.pid);

		UPDATE receipt
			SET issue_time = NEW.end_time , price = money_amount
			where NEW.receipt_id = receipt_id;
		
		UPDATE parking 
			SET capacity = capacity + 1
			where NEW.pid = pid;
	END IF;
RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER finish_parking_trigger
AFTER UPDATE ON parking_receipt
FOR EACH ROW
EXECUTE FUNCTION create_finish_parking();
---------------------------------------------5

CREATE OR REPLACE FUNCTION check_time_order()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.start_time >= NEW.end_time THEN
        RAISE EXCEPTION 'Starting time must be before ending time.';
		RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER ensure_time_order_parking_receipt
BEFORE INSERT OR UPDATE ON parking_receipt
FOR EACH ROW
EXECUTE FUNCTION check_time_order();

CREATE OR REPLACE TRIGGER ensure_time_order_parking
BEFORE INSERT OR UPDATE ON parking
FOR EACH ROW
EXECUTE FUNCTION check_time_order();

CREATE OR REPLACE TRIGGER ensure_time_order_transportation_receipt
BEFORE INSERT OR UPDATE ON transportation_receipt
FOR EACH ROW
EXECUTE FUNCTION check_time_order();

--------------------------------------------------------


CREATE OR REPLACE FUNCTION deduct_credit_after_receipt()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.price is not null THEN
		IF NEW.r_type = 'parking' and (SELECT credit FROM account WHERE acc_owner = NEW.acc_id) < NEW.price THEN
			
			DECLARE second_payer varchar(16);
			begin
				SELECT car_owner
				FROM parking_receipt
				where new.receipt_id = receipt_id;
			end;
			
			UPDATE account
			SET credit = credit - NEW.price
			WHERE acc_owner = second_payer;
			
		ELSE
		
			UPDATE account
			SET credit = credit - NEW.price
			WHERE acc_owner = NEW.acc_id;
			
		END IF;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER deduct_credit_trigger
AFTER UPDATE OR INSERT ON receipt
FOR EACH ROW
EXECUTE FUNCTION deduct_credit_after_receipt();


---------------------------------------------------------2

CREATE OR REPLACE FUNCTION check_credit_parking()
RETURNS TRIGGER AS $$
BEGIN
 
  IF (SELECT credit FROM car join account on car.car_driver = account.acc_owner WHERE NEW.c_id = c_id) > 0 THEN
    RETURN NEW;
	
  ELSE
    RAISE EXCEPTION 'Not enough money!';
    RETURN NULL;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_credit_parking
BEFORE INSERT ON parking_receipt
FOR EACH ROW
EXECUTE FUNCTION check_credit_parking();

---------

CREATE OR REPLACE FUNCTION check_credit_transportation()
RETURNS TRIGGER AS $$
BEGIN
 
  IF (SELECT credit FROM account WHERE NEW.ssn = acc_owner) > 0 THEN
    RETURN NEW;
	
  ELSE
    RAISE EXCEPTION 'Not enough money!';
    RETURN NULL;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_credit_transportation
BEFORE INSERT ON passengers
FOR EACH ROW
EXECUTE FUNCTION check_credit_transportation();

---------------------------------------------------------------

CREATE OR REPLACE FUNCTION create_acc()
RETURNS TRIGGER AS $$
BEGIN
	INSERT into account
		values(0 , NEW.ssn);
	
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_acc_trigger
AFTER INSERT ON citizen
FOR EACH ROW
EXECUTE FUNCTION create_acc();


-----------------------------------------------------------------
CREATE OR REPLACE FUNCTION create_service_receipt()
RETURNS TRIGGER AS $$
DECLARE service_cost numeric(10 , 2);
DECLARE h_owner varchar(16);
BEGIN
	h_owner := (SELECT house_owner FROM house WHERE house_id = NEW.house_id);
	
	if NEW.type = 'water' THEN
		service_cost := (SELECT water_consumption FROM house WHERE house_id = NEW.house_id);
		UPDATE house SET water_consumption = 0 WHERE house_id = NEW.house_id;
	end if;
	
	if NEW.type = 'gas' THEN
		service_cost := (SELECT gas_consumption FROM house WHERE house_id = NEW.house_id);
		UPDATE house SET gas_consumption = 0 WHERE house_id = NEW.house_id;
	end if;
	
	if NEW.type = 'electricity' THEN
		service_cost := (SELECT electricity_consumption FROM house WHERE house_id = NEW.house_id);
		UPDATE house SET electricity_consumption = 0 WHERE house_id = NEW.house_id;
	end if;
	
	INSERT INTO receipt
 	VALUES (NEW.receipt_id, service_cost , current_timestamp , 'service' , h_owner);


RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER service_receipt_trigger
BEFORE INSERT ON service_receipt
FOR EACH ROW
EXECUTE FUNCTION create_service_receipt();




----------------------------------------------------------------------------------

-- when a passenger is created
CREATE OR REPLACE FUNCTION create_passengers_receipt()
RETURNS TRIGGER AS $$
BEGIN

INSERT INTO receipt (r_type, receipt_id, acc_id)
VALUES ('transportation', NEW.receipt_id, NEW.ssn);

INSERT INTO transportation_receipt(receipt_id)
VALUES (NEW.receipt_id);

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER passengers_receipt_trigger
BEFORE INSERT ON passengers
FOR EACH ROW
EXECUTE FUNCTION create_passengers_receipt();



-- when a transportation is updated
create OR REPLACE function find_distance(input_path_id integer) returns int as $$
declare
  output int;
  current_row record;
begin
  output := 0;
  
  for current_row in select distance from station_sequence where src_station in (select pip.sname from position_in_path as pip where pip.path_id = input_path_id) and dst_station in (select pip.sname from position_in_path as pip where pip.path_id = input_path_id)
    loop
    output := output + current_row.distance;
    end loop;
  
  return output;
end;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION create_transportation_receipt()
RETURNS TRIGGER AS $$
DECLARE
    money_amount NUMERIC(10, 2);
BEGIN
   IF NEW.end_time is not null THEN
   		money_amount := find_distance(NEW.path_id) * (SELECT price_per_km FROM transport join network on public_transport.t_type = network.network_type where NEW.transport_id = transport_id);
   		
		UPDATE receipt
			SET issue_time = NEW.end_time , price = money_amount
			where NEW.receipt_id = receipt_id;
			
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER transportation_receipt_trigger
BEFORE UPDATE ON transportation_receipt
FOR EACH ROW
EXECUTE FUNCTION create_transportation_receipt();
