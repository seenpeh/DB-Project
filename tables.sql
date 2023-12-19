
create table citizen (
  fname varchar(16) ,
  lname varchar(16) ,
  ssn varchar(16) primary key not null , 
  dob date , 
  gender varchar(8) ,
  breadwinner varchar(16) not null,
  
  foreign key (breadwinner) references citizen (ssn) 
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  check (gender in ('male' , 'female'))
);


create table account (
  credit numeric(20 , 2) ,
  acc_owner varchar(16) not null primary key,
  
  foreign key (acc_owner) references citizen (ssn) 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


create table house(
  house_id varchar(16) not null primary key ,
  house_owner varchar(16) not null  , 
  water_consumption numeric(10 , 2) ,
  gas_consumption numeric(10 , 2) ,
  electricity_consumption numeric(10 , 2) , 
  x int ,
  y int ,
  house_number int ,
  street varchar(16) , 
  area varchar(16) ,
  
  foreign key (house_owner) references citizen (ssn)
    on update cascade
    on delete cascade
);


create table receipt (
  receipt_id int primary key,
  price numeric (10, 2),
  issue_time timestamp,
  r_type varchar(16) not null,
  acc_id varchar(16),
	
  foreign key (acc_id) references account(acc_owner)
    on update cascade
    on delete cascade,
  check (r_type in ('service' , 'parking' , 'transportation'))
);

create table service_receipt(
    type varchar(16) not null,
    house_id varchar(16) not null ,
    date date,
    receipt_id int primary key,

    foreign key (receipt_id) references receipt(receipt_id)
        on update cascade
        on delete cascade,
    foreign key (house_id) references house(house_id)
        on update cascade
        on delete cascade,
    check (type in ('water' , 'gas' , 'electricity'))
);

CREATE TABLE car (
 cid varchar(16) PRIMARY KEY,
 brand varchar(20),
 color varchar(20),
 car_driver varchar(16) UNIQUE,
 car_owner varchar(16) NOT NULL,
 FOREIGN KEY (car_driver) REFERENCES citizen(ssn)
	on update cascade 
	on delete cascade ,
 FOREIGN KEY (car_owner) REFERENCES citizen(ssn)
	on update cascade 
	on delete cascade 
);

CREATE TABLE parking (
 pid varchar(16) PRIMARY KEY,
 pname varchar(100),
 capacity int NOT NULL,
 price_per_hour numeric(10, 2) NOT NULL,
 x int,
 y int,
 start_time TIME NOT NULL,
 end_time TIME NOT NULL
);


CREATE TABLE parking_receipt (
 receipt_id int PRIMARY KEY,
 pid varchar(16),
 cid varchar(16),
 start_time timestamp,
 end_time timestamp,
 FOREIGN KEY (receipt_id) REFERENCES receipt(receipt_id)
    on update cascade 
	on delete cascade ,
 FOREIGN KEY (pid) REFERENCES parking(pid)
	on update cascade 
	on delete cascade ,
 FOREIGN KEY (cid) REFERENCES car(cid)
	on update cascade 
	on delete cascade 
);

create table public_transport(
    t_type varchar(16) not null,
    transport_id varchar(16) not null primary key,
    driver_id varchar (16) not null,

    foreign key (driver_id) references citizen(ssn)
    on update cascade
    on delete cascade ,
	check (t_type in ('taxi' , 'bus' , 'subway'))
);

CREATE TABLE network(
  network_type varchar(16) primary key,
  cost_per_km numeric(10, 2),

  check (network_type in ('taxi' , 'bus' , 'subway'))
);

create table path(
    path_id varchar(16) not null primary key,
    network_type varchar(16) not null,

    foreign key (network_type) REFERENCES network(network_type) , 
    check (network_type in ('taxi' , 'bus' , 'subway'))
);

CREATE TABLE station (
 sname varchar(32) PRIMARY KEY,
 x int,
 y int
);


CREATE TABLE station_sequence (
 src_station varchar(32),
 dst_station varchar(32),
 distance int,
 duration time,
 PRIMARY KEY (src_station, dst_station),
 FOREIGN KEY (dst_station) REFERENCES station(sname)
	on update cascade 
	on delete cascade , 
 FOREIGN KEY (src_station) REFERENCES station(sname)
	on update cascade 
	on delete cascade ,
 CHECK (src_station <> dst_station)
);

create table position_in_path(
	sname varchar(32),
	path_id varchar(16),
	pos varchar(8),
	
	primary key(sname , path_id),
	foreign key (sname) references station (sname)
		on update cascade
		on delete cascade,
	foreign key (path_id) references path (path_id)
		on update cascade
		on delete cascade,
	check (pos in ('mid' , 'start' , 'end'))
);

create table transportation_receipt(
	receipt_id int PRIMARY KEY,
	start_time timestamp ,
	end_time timestamp ,
	path_id varchar(32) ,
	transport_id varchar(16) ,
	
	foreign key (path_id) references path (path_id)
		on update cascade
		on delete cascade ,
	foreign key (transport_id) references public_transport (transport_id)
		on update cascade
		on delete cascade ,
	foreign key (receipt_id) references receipt(receipt_id)
        on update cascade
        on delete cascade 
);

create table passengers(
	receipt_id int ,
	ssn varchar(16) ,
	
	primary key(receipt_id , ssn),
	foreign key (receipt_id) references transportation_receipt(receipt_id)
		on update cascade
		on delete cascade ,
	foreign key (ssn) references citizen(ssn)
		on update cascade
		on delete cascade 
);



