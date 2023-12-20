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
  ('car9', 'Mazda', 'Orange', '012-01-2345', '999-99-9999'),
  ('car10', 'Hyundai', 'Purple', '123-12-3456', '012-01-2345'),
  ('car11', 'Hyundai', 'Blue', '222-22-5555', '222-22-5555'),
  ('car12', 'Hyundai', 'Blue', '333-33-0000', '333-33-0000');  -- Driver is a family member;  -- Driver is a family member


------------------------------------------------------------------------------------

-- Create parking lots
INSERT INTO parking (pid, pname, capacity, price_per_hour, x, y, start_time, end_time)
VALUES
  ('parking1', 'Central Parking', 5, 1000, ROUND(RANDOM() * 2000), ROUND(RANDOM() * 2000), '08:00', '18:00'),
  ('parking2', 'City Plaza Parking', 6, 2000, ROUND(RANDOM() * 2000), ROUND(RANDOM() * 2000), '09:00', '20:00');

-------------------------------------------------------------------------------------

insert into station 
	values('Spadina', -100 , 2100) , ('Spadina_TTC', -80 ,1800) , ('ST_George', 60 ,1852) , ('Bay' , 102 , 1920) 
		, ('Bloor_Young' , 140 , 2014) , ('Rose_Dale' , 125 , 2167) , ('Museum' , 23 , 1693) , ('Queen_park' , 40 , 1540) , ('Wellesley' , 148 , 1606) ,
    ('Oak' , -50 , 2006) , ('Glory' , 150 , 20010) , ('Peace' , 20 , 1670);

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
      ('Spadina_TTC','Peace', 5 ,'0:50') ,
      ('Peace','Queen_park', 6 ,'1:00') ,
			('Spadina','Oak', 5 ,'0:50') ,
      ('Oak','Bay', 4 ,'0:40') ,
			('Wellesley','Bay', 7 ,'1:10') ,
			('Bay','Glory', 1 ,'0:10'),
      ('Glory','Rose_Dale', 3 ,'0:30');



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
		  ('Oak' , 'Spa->RoseD2' , 'mid'),
      ('Bay' , 'Spa->RoseD2' , 'mid'),
      ('Glory' , 'Spa->RoseD2' , 'mid'),
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
      ('Peace' , 'Spa_ttc->Queen' , 'mid'),
		  ('Queen_park' , 'Spa_ttc->Queen' , 'end'),
		  
		  ('ST_George' , 'George->Queen' , 'start'),
		  ('Museum' , 'George->Queen' , 'mid'),
		  ('Queen_park' , 'George->Queen' , 'end'),
		  
		  ('Wellesley' , 'Wells->RoseD1' , 'start'),
		  ('Bloor_Young' , 'Wells->RoseD1' , 'mid'),
		  ('Rose_Dale' , 'Wells->RoseD1' , 'end'),
		  
		  ('Wellesley' , 'Wells->RoseD2' , 'start'),
		  ('Bay' , 'Wells->RoseD2' , 'mid'),
      ('Glory' , 'Wells->RoseD2' , 'mid'),
		  ('Rose_Dale' , 'Wells->RoseD2' , 'end'),
		  
		  ('Spadina' , 'Spa->Queen' , 'start'),
		  ('Spadina_TTC' , 'Spa->Queen' , 'mid'),
      ('Peace' , 'Spa->Queen' , 'mid'),
		  ('Queen_park' , 'Spa->Queen' , 'end');




-- insert into passengers
-- 	values(4 , '444-44-3333');

-- update transportation_receipt
-- 	set  start_time='2022-10-11 22:22:00' , end_time='2022-10-11 23:22:00' , path_id='Spa->RoseD2' , transport_id='taxi1'

-- insert into parking_receipt
-- 	values(55 , 'parking1' , 'car4' , '2922-11-22 11:11:11' , null)

-- update parking_receipt
-- set end_time = '2922-11-22 13:11:11'
-- where receipt_id = 55

