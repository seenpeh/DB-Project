-- Family 1
INSERT INTO citizen (fname, lname, ssn, dob, gender, breadwinner)
VALUES
  ('John', 'Smith', '111-11-1111', '1980-01-15', 'male', '111-11-1111'),
  ('Jane', 'Smith', '222-22-2222', '1982-08-25', 'female', '111-11-1111'),
  ('Bob', 'Smith', '333-33-3333', '2005-03-10', 'male', '111-11-1111'),
  ('Alice', 'Smith', '444-44-4444', '2008-11-20', 'female', '111-11-1111');

-- Family 2
INSERT INTO citizen (fname, lname, ssn, dob, gender, breadwinner)
VALUES
  ('Mike', 'Johnson', '555-55-5555', '1975-04-18', 'male', '555-55-5555'),
  ('Emily', 'Johnson', '666-66-6666', '1978-10-30', 'female', '555-55-5555'),
  ('Charlie', 'Johnson', '777-77-7777', '2003-05-15', 'male', '555-55-5555'),
  ('Sophie', 'Johnson', '888-88-8888', '2007-02-28', 'female', '555-55-5555');

-- Family 3
INSERT INTO citizen (fname, lname, ssn, dob, gender, breadwinner)
VALUES
  ('David', 'Brown', '999-99-9999', '1988-08-12', 'male', '999-99-9999'),
  ('Emma', 'Brown', '123-12-1234', '1990-12-05', 'female', '999-99-9999'),
  ('Chris', 'Brown', '234-23-2345', '2015-06-20', 'male', '999-99-9999'),
  ('Olivia', 'Brown', '345-34-3456', '2018-03-10', 'female', '999-99-9999');

-- Family 4
INSERT INTO citizen (fname, lname, ssn, dob, gender, breadwinner)
VALUES
  ('Tom', 'Williams', '456-45-4567', '1970-05-08', 'male', '456-45-4567'),
  ('Sara', 'Williams', '567-56-5678', '1973-11-15', 'female', '456-45-4567'),
  ('Tim', 'Williams', '678-67-6789', '1995-07-22', 'male', '456-45-4567'),
  ('Eva', 'Williams', '789-78-7890', '1998-12-03', 'female', '456-45-4567');

-- Family 5
INSERT INTO citizen (fname, lname, ssn, dob, gender, breadwinner)
VALUES
  ('Ryan', 'Davis', '890-89-8901', '1982-03-28', 'male', '890-89-8901'),
  ('Lily', 'Davis', '901-90-9012', '1985-09-10', 'female', '890-89-8901'),
  ('Mia', 'Davis', '012-01-2345', '2010-01-15', 'female', '890-89-8901'),
  ('Noah', 'Davis', '123-12-3456', '2013-06-20', 'male', '890-89-8901');


-- Family 6
INSERT INTO citizen (fname, lname, ssn, dob, gender, breadwinner)
VALUES
  ('Mark', 'Taylor', '111-11-2222', '1985-02-20', 'male', '111-11-2222'),
  ('Emily', 'Taylor', '111-11-3333', '1987-09-15', 'female', '111-11-2222'),
  ('Liam', 'Taylor', '111-11-4444', '2010-04-10', 'male', '111-11-2222');

-- Family 7
INSERT INTO citizen (fname, lname, ssn, dob, gender, breadwinner)
VALUES
  ('Alex', 'Miller', '222-22-5555', '1978-06-25', 'male', '222-22-5555'),
  ('Sophia', 'Miller', '222-22-6666', '1982-12-12', 'female', '222-22-5555'),
  ('Ella', 'Miller', '222-22-7777', '2005-08-05', 'female', '222-22-5555');

-- Family 8
INSERT INTO citizen (fname, lname, ssn, dob, gender, breadwinner)
VALUES
  ('Robert', 'Clark', '333-33-8888', '1990-03-18', 'male', '333-33-8888'),
  ('Olivia', 'Clark', '333-33-9999', '1993-11-30', 'female', '333-33-8888'),
  ('Mason', 'Clark', '333-33-0000', '2016-07-22', 'male', '333-33-8888');

-- Family 9
INSERT INTO citizen (fname, lname, ssn, dob, gender, breadwinner)
VALUES
  ('Ava', 'Brown', '444-44-1111', '1982-08-15', 'female', '444-44-1111'),
  ('Jackson', 'Brown', '444-44-2222', '1984-04-28', 'male', '444-44-1111'),
  ('Emma', 'Brown', '444-44-3333', '2007-01-10', 'female', '444-44-1111');




------------------------------------------money insertion

UPDATE account
SET credit = RANDOM() * (500000 - 5000) + 5000
WHERE acc_owner IN (
    -- Family 1
    '111-11-1111', '222-22-2222', '333-33-3333', '444-44-4444',
    -- Family 2
    '555-55-5555', '666-66-6666', '777-77-7777', '888-88-8888',
    -- Family 3
    '999-99-9999', '123-12-1234', '234-23-2345', '345-34-3456',
    -- Family 4
    '456-45-4567', '567-56-5678', '678-67-6789', '789-78-7890',
    -- Family 5
    '890-89-8901', '901-90-9012', '012-01-2345', '123-12-3456'
);