---------------------------------------------------------------------
-- create transportations
insert into passengers values(10 , '444-44-3333');
insert into passengers values(11 , '222-22-2222');
insert into passengers values(12 , '222-22-2222');
insert into passengers values(13 , '333-33-3333');
insert into passengers values(14 , '333-33-3333');
insert into passengers values(15 , '333-33-3333');
insert into passengers values(16 , '999-99-9999');
insert into passengers values(17 , '567-56-5678');
insert into passengers values(18 , '111-11-3333');
insert into passengers values(19 , '444-44-1111');
insert into passengers values(100 , '111-11-1111');
insert into passengers values(101 , '222-22-2222');
insert into passengers values(102 , '333-33-3333');
insert into passengers values(103 , '567-56-5678');
insert into passengers values(104 , '345-34-3456');
insert into passengers values(105 , '123-12-3456');
insert into passengers values(106 , '111-11-4444');
insert into passengers values(107 , '222-22-5555');
insert into passengers values(108 , '333-33-8888');
insert into passengers values(109 , '222-22-7777');
insert into passengers values(110 , '123-12-3456');
insert into passengers values(111 , '111-11-1111');
insert into passengers values(112 , '222-22-2222');
insert into passengers values(113 , '333-33-3333');
insert into passengers values(114 , '777-77-7777');
insert into passengers values(115 , '888-88-8888');
insert into passengers values(116 , '999-99-9999');
insert into passengers values(117 , '777-77-7777');
insert into passengers values(118 , '888-88-8888');
insert into passengers values(119 , '999-99-9999');
insert into passengers values(120 , '123-12-1234');
insert into passengers values(121 , '333-33-0000');
insert into passengers values(122 , '333-33-0000');
insert into passengers values(123 , '333-33-0000');
insert into passengers values(124 , '333-33-0000');
insert into passengers values(125 , '333-33-0000');
insert into passengers values(126 , '444-44-1111');
insert into passengers values(127 , '444-44-1111');
insert into passengers values(128 , '444-44-1111');
insert into passengers values(129 , '444-44-1111');
insert into passengers values(130 , '444-44-1111');


update transportation_receipt
set  start_time='2023-10-11 22:22:00',
end_time='2023-10-11 23:22:00',
path_id='Spa->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '10';

update transportation_receipt
set  start_time='2023-10-10 10:22:00',
end_time='2023-10-10 10:57:20',
path_id='Spa_ttc->Queen',
transport_id='taxi2'
WHERE receipt_id = '11';

update transportation_receipt
set  start_time='2023-11-12 14:20:00',
end_time='2023-11-12 17:22:30',
path_id='Wells->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '12';

update transportation_receipt
set  start_time='2023-09-16 13:59:45',
end_time='2023-09-16 14:22:12',
path_id='Wells->RoseD2',
transport_id='taxi3'
WHERE receipt_id = '13';

update transportation_receipt
set  start_time='2023-08-15 14:59:45',
end_time='2023-08-15 15:23:12',
path_id='Spa_ttc->BYoung2',
transport_id='bus1'
WHERE receipt_id = '14';

update transportation_receipt
set  start_time='2023-12-15 21:43:45',
end_time='2023-12-15 22:20:12',
path_id='Spa_ttc->BYoung1',
transport_id='subway1'
WHERE receipt_id = '15';

update transportation_receipt
set  start_time='2023-11-20 23:43:45',
end_time='2023-11-20 23:45:12',
path_id='Spa->RoseD1',
transport_id='subway2'
WHERE receipt_id = '16';

update transportation_receipt
set  start_time='2023-11-14 19:12:45',
end_time='2023-11-14 19:43:12',
path_id='Spa->RoseD2',
transport_id='taxi5'
WHERE receipt_id = '17';

update transportation_receipt
set  start_time='2023-12-10 09:12:45',
end_time='2023-12-10 09:43:12',
path_id='Wells->RoseD2',
transport_id='taxi4'
WHERE receipt_id = '18';

update transportation_receipt
set  start_time='2023-12-10 09:15:45',
end_time='2023-12-10 09:47:12',
path_id='Spa->Queen',
transport_id='bus3'
WHERE receipt_id = '19';

update transportation_receipt
set  start_time='2023-12-13 19:32:45',
end_time='2023-12-13 19:40:12',
path_id='Spa->Queen',
transport_id='bus4'
WHERE receipt_id = '20';

update transportation_receipt
set  start_time='2023-12-12 14:00:00',
end_time='2023-12-12 15:00:00',
path_id='Spa->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '100';

update transportation_receipt
set  start_time='2023-12-12 14:00:00',
end_time='2023-12-12 15:00:00',
path_id='Spa->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '101';

update transportation_receipt
set  start_time='2023-12-12 14:00:00',
end_time='2023-12-12 15:00:00',
path_id='Spa->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '102';

update transportation_receipt
set  start_time='2023-12-12 17:00:00',
end_time='2023-12-12 17:30:00',
path_id='Spa_ttc->BYoung1',
transport_id='subway2'
WHERE receipt_id = '103';

update transportation_receipt
set  start_time='2023-12-12 17:00:00',
end_time='2023-12-12 17:30:00',
path_id='Spa_ttc->BYoung1',
transport_id='subway2'
WHERE receipt_id = '104';

update transportation_receipt
set  start_time='2023-12-12 17:00:00',
end_time='2023-12-12 17:30:00',
path_id='Spa_ttc->BYoung1',
transport_id='subway2'
WHERE receipt_id = '105';

update transportation_receipt
set  start_time='2023-12-12 18:00:00',
end_time='2023-12-12 18:45:00',
path_id='Spa_ttc->BYoung2',
transport_id='bus3'
WHERE receipt_id = '106';

update transportation_receipt
set  start_time='2023-12-12 18:00:00',
end_time='2023-12-12 18:45:00',
path_id='Spa_ttc->BYoung2',
transport_id='bus3'
WHERE receipt_id = '107';

update transportation_receipt
set  start_time='2023-12-12 18:00:00',
end_time='2023-12-12 18:45:00',
path_id='Spa_ttc->BYoung2',
transport_id='bus3'
WHERE receipt_id = '108';

update transportation_receipt
set  start_time='2023-12-12 18:00:00',
end_time='2023-12-12 18:45:00',
path_id='Spa_ttc->BYoung2',
transport_id='bus3'
WHERE receipt_id = '109';

update transportation_receipt
set  start_time='2023-12-12 18:00:00',
end_time='2023-12-12 18:45:00',
path_id='Spa_ttc->BYoung2',
transport_id='bus3'
WHERE receipt_id = '110';

update transportation_receipt
set  start_time='2023-12-11 12:22:51',
end_time='2023-12-11 12:49:40',
path_id='Spa->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '111';

update transportation_receipt
set  start_time='2023-12-11 12:22:51',
end_time='2023-12-11 12:49:40',
path_id='Spa->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '112';

update transportation_receipt
set  start_time='2023-12-11 12:22:51',
end_time='2023-12-11 12:49:40',
path_id='Spa->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '113';

update transportation_receipt
set  start_time='2023-12-11 19:02:01',
end_time='2023-12-11 21:00:30',
path_id='Spa_ttc->Queen',
transport_id='taxi1'
WHERE receipt_id = '114';

update transportation_receipt
set  start_time='2023-12-11 19:02:01',
end_time='2023-12-11 21:00:30',
path_id='Spa_ttc->Queen',
transport_id='taxi1'
WHERE receipt_id = '115';

update transportation_receipt
set  start_time='2023-12-11 19:02:01',
end_time='2023-12-11 21:00:30',
path_id='Spa_ttc->Queen',
transport_id='taxi1'
WHERE receipt_id = '116';

update transportation_receipt
set  start_time='2023-12-13 05:12:19',
end_time='2023-12-13 06:10:00',
path_id='Wells->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '117';

update transportation_receipt
set  start_time='2023-12-13 05:12:19',
end_time='2023-12-13 06:10:00',
path_id='Wells->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '118';

update transportation_receipt
set  start_time='2023-12-13 05:12:19',
end_time='2023-12-13 06:10:00',
path_id='Wells->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '119';

update transportation_receipt
set  start_time='2023-12-13 05:12:19',
end_time='2023-12-13 06:10:00',
path_id='Wells->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '120';

update transportation_receipt
set  start_time='2023-12-08 14:00:00',
end_time='2023-12-08 15:00:00',
path_id='Spa_ttc->BYoung2',
transport_id='bus1'
WHERE receipt_id = '121';

update transportation_receipt
set  start_time='2023-12-09 14:00:00',
end_time='2023-12-09 15:00:00',
path_id='Spa_ttc->BYoung2',
transport_id='bus1'
WHERE receipt_id = '122';

update transportation_receipt
set  start_time='2023-12-10 14:00:00',
end_time='2023-12-10 15:00:00',
path_id='Spa_ttc->BYoung2',
transport_id='bus1'
WHERE receipt_id = '123';

update transportation_receipt
set  start_time='2023-12-11 10:00:00',
end_time='2023-12-11 12:00:00',
path_id='Spa_ttc->BYoung1',
transport_id='subway1'
WHERE receipt_id = '124';

update transportation_receipt
set  start_time='2023-12-12 10:00:00',
end_time='2023-12-12 12:00:00',
path_id='Spa_ttc->BYoung1',
transport_id='subway1'
WHERE receipt_id = '125';