-- Update credit for each new family
UPDATE account
SET credit = RANDOM() * (500000 - 5000) + 5000
WHERE acc_owner IN (
  -- Family 6
  '111-11-2222', '111-11-3333', '111-11-4444',
  
  -- Family 7
  '222-22-5555', '222-22-6666', '222-22-7777',
  
  -- Family 8
  '333-33-8888', '333-33-9999', '333-33-0000',
  
  -- Family 9
  '444-44-1111', '444-44-2222', '444-44-3333'
);

---------------------------------------

-- Create houses for each family without rounding consumption values
INSERT INTO house (house_id, house_owner, water_consumption, gas_consumption, electricity_consumption, x, y, house_number, street, area)
VALUES
  -- Family 1
  ('house1', '111-11-1111', RANDOM() * (10000 - 1000) + 1000, RANDOM() * (10000 - 1000) + 1000, RANDOM() * (10000 - 1000) + 1000, ROUND(RANDOM() * 2000), ROUND(RANDOM() * 2000), 123, 'Main St', 'City A'),
  
  -- Family 2
  ('house2', '555-55-5555', RANDOM() * (10000 - 1000) + 1000, RANDOM() * (10000 - 1000) + 1000, RANDOM() * (10000 - 1000) + 1000, ROUND(RANDOM() * 2000), ROUND(RANDOM() * 2000), 456, 'Oak St', 'City B'),
  
  -- Family 3
  ('house3', '999-99-9999', RANDOM() * (10000 - 1000) + 1000, RANDOM() * (10000 - 1000) + 1000, RANDOM() * (10000 - 1000) + 1000, ROUND(RANDOM() * 2000), ROUND(RANDOM() * 2000), 789, 'Pine St', 'City C'),
  
  -- Family 4
  ('house4', '456-45-4567', RANDOM() * (10000 - 1000) + 1000, RANDOM() * (10000 - 1000) + 1000, RANDOM() * (10000 - 1000) + 1000, ROUND(RANDOM() * 2000), ROUND(RANDOM() * 2000), 1011, 'Cedar St', 'City D'),
  
  -- Family 5
  ('house5', '890-89-8901', RANDOM() * (10000 - 1000) + 1000, RANDOM() * (10000 - 1000) + 1000, RANDOM() * (10000 - 1000) + 1000, ROUND(RANDOM() * 2000), ROUND(RANDOM() * 2000), 1213, 'Maple St', 'City E');


-----------------------------------------------------------------------------

-- Give 10 citizens cars with 5 owners and 5 family members as drivers
INSERT INTO car (cid, brand, color, car_driver, car_owner)
VALUES
  ('car1', 'Toyota', 'Blue', '111-11-1111', '111-11-1111'),  -- Driver and owner are the same
  ('car2', 'Honda', 'Red', '222-22-2222', '222-22-2222'),   -- Driver and owner are the same
  ('car3', 'Ford', 'Green', '333-33-3333', '333-33-3333'),   -- Driver and owner are the same
  ('car4', 'Chevrolet', 'Silver', '555-55-5555', '444-44-4444'),  -- Driver is a family member
  ('car5', 'Nissan', 'Black', '666-66-6666', '555-55-5555'),  -- Driver is a family member
  ('car6', 'BMW', 'White', '777-77-7777', '777-77-7777'),   -- Driver is a family member
  ('car7', 'Mercedes', 'Gray', '888-88-8888', '777-77-7777'),   -- Driver is a family member
  ('car8', 'Audi', 'Yellow', '999-99-9999', '888-88-8888'),  -- Driver is a family member
  ('car9', 'Mazda', 'Orange', '012-01-2345', '999-99-9999'),  -- Driver is a family member
  ('car10', 'Hyundai', 'Purple', '123-12-3456', '012-01-2345');  -- Driver is a family member


------------------------------------------------------------------------------------

-- Create parking lots
INSERT INTO parking (pid, pname, capacity, price_per_hour, x, y, start_time, end_time)
VALUES
  ('parking1', 'Central Parking', 3, 1000, ROUND(RANDOM() * 2000), ROUND(RANDOM() * 2000), '08:00', '18:00'),
  ('parking2', 'City Plaza Parking', 6, 2000, ROUND(RANDOM() * 2000), ROUND(RANDOM() * 2000), '09:00', '20:00');

-------------------------------------------------------------------------------------

insert into station 
	values('Spadina', -100 , 2100) , ('Spadina_TTC', -80 ,1800) , ('ST_George', 60 ,1852) , ('Bay' , 102 , 1920) 
		, ('Bloor_Young' , 140 , 2014) , ('Rose_Dale' , 125 , 2167) , ('Museum' , 23 , 1693) , ('Queen_park' , 40 , 1540) , ('Wellesley' , 148 , 1606);