update transportation_receipt
set  start_time='2023-12-08 17:00:00',
end_time='2023-12-08 17:30:00',
path_id='Spa_ttc->BYoung1',
transport_id='subway2'
WHERE receipt_id = '126';

update transportation_receipt
set  start_time='2023-12-08 17:00:00',
end_time='2023-12-08 17:30:00',
path_id='Spa_ttc->BYoung1',
transport_id='subway2'
WHERE receipt_id = '127';

update transportation_receipt
set  start_time='2023-12-09 17:00:00',
end_time='2023-12-09 17:30:00',
path_id='Spa_ttc->BYoung1',
transport_id='subway2'
WHERE receipt_id = '128';

update transportation_receipt
set  start_time='2023-12-11 18:00:00',
end_time='2023-12-11 19:00:00',
path_id='Spa_ttc->BYoung2',
transport_id='bus3'
WHERE receipt_id = '129';

update transportation_receipt
set  start_time='2023-12-12 18:00:00',
end_time='2023-12-12 19:00:00',
path_id='Spa_ttc->BYoung2',
transport_id='bus3'
WHERE receipt_id = '130';


-----------------------------------------------------------------------
-- insert parking receipts

insert into parking_receipt values
(290 , 'parking2' , 'car1' , '2023-11-12 9:00:00' , null),
(291 , 'parking2' , 'car1' , '2023-11-10 10:00:00' , null);

update parking_receipt
set end_time = '2023-11-12 18:00:00'
where receipt_id = 290;

update parking_receipt
set end_time = '2023-11-10 18:30:00'
where receipt_id = 291;

insert into parking_receipt values
(200 , 'parking1' , 'car1' , '2023-12-12 10:00:00' , null),
(201 , 'parking1' , 'car2' , '2023-12-12 11:00:00' , null),
(202 , 'parking1' , 'car3' , '2023-12-12 12:00:00' , null),
(203 , 'parking1' , 'car3' , '2023-12-12 13:00:00' , null),
(204 , 'parking1' , 'car3' , '2023-12-12 14:00:00' , null);

update parking_receipt
set end_time = '2023-12-12 11:00:00'
where receipt_id = 200;

update parking_receipt
set end_time = '2023-12-12 12:00:00'
where receipt_id = 201;

update parking_receipt
set end_time = '2023-12-12 13:00:00'
where receipt_id = 202;

update parking_receipt
set end_time = '2023-12-12 14:00:00'
where receipt_id = 203;

update parking_receipt
set end_time = '2023-12-12 15:00:00'
where receipt_id = 204;

update parking_receipt
set end_time = '2023-12-12 16:00:00'
where receipt_id = 205;

insert into parking_receipt values
(205 , 'parking2' , 'car12' , '2023-12-12 10:00:00' , null),
(206 , 'parking2' , 'car11' , '2023-12-12 10:01:00' , null),
(207 , 'parking2' , 'car10' , '2023-12-12 10:02:00' , null),
(208 , 'parking2' , 'car9' , '2023-12-12 10:03:00' , null),
(209 , 'parking2' , 'car8' , '2023-12-12 10:04:00' , null);

update parking_receipt
set end_time = '2023-12-12 11:00:00'
where receipt_id = 205;

update parking_receipt
set end_time = '2023-12-12 17:00:00'
where receipt_id = 206;

update parking_receipt
set end_time = '2023-12-12 17:00:00'
where receipt_id = 207;

update parking_receipt
set end_time = '2023-12-12 17:00:00'
where receipt_id = 208;

update parking_receipt
set end_time = '2023-12-12 17:00:00'
where receipt_id = 209;

insert into parking_receipt values
(211 , 'parking2' , 'car12' , '2023-12-12 17:06:00' , null);

update parking_receipt
set end_time = '2023-12-12 17:30:00'
where receipt_id = 211;

-------------------------------
-- insert into service_receipt
INSERT INTO service_receipt VALUES
('water', 'house1', '2023-12-12', 30),
('gas', 'house1', '2023-11-12', 31),
('water', 'house2', '2023-11-12', 32),
('water', 'house3', '2023-10-20', 33),
('electricity', 'house4', '2023-12-20', 34),
('gas', 'house5', '2023-12-24', 35);

insert into passengers values(131 , '999-99-9999');

update transportation_receipt
set  start_time='2023-10-11 22:22:00',
end_time='2023-10-11 23:22:00',
path_id='Spa->RoseD2',
transport_id='taxi1'
WHERE receipt_id = '131';