insert into station_sequence
	values('Spadina','Spadina_TTC', 1 ,'0:10') ,
			('Spadina_TTC','ST_George', 3 ,'0:30') ,
			('ST_George','Bay', 7 ,'1:10') ,
			('Bay','Bloor_Young', 1 ,'0:10') ,
			('Bloor_Young','Rose_Dale', 5 ,'0:50') ,
			('ST_George','Museum', 4 ,'0:40') ,
			('Museum','Queen_park', 8 ,'1:20') ,
			('Wellesley','Queen_park', 7 ,'1:10') ,
			('Wellesley','Bloor_Young', 5 ,'0:50'),
      ('Spadina','Queen_park', 11 ,'1:50') ,
			('Spadina','Bay', 9 ,'1:30') ,
			('Wellesley','Bay', 7 ,'1:10') ,
			('Bay','Rose_Dale', 3 ,'0:30');



      ------------------------------------------------------------------

-- Create networks
INSERT INTO network (network_type, cost_per_km)
VALUES
  ('taxi', 3000),
  ('bus', 1000),
  ('subway', 1500);

-- Create taxis
INSERT INTO public_transport (t_type, transport_id, driver_id)
VALUES
  ('taxi', 'taxi1', '111-11-2222'),
  ('taxi', 'taxi2', '333-33-8888'),
  ('taxi', 'taxi3', '555-55-5555'),
  ('taxi', 'taxi4', '777-77-7777'),
  ('taxi', 'taxi5', '999-99-9999');

-- Create buses
INSERT INTO public_transport (t_type, transport_id, driver_id)
VALUES
  ('bus', 'bus1', '444-44-1111'),
  ('bus', 'bus2', '666-66-6666'),
  ('bus', 'bus3', '888-88-8888'),
  ('bus', 'bus4', '012-01-2345');

-- Create subways
INSERT INTO public_transport (t_type, transport_id, driver_id)
VALUES
  ('subway', 'subway1', '222-22-6666'),
  ('subway', 'subway2', '123-12-3456');

--------------------------------------------------------

INSERT INTO path
	values('Spa->RoseD1' , 'subway'),
		  ('Spa->RoseD2' , 'taxi'),
		  ('Spa_ttc->BYoung1' , 'subway'),
		  ('Spa_ttc->BYoung2' , 'bus'),
		  ('Spa_ttc->Queen' , 'taxi'),
		  ('George->Queen' , 'bus'),
		  ('Wells->RoseD1' , 'bus'),
		  ('Wells->RoseD2' , 'taxi'),
		  ('Spa->Queen' , 'bus');
		  
INSERT INTO position_in_path
	values('Spadina' , 'Spa->RoseD1' , 'start'),
		  ('Spadina_TTC' , 'Spa->RoseD1' , 'mid'),
		  ('ST_George' , 'Spa->RoseD1' , 'mid'),
		  ('Bay' , 'Spa->RoseD1' , 'mid'),
		  ('Bloor_Young' , 'Spa->RoseD1' , 'mid'),
		  ('Rose_Dale' , 'Spa->RoseD1' , 'end'),
		  
		  ('Spadina' , 'Spa->RoseD2' , 'start'),
		  ('Bay' , 'Spa->RoseD2' , 'mid'),
		  ('Rose_Dale' , 'Spa->RoseD2' , 'end'),
		  
		  ('Spadina_TTC' , 'Spa_ttc->BYoung1' , 'start'),
		  ('ST_George' , 'Spa_ttc->BYoung1' , 'mid'),
		  ('Bay' , 'Spa_ttc->BYoung1' , 'mid'),
		  ('Bloor_Young' , 'Spa_ttc->BYoung1' , 'end'),
		  
		  ('Spadina_TTC' , 'Spa_ttc->BYoung2' , 'start'),
		  ('ST_George' , 'Spa_ttc->BYoung2' , 'mid'),
		  ('Bay' , 'Spa_ttc->BYoung2' , 'mid'),
		  ('Bloor_Young' , 'Spa_ttc->BYoung2' , 'end'),
		  
		  ('Spadina_TTC' , 'Spa_ttc->Queen' , 'start'),
		  ('Queen_park' , 'Spa_ttc->Queen' , 'end'),
		  
		  ('ST_George' , 'George->Queen' , 'start'),
		  ('Museum' , 'George->Queen' , 'mid'),
		  ('Queen_park' , 'George->Queen' , 'end'),
		  
		  ('Wellesley' , 'Wells->RoseD1' , 'start'),
		  ('Bloor_Young' , 'Wells->RoseD1' , 'mid'),
		  ('Rose_Dale' , 'Wells->RoseD1' , 'end'),
		  
		  ('Wellesley' , 'Wells->RoseD2' , 'start'),
		  ('Bay' , 'Wells->RoseD2' , 'mid'),
		  ('Rose_Dale' , 'Wells->RoseD2' , 'end'),
		  
		  ('Spadina' , 'Spa->Queen' , 'start'),
		  ('Spadina_TTC' , 'Spa->Queen' , 'mid'),
		  ('Queen_park' , 'Spa->Queen' , 'end')