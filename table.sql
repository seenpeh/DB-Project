PGDMP                      {            project    15.5 (Homebrew)    16.1 w    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    18623    project    DATABASE     i   CREATE DATABASE project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';
    DROP DATABASE project;
                seenbook    false            �            1255    18834    check_credit_parking()    FUNCTION     9  CREATE FUNCTION public.check_credit_parking() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 
  IF (SELECT credit FROM car join account on car.car_driver = account.acc_owner WHERE NEW.cid = cid) > 0 THEN
    RETURN NEW;
	
  ELSE
    RAISE EXCEPTION 'Not enough money!';
    RETURN NULL;
  END IF;
END;
$$;
 -   DROP FUNCTION public.check_credit_parking();
       public          seenbook    false            �            1255    18836    check_credit_transportation()    FUNCTION       CREATE FUNCTION public.check_credit_transportation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 
  IF (SELECT credit FROM account WHERE NEW.ssn = acc_owner) > 0 THEN
    RETURN NEW;
	
  ELSE
    RAISE EXCEPTION 'Not enough money!';
    RETURN NULL;
  END IF;
END;
$$;
 4   DROP FUNCTION public.check_credit_transportation();
       public          seenbook    false                       1255    18847    check_receipt_id()    FUNCTION     �  CREATE FUNCTION public.check_receipt_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (((NEW.r_type = 'transportation') AND NOT (CAST(NEW.receipt_id AS VARCHAR) ~ '^1\d*'))
	OR ((NEW.r_type = 'parking') AND NOT (CAST(NEW.receipt_id AS VARCHAR) ~ '^2\d*'))
	OR ((NEW.r_type = 'service') AND NOT (CAST(NEW.receipt_id AS VARCHAR) ~ '^3\d*'))) THEN
		RAISE EXCEPTION 'WRONG FORMAT';
		RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.check_receipt_id();
       public          seenbook    false            �            1255    18828    check_time_order()    FUNCTION       CREATE FUNCTION public.check_time_order() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.start_time >= NEW.end_time THEN
        RAISE EXCEPTION 'Starting time must be before ending time.';
		RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.check_time_order();
       public          seenbook    false            �            1255    18838    create_acc()    FUNCTION     �   CREATE FUNCTION public.create_acc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT into account
		values(0 , NEW.ssn);
	
    RETURN NEW;
END;
$$;
 #   DROP FUNCTION public.create_acc();
       public          seenbook    false            �            1255    18826    create_finish_parking()    FUNCTION     �  CREATE FUNCTION public.create_finish_parking() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 .   DROP FUNCTION public.create_finish_parking();
       public          seenbook    false            �            1255    18824    create_parking_receipt()    FUNCTION     V  CREATE FUNCTION public.create_parking_receipt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 /   DROP FUNCTION public.create_parking_receipt();
       public          seenbook    false            �            1255    18842    create_passengers_receipt()    FUNCTION     -  CREATE FUNCTION public.create_passengers_receipt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

INSERT INTO receipt (r_type, receipt_id, acc_id)
VALUES ('transportation', NEW.receipt_id, NEW.ssn);

INSERT INTO transportation_receipt(receipt_id)
VALUES (NEW.receipt_id);

RETURN NEW;
END;
$$;
 2   DROP FUNCTION public.create_passengers_receipt();
       public          seenbook    false            �            1255    18840    create_service_receipt()    FUNCTION     �  CREATE FUNCTION public.create_service_receipt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 /   DROP FUNCTION public.create_service_receipt();
       public          seenbook    false                       1255    18845    create_transportation_receipt()    FUNCTION       CREATE FUNCTION public.create_transportation_receipt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    money_amount NUMERIC(10, 2);
BEGIN
   IF NEW.end_time is not null THEN
   		money_amount := find_distance(NEW.path_id) * (SELECT  cost_per_km FROM public_transport join network on public_transport.t_type = network.network_type where NEW.transport_id = transport_id);
   		
		UPDATE receipt
			SET issue_time = NEW.end_time , price = money_amount
			where NEW.receipt_id = receipt_id;
			
   END IF;
   RETURN NEW;
END;
$$;
 6   DROP FUNCTION public.create_transportation_receipt();
       public          seenbook    false            �            1255    18832    deduct_credit_after_receipt()    FUNCTION     p  CREATE FUNCTION public.deduct_credit_after_receipt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 4   DROP FUNCTION public.deduct_credit_after_receipt();
       public          seenbook    false                       1255    18863 5   distance_between_stations(character varying, integer)    FUNCTION     �  CREATE FUNCTION public.distance_between_stations(src character varying, price integer) RETURNS TABLE(dst character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    RETURN QUERY
    WITH RECURSIVE paths AS (
        SELECT
            src_station,
            dst_station,
            distance
        FROM station_sequence
        WHERE src = src_station AND distance * 1 < price

        UNION ALL

        SELECT
            paths.src_station,
            ss.dst_station,
            paths.distance + ss.distance
        FROM paths
        JOIN station_sequence ss ON paths.dst_station = ss.src_station
        WHERE (paths.distance + ss.distance) * 1 < price
    )
    SELECT DISTINCT dst_station FROM paths as dst;
END;
$$;
 V   DROP FUNCTION public.distance_between_stations(src character varying, price integer);
       public          seenbook    false                        1255    18844     find_distance(character varying)    FUNCTION     !  CREATE FUNCTION public.find_distance(input_path_id character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
 E   DROP FUNCTION public.find_distance(input_path_id character varying);
       public          seenbook    false                       1255    18857 C   min_distance_between_stations(character varying, character varying)    FUNCTION     >  CREATE FUNCTION public.min_distance_between_stations(src character varying, dst character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    min_distance INT;
BEGIN
    WITH RECURSIVE paths AS (
        SELECT
            src_station,
            dst_station,
            distance
        FROM station_sequence
        WHERE src = src_station
        
        UNION ALL
        
        SELECT
            paths.src_station,
            station_sequence.dst_station,
            paths.distance + station_sequence.distance
        FROM paths
        JOIN station_sequence ON paths.dst_station = station_sequence.src_station
          AND paths.distance + station_sequence.distance < 20
    )
    SELECT MIN(distance) INTO min_distance
    FROM paths
    WHERE dst_station = dst;

    RETURN min_distance;
END;
$$;
 b   DROP FUNCTION public.min_distance_between_stations(src character varying, dst character varying);
       public          seenbook    false            
           1255    18895 S   query1(character varying, timestamp without time zone, timestamp without time zone)    FUNCTION       CREATE FUNCTION public.query1(driver_ssn_var character varying, t0 timestamp without time zone, t1 timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
    result_count INTEGER;
BEGIN
    EXECUTE '
        SELECT COUNT(*)
        FROM (
            SELECT tr.start_time
            FROM transportation_receipt AS tr
            JOIN passengers ON tr.receipt_id = passengers.receipt_id
            JOIN citizen ON citizen.ssn = passengers.ssn
            WHERE tr.transport_id IN (
                    SELECT pt.transport_id
                    FROM public_transport AS pt
                    WHERE pt.driver_id = $1
                )
                AND tr.start_time > $2
                AND tr.end_time < $3
            GROUP BY tr.start_time
            HAVING (SUM(CASE WHEN gender = ''female'' THEN 1 ELSE 0 END) / 
                    SUM(CASE WHEN gender = ''male'' THEN 1 ELSE 0 END)) >= 0.6
        ) AS subquery'
    INTO result_count
    USING driver_ssn_var, t0, t1;

    RETURN result_count;
END;
$_$;
    DROP FUNCTION public.query1(driver_ssn_var character varying, t0 timestamp without time zone, t1 timestamp without time zone);
       public          seenbook    false                       1255    18852    query10(character varying)    FUNCTION       CREATE FUNCTION public.query10(citizen_ssn character varying) RETURNS TABLE(month_year character varying, total_expense numeric)
    LANGUAGE plpgsql
    AS $$
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
$$;
 =   DROP FUNCTION public.query10(citizen_ssn character varying);
       public          seenbook    false                       1255    18866 #   query11(character varying, integer)    FUNCTION     �  CREATE FUNCTION public.query11(src character varying, price integer) RETURNS TABLE(dst character varying, x integer, y integer)
    LANGUAGE plpgsql
    AS $$
declare
  cost_per_km int = (select net.cost_per_km from network as net where net.network_type = 'taxi');
  
BEGIN
    RETURN QUERY
    WITH RECURSIVE paths AS (
        SELECT
            src_station,
            dst_station,
            distance
        FROM station_sequence
        WHERE src = src_station AND distance * 1 < price

        UNION ALL

        SELECT
            paths.src_station,
            ss.dst_station,
            paths.distance + ss.distance
        FROM paths
        JOIN station_sequence ss ON paths.dst_station = ss.src_station
        WHERE (paths.distance + ss.distance) * 1 < price
    )
    SELECT s.sname, s.x, s.y 
    from station as s
    where s.sname in 
    (select DISTINCT dst_station FROM paths as dst);
END;
$$;
 D   DROP FUNCTION public.query11(src character varying, price integer);
       public          seenbook    false                       1255    18893 A   query13(timestamp without time zone, timestamp without time zone)    FUNCTION     �  CREATE FUNCTION public.query13(t0 timestamp without time zone, t1 timestamp without time zone) RETURNS TABLE(fname character varying, lname character varying, ssn character varying)
    LANGUAGE plpgsql
    AS $$
begin
  return query
    select ct.fname, ct.lname, ct.ssn
        from citizen as ct
        where ct.ssn in 
    (select DISTINCT c1.car_owner 
    from parking_receipt as pr join car as c1 on c1.cid = pr.cid
    where pr.start_time > t0 and pr.end_time < t1
    and date(pr.start_time) + 1 in 
    (select date(pr2.start_time)
    from parking_receipt as pr2 join car as c2 on c2.cid = pr2.cid
    where pr2.start_time > t0 and pr2.end_time < t1));
end;  
$$;
 ^   DROP FUNCTION public.query13(t0 timestamp without time zone, t1 timestamp without time zone);
       public          seenbook    false                       1255    18897 T   query13(character varying, timestamp without time zone, timestamp without time zone)    FUNCTION     �  CREATE FUNCTION public.query13(driver_ssn_id character varying, t0 timestamp without time zone, t1 timestamp without time zone) RETURNS TABLE(fname character varying, lname character varying, ssn character varying)
    LANGUAGE plpgsql
    AS $$
begin
  return query
        SELECT count(*) FROM (
SELECT start_time
FROM (transportation_receipt as tr join passengers on tr.receipt_id = passengers.receipt_id) join citizen on citizen.ssn = passengers.ssn
WHERE transport_id in
  (SELECT pt.transport_id
  FROM public_transport AS pt
  WHERE pt.driver_id = driver_ssn_id)
  AND tr.start_time > t0 AND tr.end_time < t1
GROUP BY start_time
HAVING (count(gender = 'male') = 0) OR ((count(gender = 'female')/count(gender = 'male')) >= 0.6)
  ) AS subquery;
end;
$$;
    DROP FUNCTION public.query13(driver_ssn_id character varying, t0 timestamp without time zone, t1 timestamp without time zone);
       public          seenbook    false            	           1255    18864 S   query15(timestamp without time zone, timestamp without time zone, double precision)    FUNCTION       CREATE FUNCTION public.query15(t0 timestamp without time zone, t1 timestamp without time zone, dist double precision) RETURNS TABLE(s character varying)
    LANGUAGE plpgsql
    AS $$
begin
  return query 
    select p.ssn as s
    from passengers as p join transportation_receipt as tr on p.receipt_id = tr.receipt_id join public_transport as pt on tr.transport_id = pt.transport_id
    where tr.start_time > t0 and tr.end_time < t1 and pt.t_type = 'bus'
    group by ssn
    having sum(find_distance(tr.path_id)) < dist;
end;
$$;
 u   DROP FUNCTION public.query15(t0 timestamp without time zone, t1 timestamp without time zone, dist double precision);
       public          seenbook    false            �            1255    18849 @   query2(timestamp without time zone, timestamp without time zone)    FUNCTION       CREATE FUNCTION public.query2(start_time timestamp without time zone, end_time timestamp without time zone) RETURNS TABLE(ssn character varying, sum_of_expences numeric)
    LANGUAGE plpgsql
    AS $$
begin
	return query
		select citizen.breadwinner , sum(receipt.price)
		from (( citizen
		join account on account.acc_owner = citizen.ssn)
		join receipt on receipt.acc_id = citizen.ssn)
		where issue_time > start_time and issue_time < end_time
		group by citizen.breadwinner
		order by sum(price) desc
		limit 5;
		
end;
$$;
 k   DROP FUNCTION public.query2(start_time timestamp without time zone, end_time timestamp without time zone);
       public          seenbook    false                       1255    18867 @   query3(timestamp without time zone, timestamp without time zone)    FUNCTION     �  CREATE FUNCTION public.query3(t0 timestamp without time zone, t1 timestamp without time zone) RETURNS TABLE(driver_id character varying, sum_d integer)
    LANGUAGE plpgsql
    AS $$
begin
  return query 
    select pt.driver_id, sum(find_distance(tr.path_id)):: integer as sum_d 
    from public_transport as pt join transportation_receipt as tr on pt.transport_id = tr.transport_id
    where tr.start_time > t0 and tr.end_time < t1
    group by pt.driver_id
    order by sum_d desc
    limit 5;
end;
$$;
 ]   DROP FUNCTION public.query3(t0 timestamp without time zone, t1 timestamp without time zone);
       public          seenbook    false                       1255    18853 S   query4(timestamp without time zone, timestamp without time zone, character varying)    FUNCTION     |  CREATE FUNCTION public.query4(t0 timestamp without time zone, t1 timestamp without time zone, wanted character varying) RETURNS TABLE(count integer, month numeric, year numeric)
    LANGUAGE plpgsql
    AS $$
begin
  return query
    select count(*)::integer, EXTRACT(MONTH FROM transportation_receipt.start_time) AS month, 
  EXTRACT(YEAR FROM transportation_receipt.start_time) as year
    from transportation_receipt join path on transportation_receipt.path_id = path.path_id
    where transportation_receipt.start_time > t0 and transportation_receipt.end_time < t1 and 
    transportation_receipt.path_id in 
    (select path_id from position_in_path
    where position_in_path.sname = wanted and position_in_path.pos = 'start'
    union
    select path_id from position_in_path
    where position_in_path.sname = wanted and position_in_path.pos = 'end')
  group by month, year;
end;
$$;
 w   DROP FUNCTION public.query4(t0 timestamp without time zone, t1 timestamp without time zone, wanted character varying);
       public          seenbook    false            �            1255    18850    query5(integer, integer)    FUNCTION     P  CREATE FUNCTION public.query5(x0 integer, y0 integer) RETURNS TABLE(sname character varying, distance numeric)
    LANGUAGE plpgsql
    AS $$
begin
  return query
    SELECT
    station.sname,
    SQRT(POWER(x - x0, 2)::numeric + POWER(y - y0, 2)::numeric) AS distance
FROM
    station
ORDER BY
    distance ASC
LIMIT 5;

    
end;
$$;
 5   DROP FUNCTION public.query5(x0 integer, y0 integer);
       public          seenbook    false                       1255    18851 @   query7(timestamp without time zone, timestamp without time zone)    FUNCTION     �  CREATE FUNCTION public.query7(start_time_var timestamp without time zone, end_time_var timestamp without time zone) RETURNS TABLE(ssn character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;
 s   DROP FUNCTION public.query7(start_time_var timestamp without time zone, end_time_var timestamp without time zone);
       public          seenbook    false                       1255    18892 S   query8(timestamp without time zone, timestamp without time zone, character varying)    FUNCTION       CREATE FUNCTION public.query8(t0 timestamp without time zone, t1 timestamp without time zone, parking_id character varying) RETURNS TABLE(count integer)
    LANGUAGE plpgsql
    AS $$
begin
  return query
    select count(DISTINCT CONCAT(car.brand, ',', car.color))::integer
    from (( parking_receipt
    join parking on parking_receipt.pid = parking.pid)
        join car on car.cid = parking_receipt.cid)
    where parking_receipt.start_time > t0 and parking_receipt.end_time < t1
        and parking_id = parking.pid;
end;
$$;
 {   DROP FUNCTION public.query8(t0 timestamp without time zone, t1 timestamp without time zone, parking_id character varying);
       public          seenbook    false                       1255    18854 A   query_6(timestamp without time zone, timestamp without time zone)    FUNCTION     �  CREATE FUNCTION public.query_6(t0 timestamp without time zone, t1 timestamp without time zone) RETURNS TABLE(id character varying, count integer)
    LANGUAGE plpgsql
    AS $$
begin
  return query 
    select passengers.ssn, count(DISTINCT position_in_path.sname)::integer as count
    from passengers join transportation_receipt on passengers.receipt_id = transportation_receipt.receipt_id 
    join position_in_path on transportation_receipt.path_id = position_in_path.path_id
    where transportation_receipt.start_time > t0 and transportation_receipt.end_time < t1 
    and position_in_path.pos in ('start', 'end')
    group by passengers.ssn
    order by count desc
    limit 5;
end;
$$;
 ^   DROP FUNCTION public.query_6(t0 timestamp without time zone, t1 timestamp without time zone);
       public          seenbook    false            �            1259    18635    account    TABLE     h   CREATE TABLE public.account (
    credit numeric(20,2),
    acc_owner character varying(16) NOT NULL
);
    DROP TABLE public.account;
       public         heap    seenbook    false            �            1259    18682    car    TABLE     �   CREATE TABLE public.car (
    cid character varying(16) NOT NULL,
    brand character varying(20),
    color character varying(20),
    car_driver character varying(16),
    car_owner character varying(16) NOT NULL
);
    DROP TABLE public.car;
       public         heap    seenbook    false            �            1259    18624    citizen    TABLE     w  CREATE TABLE public.citizen (
    fname character varying(16),
    lname character varying(16),
    ssn character varying(16) NOT NULL,
    dob date,
    gender character varying(8),
    breadwinner character varying(16) NOT NULL,
    CONSTRAINT citizen_gender_check CHECK (((gender)::text = ANY ((ARRAY['male'::character varying, 'female'::character varying])::text[])))
);
    DROP TABLE public.citizen;
       public         heap    seenbook    false            �            1259    18645    house    TABLE     h  CREATE TABLE public.house (
    house_id character varying(16) NOT NULL,
    house_owner character varying(16) NOT NULL,
    water_consumption numeric(10,2),
    gas_consumption numeric(10,2),
    electricity_consumption numeric(10,2),
    x integer,
    y integer,
    house_number integer,
    street character varying(16),
    area character varying(16)
);
    DROP TABLE public.house;
       public         heap    seenbook    false            �            1259    18735    network    TABLE     $  CREATE TABLE public.network (
    network_type character varying(16) NOT NULL,
    cost_per_km numeric(10,2),
    CONSTRAINT network_network_type_check CHECK (((network_type)::text = ANY ((ARRAY['taxi'::character varying, 'bus'::character varying, 'subway'::character varying])::text[])))
);
    DROP TABLE public.network;
       public         heap    seenbook    false            �            1259    18699    parking    TABLE     0  CREATE TABLE public.parking (
    pid character varying(16) NOT NULL,
    pname character varying(100),
    capacity integer NOT NULL,
    price_per_hour numeric(10,2) NOT NULL,
    x integer,
    y integer,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL
);
    DROP TABLE public.parking;
       public         heap    seenbook    false            �            1259    18704    parking_receipt    TABLE     �   CREATE TABLE public.parking_receipt (
    receipt_id integer NOT NULL,
    pid character varying(16),
    cid character varying(16),
    start_time timestamp without time zone,
    end_time timestamp without time zone
);
 #   DROP TABLE public.parking_receipt;
       public         heap    seenbook    false            �            1259    18809 
   passengers    TABLE     l   CREATE TABLE public.passengers (
    receipt_id integer NOT NULL,
    ssn character varying(16) NOT NULL
);
    DROP TABLE public.passengers;
       public         heap    seenbook    false            �            1259    18741    path    TABLE     +  CREATE TABLE public.path (
    path_id character varying(16) NOT NULL,
    network_type character varying(16) NOT NULL,
    CONSTRAINT path_network_type_check CHECK (((network_type)::text = ANY ((ARRAY['taxi'::character varying, 'bus'::character varying, 'subway'::character varying])::text[])))
);
    DROP TABLE public.path;
       public         heap    seenbook    false            �            1259    18773    position_in_path    TABLE     F  CREATE TABLE public.position_in_path (
    sname character varying(32) NOT NULL,
    path_id character varying(16) NOT NULL,
    pos character varying(8),
    CONSTRAINT position_in_path_pos_check CHECK (((pos)::text = ANY ((ARRAY['mid'::character varying, 'start'::character varying, 'end'::character varying])::text[])))
);
 $   DROP TABLE public.position_in_path;
       public         heap    seenbook    false            �            1259    18724    public_transport    TABLE     d  CREATE TABLE public.public_transport (
    t_type character varying(16) NOT NULL,
    transport_id character varying(16) NOT NULL,
    driver_id character varying(16) NOT NULL,
    CONSTRAINT public_transport_t_type_check CHECK (((t_type)::text = ANY ((ARRAY['taxi'::character varying, 'bus'::character varying, 'subway'::character varying])::text[])))
);
 $   DROP TABLE public.public_transport;
       public         heap    seenbook    false            �            1259    18655    receipt    TABLE     �  CREATE TABLE public.receipt (
    receipt_id integer NOT NULL,
    price numeric(10,2),
    issue_time timestamp without time zone,
    r_type character varying(16) NOT NULL,
    acc_id character varying(16),
    CONSTRAINT receipt_r_type_check CHECK (((r_type)::text = ANY ((ARRAY['service'::character varying, 'parking'::character varying, 'transportation'::character varying])::text[])))
);
    DROP TABLE public.receipt;
       public         heap    seenbook    false            �            1259    18666    service_receipt    TABLE     `  CREATE TABLE public.service_receipt (
    type character varying(16) NOT NULL,
    house_id character varying(16) NOT NULL,
    date date,
    receipt_id integer NOT NULL,
    CONSTRAINT service_receipt_type_check CHECK (((type)::text = ANY ((ARRAY['water'::character varying, 'gas'::character varying, 'electricity'::character varying])::text[])))
);
 #   DROP TABLE public.service_receipt;
       public         heap    seenbook    false            �            1259    18752    station    TABLE     h   CREATE TABLE public.station (
    sname character varying(32) NOT NULL,
    x integer,
    y integer
);
    DROP TABLE public.station;
       public         heap    seenbook    false            �            1259    18757    station_sequence    TABLE        CREATE TABLE public.station_sequence (
    src_station character varying(32) NOT NULL,
    dst_station character varying(32) NOT NULL,
    distance integer,
    duration time without time zone,
    CONSTRAINT station_sequence_check CHECK (((src_station)::text <> (dst_station)::text))
);
 $   DROP TABLE public.station_sequence;
       public         heap    seenbook    false            �            1259    18789    transportation_receipt    TABLE     �   CREATE TABLE public.transportation_receipt (
    receipt_id integer NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    path_id character varying(32),
    transport_id character varying(16)
);
 *   DROP TABLE public.transportation_receipt;
       public         heap    seenbook    false            �            1259    18868    v1    VIEW     `  CREATE VIEW public.v1 AS
 SELECT citizen.fname,
    citizen.lname,
    citizen.ssn,
    citizen.dob,
    citizen.gender,
    citizen.breadwinner
   FROM public.citizen
  WHERE ((citizen.ssn)::text IN ( SELECT public_transport.driver_id
           FROM (public.transportation_receipt
             JOIN public.public_transport ON (((transportation_receipt.transport_id)::text = (public_transport.transport_id)::text)))
          WHERE (((public_transport.t_type)::text = 'bus'::text) AND (EXTRACT(month FROM age((CURRENT_DATE)::timestamp without time zone, transportation_receipt.end_time)) = (0)::numeric) AND (EXTRACT(year FROM age((CURRENT_DATE)::timestamp without time zone, transportation_receipt.end_time)) = (0)::numeric))
          GROUP BY public_transport.driver_id
         HAVING ((sum(public.find_distance(transportation_receipt.path_id)) / 30) > 1)));
    DROP VIEW public.v1;
       public          seenbook    false    228    214    214    214    214    228    214    214    222    222    222    228    256            �            1259    18873    v2    VIEW       CREATE VIEW public.v2 AS
 SELECT pp.sname,
    count(p.ssn) AS count
   FROM ((public.transportation_receipt tr
     JOIN public.position_in_path pp ON (((tr.path_id)::text = (pp.path_id)::text)))
     JOIN public.passengers p ON ((p.receipt_id = tr.receipt_id)))
  GROUP BY pp.sname;
    DROP VIEW public.v2;
       public          seenbook    false    228    229    229    228    227    227            �            1259    18887    v3    VIEW     k  CREATE VIEW public.v3 AS
 SELECT pt.transport_id,
    count(DISTINCT p.ssn) AS count
   FROM ((public.public_transport pt
     JOIN public.transportation_receipt tr ON (((pt.transport_id)::text = (tr.transport_id)::text)))
     JOIN public.passengers p ON ((tr.receipt_id = p.receipt_id)))
  WHERE ((pt.t_type)::text = 'subway'::text)
  GROUP BY pt.transport_id;
    DROP VIEW public.v3;
       public          seenbook    false    228    229    229    222    222    228            �            1259    18878    v4    VIEW     _  CREATE VIEW public.v4 AS
 SELECT house.house_id,
    house.house_owner,
    house.water_consumption,
    house.gas_consumption,
    house.electricity_consumption,
    house.x,
    house.y,
    house.house_number,
    house.street,
    house.area
   FROM public.house
  WHERE ((house.house_id)::text IN ( SELECT h.house_id
           FROM ((public.house h
             JOIN public.service_receipt sr ON (((sr.house_id)::text = (h.house_id)::text)))
             JOIN public.receipt r ON ((r.receipt_id = sr.receipt_id)))
          WHERE ((EXTRACT(month FROM age((CURRENT_DATE)::timestamp with time zone, (sr.date)::timestamp with time zone)) = (0)::numeric) AND (EXTRACT(year FROM age((CURRENT_DATE)::timestamp with time zone, (sr.date)::timestamp with time zone)) = (0)::numeric))
          GROUP BY h.house_id
         HAVING (sum(r.price) > (1000)::numeric)));
    DROP VIEW public.v4;
       public          seenbook    false    218    217    217    216    216    216    216    216    216    216    216    216    216    218    218            �          0    18635    account 
   TABLE DATA           4   COPY public.account (credit, acc_owner) FROM stdin;
    public          seenbook    false    215   ��       �          0    18682    car 
   TABLE DATA           G   COPY public.car (cid, brand, color, car_driver, car_owner) FROM stdin;
    public          seenbook    false    219   G�       �          0    18624    citizen 
   TABLE DATA           N   COPY public.citizen (fname, lname, ssn, dob, gender, breadwinner) FROM stdin;
    public          seenbook    false    214   ^�       �          0    18645    house 
   TABLE DATA           �   COPY public.house (house_id, house_owner, water_consumption, gas_consumption, electricity_consumption, x, y, house_number, street, area) FROM stdin;
    public          seenbook    false    216   ��       �          0    18735    network 
   TABLE DATA           <   COPY public.network (network_type, cost_per_km) FROM stdin;
    public          seenbook    false    223   ��       �          0    18699    parking 
   TABLE DATA           c   COPY public.parking (pid, pname, capacity, price_per_hour, x, y, start_time, end_time) FROM stdin;
    public          seenbook    false    220   ��       �          0    18704    parking_receipt 
   TABLE DATA           U   COPY public.parking_receipt (receipt_id, pid, cid, start_time, end_time) FROM stdin;
    public          seenbook    false    221   q�       �          0    18809 
   passengers 
   TABLE DATA           5   COPY public.passengers (receipt_id, ssn) FROM stdin;
    public          seenbook    false    229   �       �          0    18741    path 
   TABLE DATA           5   COPY public.path (path_id, network_type) FROM stdin;
    public          seenbook    false    224   ?�       �          0    18773    position_in_path 
   TABLE DATA           ?   COPY public.position_in_path (sname, path_id, pos) FROM stdin;
    public          seenbook    false    227   ��       �          0    18724    public_transport 
   TABLE DATA           K   COPY public.public_transport (t_type, transport_id, driver_id) FROM stdin;
    public          seenbook    false    222   ��       �          0    18655    receipt 
   TABLE DATA           P   COPY public.receipt (receipt_id, price, issue_time, r_type, acc_id) FROM stdin;
    public          seenbook    false    217   Q�       �          0    18666    service_receipt 
   TABLE DATA           K   COPY public.service_receipt (type, house_id, date, receipt_id) FROM stdin;
    public          seenbook    false    218   \�       �          0    18752    station 
   TABLE DATA           .   COPY public.station (sname, x, y) FROM stdin;
    public          seenbook    false    225   ��       �          0    18757    station_sequence 
   TABLE DATA           X   COPY public.station_sequence (src_station, dst_station, distance, duration) FROM stdin;
    public          seenbook    false    226   ��       �          0    18789    transportation_receipt 
   TABLE DATA           i   COPY public.transportation_receipt (receipt_id, start_time, end_time, path_id, transport_id) FROM stdin;
    public          seenbook    false    228   U�       �           2606    18639    account account_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (acc_owner);
 >   ALTER TABLE ONLY public.account DROP CONSTRAINT account_pkey;
       public            seenbook    false    215            �           2606    18688    car car_car_driver_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.car
    ADD CONSTRAINT car_car_driver_key UNIQUE (car_driver);
 @   ALTER TABLE ONLY public.car DROP CONSTRAINT car_car_driver_key;
       public            seenbook    false    219                        2606    18686    car car_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY public.car
    ADD CONSTRAINT car_pkey PRIMARY KEY (cid);
 6   ALTER TABLE ONLY public.car DROP CONSTRAINT car_pkey;
       public            seenbook    false    219            �           2606    18629    citizen citizen_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.citizen
    ADD CONSTRAINT citizen_pkey PRIMARY KEY (ssn);
 >   ALTER TABLE ONLY public.citizen DROP CONSTRAINT citizen_pkey;
       public            seenbook    false    214            �           2606    18649    house house_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.house
    ADD CONSTRAINT house_pkey PRIMARY KEY (house_id);
 :   ALTER TABLE ONLY public.house DROP CONSTRAINT house_pkey;
       public            seenbook    false    216                       2606    18740    network network_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.network
    ADD CONSTRAINT network_pkey PRIMARY KEY (network_type);
 >   ALTER TABLE ONLY public.network DROP CONSTRAINT network_pkey;
       public            seenbook    false    223                       2606    18703    parking parking_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.parking
    ADD CONSTRAINT parking_pkey PRIMARY KEY (pid);
 >   ALTER TABLE ONLY public.parking DROP CONSTRAINT parking_pkey;
       public            seenbook    false    220                       2606    18708 $   parking_receipt parking_receipt_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.parking_receipt
    ADD CONSTRAINT parking_receipt_pkey PRIMARY KEY (receipt_id);
 N   ALTER TABLE ONLY public.parking_receipt DROP CONSTRAINT parking_receipt_pkey;
       public            seenbook    false    221                       2606    18813    passengers passengers_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT passengers_pkey PRIMARY KEY (receipt_id, ssn);
 D   ALTER TABLE ONLY public.passengers DROP CONSTRAINT passengers_pkey;
       public            seenbook    false    229    229            
           2606    18746    path path_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.path
    ADD CONSTRAINT path_pkey PRIMARY KEY (path_id);
 8   ALTER TABLE ONLY public.path DROP CONSTRAINT path_pkey;
       public            seenbook    false    224                       2606    18778 &   position_in_path position_in_path_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.position_in_path
    ADD CONSTRAINT position_in_path_pkey PRIMARY KEY (sname, path_id);
 P   ALTER TABLE ONLY public.position_in_path DROP CONSTRAINT position_in_path_pkey;
       public            seenbook    false    227    227                       2606    18729 &   public_transport public_transport_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.public_transport
    ADD CONSTRAINT public_transport_pkey PRIMARY KEY (transport_id);
 P   ALTER TABLE ONLY public.public_transport DROP CONSTRAINT public_transport_pkey;
       public            seenbook    false    222            �           2606    18660    receipt receipt_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.receipt
    ADD CONSTRAINT receipt_pkey PRIMARY KEY (receipt_id);
 >   ALTER TABLE ONLY public.receipt DROP CONSTRAINT receipt_pkey;
       public            seenbook    false    217            �           2606    18671 $   service_receipt service_receipt_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.service_receipt
    ADD CONSTRAINT service_receipt_pkey PRIMARY KEY (receipt_id);
 N   ALTER TABLE ONLY public.service_receipt DROP CONSTRAINT service_receipt_pkey;
       public            seenbook    false    218                       2606    18756    station station_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_pkey PRIMARY KEY (sname);
 >   ALTER TABLE ONLY public.station DROP CONSTRAINT station_pkey;
       public            seenbook    false    225                       2606    18762 &   station_sequence station_sequence_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.station_sequence
    ADD CONSTRAINT station_sequence_pkey PRIMARY KEY (src_station, dst_station);
 P   ALTER TABLE ONLY public.station_sequence DROP CONSTRAINT station_sequence_pkey;
       public            seenbook    false    226    226                       2606    18793 2   transportation_receipt transportation_receipt_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.transportation_receipt
    ADD CONSTRAINT transportation_receipt_pkey PRIMARY KEY (receipt_id);
 \   ALTER TABLE ONLY public.transportation_receipt DROP CONSTRAINT transportation_receipt_pkey;
       public            seenbook    false    228            0           2620    18835 $   parking_receipt check_credit_parking    TRIGGER     �   CREATE TRIGGER check_credit_parking BEFORE INSERT ON public.parking_receipt FOR EACH ROW EXECUTE FUNCTION public.check_credit_parking();
 =   DROP TRIGGER check_credit_parking ON public.parking_receipt;
       public          seenbook    false    240    221            6           2620    18837 &   passengers check_credit_transportation    TRIGGER     �   CREATE TRIGGER check_credit_transportation BEFORE INSERT ON public.passengers FOR EACH ROW EXECUTE FUNCTION public.check_credit_transportation();
 ?   DROP TRIGGER check_credit_transportation ON public.passengers;
       public          seenbook    false    229    241            +           2620    18839    citizen create_acc_trigger    TRIGGER     t   CREATE TRIGGER create_acc_trigger AFTER INSERT ON public.citizen FOR EACH ROW EXECUTE FUNCTION public.create_acc();
 3   DROP TRIGGER create_acc_trigger ON public.citizen;
       public          seenbook    false    214    242            ,           2620    18833    receipt deduct_credit_trigger    TRIGGER     �   CREATE TRIGGER deduct_credit_trigger AFTER INSERT OR UPDATE ON public.receipt FOR EACH ROW EXECUTE FUNCTION public.deduct_credit_after_receipt();
 6   DROP TRIGGER deduct_credit_trigger ON public.receipt;
       public          seenbook    false    239    217            /           2620    18830 !   parking ensure_time_order_parking    TRIGGER     �   CREATE TRIGGER ensure_time_order_parking BEFORE INSERT OR UPDATE ON public.parking FOR EACH ROW EXECUTE FUNCTION public.check_time_order();
 :   DROP TRIGGER ensure_time_order_parking ON public.parking;
       public          seenbook    false    220    238            1           2620    18829 1   parking_receipt ensure_time_order_parking_receipt    TRIGGER     �   CREATE TRIGGER ensure_time_order_parking_receipt BEFORE INSERT OR UPDATE ON public.parking_receipt FOR EACH ROW EXECUTE FUNCTION public.check_time_order();
 J   DROP TRIGGER ensure_time_order_parking_receipt ON public.parking_receipt;
       public          seenbook    false    221    238            4           2620    18831 ?   transportation_receipt ensure_time_order_transportation_receipt    TRIGGER     �   CREATE TRIGGER ensure_time_order_transportation_receipt BEFORE INSERT OR UPDATE ON public.transportation_receipt FOR EACH ROW EXECUTE FUNCTION public.check_time_order();
 X   DROP TRIGGER ensure_time_order_transportation_receipt ON public.transportation_receipt;
       public          seenbook    false    228    238            2           2620    18827 &   parking_receipt finish_parking_trigger    TRIGGER     �   CREATE TRIGGER finish_parking_trigger AFTER UPDATE ON public.parking_receipt FOR EACH ROW EXECUTE FUNCTION public.create_finish_parking();
 ?   DROP TRIGGER finish_parking_trigger ON public.parking_receipt;
       public          seenbook    false    237    221            3           2620    18825 '   parking_receipt parking_receipt_trigger    TRIGGER     �   CREATE TRIGGER parking_receipt_trigger BEFORE INSERT ON public.parking_receipt FOR EACH ROW EXECUTE FUNCTION public.create_parking_receipt();
 @   DROP TRIGGER parking_receipt_trigger ON public.parking_receipt;
       public          seenbook    false    235    221            7           2620    18843 %   passengers passengers_receipt_trigger    TRIGGER     �   CREATE TRIGGER passengers_receipt_trigger BEFORE INSERT ON public.passengers FOR EACH ROW EXECUTE FUNCTION public.create_passengers_receipt();
 >   DROP TRIGGER passengers_receipt_trigger ON public.passengers;
       public          seenbook    false    255    229            -           2620    18848    receipt receipt_id_trigger    TRIGGER     {   CREATE TRIGGER receipt_id_trigger BEFORE INSERT ON public.receipt FOR EACH ROW EXECUTE FUNCTION public.check_receipt_id();
 3   DROP TRIGGER receipt_id_trigger ON public.receipt;
       public          seenbook    false    258    217            .           2620    18841 '   service_receipt service_receipt_trigger    TRIGGER     �   CREATE TRIGGER service_receipt_trigger BEFORE INSERT ON public.service_receipt FOR EACH ROW EXECUTE FUNCTION public.create_service_receipt();
 @   DROP TRIGGER service_receipt_trigger ON public.service_receipt;
       public          seenbook    false    218    254            5           2620    18846 5   transportation_receipt transportation_receipt_trigger    TRIGGER     �   CREATE TRIGGER transportation_receipt_trigger BEFORE UPDATE ON public.transportation_receipt FOR EACH ROW EXECUTE FUNCTION public.create_transportation_receipt();
 N   DROP TRIGGER transportation_receipt_trigger ON public.transportation_receipt;
       public          seenbook    false    228    257                       2606    18640    account account_acc_owner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_acc_owner_fkey FOREIGN KEY (acc_owner) REFERENCES public.citizen(ssn) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.account DROP CONSTRAINT account_acc_owner_fkey;
       public          seenbook    false    3572    215    214                       2606    18689    car car_car_driver_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.car
    ADD CONSTRAINT car_car_driver_fkey FOREIGN KEY (car_driver) REFERENCES public.citizen(ssn) ON UPDATE CASCADE ON DELETE CASCADE;
 A   ALTER TABLE ONLY public.car DROP CONSTRAINT car_car_driver_fkey;
       public          seenbook    false    214    3572    219                       2606    18694    car car_car_owner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.car
    ADD CONSTRAINT car_car_owner_fkey FOREIGN KEY (car_owner) REFERENCES public.citizen(ssn) ON UPDATE CASCADE ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.car DROP CONSTRAINT car_car_owner_fkey;
       public          seenbook    false    214    3572    219                       2606    18630     citizen citizen_breadwinner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.citizen
    ADD CONSTRAINT citizen_breadwinner_fkey FOREIGN KEY (breadwinner) REFERENCES public.citizen(ssn) ON UPDATE CASCADE ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.citizen DROP CONSTRAINT citizen_breadwinner_fkey;
       public          seenbook    false    214    3572    214                       2606    18650    house house_house_owner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.house
    ADD CONSTRAINT house_house_owner_fkey FOREIGN KEY (house_owner) REFERENCES public.citizen(ssn) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.house DROP CONSTRAINT house_house_owner_fkey;
       public          seenbook    false    3572    214    216                       2606    18719 (   parking_receipt parking_receipt_cid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.parking_receipt
    ADD CONSTRAINT parking_receipt_cid_fkey FOREIGN KEY (cid) REFERENCES public.car(cid) ON UPDATE CASCADE ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.parking_receipt DROP CONSTRAINT parking_receipt_cid_fkey;
       public          seenbook    false    3584    221    219                       2606    18714 (   parking_receipt parking_receipt_pid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.parking_receipt
    ADD CONSTRAINT parking_receipt_pid_fkey FOREIGN KEY (pid) REFERENCES public.parking(pid) ON UPDATE CASCADE ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.parking_receipt DROP CONSTRAINT parking_receipt_pid_fkey;
       public          seenbook    false    221    3586    220                       2606    18709 /   parking_receipt parking_receipt_receipt_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.parking_receipt
    ADD CONSTRAINT parking_receipt_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.receipt(receipt_id) ON UPDATE CASCADE ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.parking_receipt DROP CONSTRAINT parking_receipt_receipt_id_fkey;
       public          seenbook    false    3578    221    217            )           2606    18814 %   passengers passengers_receipt_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT passengers_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.transportation_receipt(receipt_id) ON UPDATE CASCADE ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.passengers DROP CONSTRAINT passengers_receipt_id_fkey;
       public          seenbook    false    229    3602    228            *           2606    18819    passengers passengers_ssn_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT passengers_ssn_fkey FOREIGN KEY (ssn) REFERENCES public.citizen(ssn) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.passengers DROP CONSTRAINT passengers_ssn_fkey;
       public          seenbook    false    229    214    3572            !           2606    18747    path path_network_type_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.path
    ADD CONSTRAINT path_network_type_fkey FOREIGN KEY (network_type) REFERENCES public.network(network_type);
 E   ALTER TABLE ONLY public.path DROP CONSTRAINT path_network_type_fkey;
       public          seenbook    false    223    3592    224            $           2606    18784 .   position_in_path position_in_path_path_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.position_in_path
    ADD CONSTRAINT position_in_path_path_id_fkey FOREIGN KEY (path_id) REFERENCES public.path(path_id) ON UPDATE CASCADE ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.position_in_path DROP CONSTRAINT position_in_path_path_id_fkey;
       public          seenbook    false    224    227    3594            %           2606    18779 ,   position_in_path position_in_path_sname_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.position_in_path
    ADD CONSTRAINT position_in_path_sname_fkey FOREIGN KEY (sname) REFERENCES public.station(sname) ON UPDATE CASCADE ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.position_in_path DROP CONSTRAINT position_in_path_sname_fkey;
       public          seenbook    false    3596    227    225                        2606    18730 0   public_transport public_transport_driver_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.public_transport
    ADD CONSTRAINT public_transport_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES public.citizen(ssn) ON UPDATE CASCADE ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public.public_transport DROP CONSTRAINT public_transport_driver_id_fkey;
       public          seenbook    false    222    3572    214                       2606    18661    receipt receipt_acc_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.receipt
    ADD CONSTRAINT receipt_acc_id_fkey FOREIGN KEY (acc_id) REFERENCES public.account(acc_owner) ON UPDATE CASCADE ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.receipt DROP CONSTRAINT receipt_acc_id_fkey;
       public          seenbook    false    217    3574    215                       2606    18677 -   service_receipt service_receipt_house_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.service_receipt
    ADD CONSTRAINT service_receipt_house_id_fkey FOREIGN KEY (house_id) REFERENCES public.house(house_id) ON UPDATE CASCADE ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.service_receipt DROP CONSTRAINT service_receipt_house_id_fkey;
       public          seenbook    false    218    3576    216                       2606    18672 /   service_receipt service_receipt_receipt_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.service_receipt
    ADD CONSTRAINT service_receipt_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.receipt(receipt_id) ON UPDATE CASCADE ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.service_receipt DROP CONSTRAINT service_receipt_receipt_id_fkey;
       public          seenbook    false    217    218    3578            "           2606    18763 2   station_sequence station_sequence_dst_station_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.station_sequence
    ADD CONSTRAINT station_sequence_dst_station_fkey FOREIGN KEY (dst_station) REFERENCES public.station(sname) ON UPDATE CASCADE ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.station_sequence DROP CONSTRAINT station_sequence_dst_station_fkey;
       public          seenbook    false    226    225    3596            #           2606    18768 2   station_sequence station_sequence_src_station_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.station_sequence
    ADD CONSTRAINT station_sequence_src_station_fkey FOREIGN KEY (src_station) REFERENCES public.station(sname) ON UPDATE CASCADE ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.station_sequence DROP CONSTRAINT station_sequence_src_station_fkey;
       public          seenbook    false    225    3596    226            &           2606    18794 :   transportation_receipt transportation_receipt_path_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transportation_receipt
    ADD CONSTRAINT transportation_receipt_path_id_fkey FOREIGN KEY (path_id) REFERENCES public.path(path_id) ON UPDATE CASCADE ON DELETE CASCADE;
 d   ALTER TABLE ONLY public.transportation_receipt DROP CONSTRAINT transportation_receipt_path_id_fkey;
       public          seenbook    false    224    3594    228            '           2606    18804 =   transportation_receipt transportation_receipt_receipt_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transportation_receipt
    ADD CONSTRAINT transportation_receipt_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.receipt(receipt_id) ON UPDATE CASCADE ON DELETE CASCADE;
 g   ALTER TABLE ONLY public.transportation_receipt DROP CONSTRAINT transportation_receipt_receipt_id_fkey;
       public          seenbook    false    3578    217    228            (           2606    18799 ?   transportation_receipt transportation_receipt_transport_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transportation_receipt
    ADD CONSTRAINT transportation_receipt_transport_id_fkey FOREIGN KEY (transport_id) REFERENCES public.public_transport(transport_id) ON UPDATE CASCADE ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.transportation_receipt DROP CONSTRAINT transportation_receipt_transport_id_fkey;
       public          seenbook    false    228    3590    222            �   S  x�=R�m�0{[�X�}���稢&q`�"�eD�D���X�KQ��]��t�8��n`�
��â��y ���w�wP��B�cfwaV��~��.�@̭�y� �ʎ�'"�"T)td��!�$:���U�"GD�`u��-1�OW���M�=����٦��E�A�&�+X����gm$&���w^!P26��3W��� -�A�6Iάu"�F������|��14��v�[M�i���)���*ζc�/��M�[��<m��d=e%r�q?���B�X���͏n�<鼻3d��T$O�s��P>
9uR���xC? �T��      �     x�]�MK�0E׷�%�|�]:�Φ**���>�bi%���_o�$��.΅�M��˼�'�ݸ����2�E��~�z�'ꡔ�RyN���z��	Zk�h������Nx�3Xkc-�1�1&��ò�)^�8��\�J�î=�pN���SUyNZ��BG=-�T���k�������x�q���4�`�&/%�A��B�O�R*QJ���y+���~[���9��я�ˋ,�_���28ϔeV�_��y_�����(~ �d{�      �   n  x�m�M��0������p�,傖VZ�z�ŻM��TaE˿�c��F�������l��$���l�R
B(%Tm%H|(Dﺆ粭;5�ZC�	� -�B�n����=2�a��R (�,���G���B�91�6i�����Fl�P��$���E��W�T�NR,�mz�]oTY��,�B1	�&ƹu��������UE�i O�*ȹ��e��BXKXKj�����%^���I�u!�jo��JOb,���]D��Rk�#RKz��vqhݎ�)��R��)�bI�b�w��n�p)	���R��?|�yןn$q����*(c�X.ۻ��)�0��%ʄi���s��p; �U�F�
G�YlsaZ���EdC͒��՝u�,p3 ���>1�ူ\�Js8!���%X_�f���>1��E�:���|\�8�S��w&�ƣ8�k7��q��E�ع�)�5����/���b��h}:S�x]f�5���Ԍ�ZJ���Hч,7��=P��VOVI�ǹM�=R��4��S�zޛ�S�;*d����q"X.�jE��a��7�v�.�%�G,��sfuI��m��k����o�Ǒ�f\��z�ƜS�J���AFV.I���e��
��      �   �   x�E��J1��ߧ�hH:I��ѣ(x�2���*�z���L�~zh�G��>�g���-"`b�G6b�'�Ԓ i�㴜/W����pN+�`fq��m7s&���N��m�M���izߍc7�{���WcRi*���(�������Q�%ԤF�1���vS�[������6]v�+������To�4q!U����I�~����[�+�� ,�K�      �   +   x�+I���4600�30�J*-�4���K��+9M!�=... 
q      �   c   x�=�A
�  ��+zA���^�@��!B��R���-��Ըo��a)�s75 I�'!-�h,h=�І����qvS�W�}��Z;Ɓ�(���B���      �   �  x���Mj�0�דS�R$�����E)�R���ڱ�X�
Y=�E��,S ��>_�_?�x�x�ҍ�̊���Cz ����P@FI�v��%���,�@�"�1I�4�(�&�i�e�^�v@:&��.�Ba�-�E��F�A��Q��qf�J�9�5i�$�U�r�?���I�w��(��Mø'M8#A�jq��dN_�h��9wm�[&qFZ��5v���o���bڪu9���z�����td�,�9t=ح�a�AV-T-����E�to�v��ENע�
�ɰ�Y5_�L�sosT��"��uF�3��Ê�\ǮΦ�sf�2���T�r������vQ�x�x��2��j,��7��7Xخ_�V�زO��]�Q�C� O���I?lU�� C�r��h���mY�?��a      �     x�]�a�� ��]� *�]���ة��CH��R@���1F�wXU-f֮�U��� �]�Gƙ��9�]?��*�W�_��.�����m�T���뗩/�\Kz�.hm��q�1<�Zoj��Qv�W�0���>�~�0&��0��/�'��!O�~�͂:��S������M�'�۷?<p?Ө/0�w�A<�=���&��v!��7�N<��$v�E���̂�ߎ_�@�i�	D����?��
I�N2��a��q95���$��mX��e��-��m���Z� ��      �   `   x�.HԵ�/Nu1�,.M*O��
�q�$Vd��KJ�u�"�K�ґ"�q&�#KSS� �����@��Ssr���� �E����� �:      �   �   x��S�
�0<7��`>��z-� ��."Ʀ$������MZ{�2fv'����U@����^��x�
t�ҖY�'�畳4	*�Ā��7ĤRZ�T]<Ζ"I���{�]gGx4�m�D*�S��u�'U�XmwM�C(�����A#����7���K��>׈E�|Bx�OY�%��6�C��AE����Q�(%���D#���x;�Jy�������R|ܯ����V�q�md�>z7���1�DH�      �   �   x�U�K� ��wqc�.�$��C���}"EQ��A����D�e03%�!}�wWrg\�:��tF�U�^:�Z�Ak�;x9g%�kS&�RtPʔ��g�ɌŒ.��s�~l����1p�q��J���D&y�D��OB-      �   �  x����j�8�����PS�,s�a	�!����q/.��#��\�:�*a� w����!8��B���>�_�~���������m��;Y,ό81�(���P"rm�H=�醩Z�c�;��xC_Qyo�����갟���E��ưu�**&	��q��^	j�}0�R�k��S�	��aY��p�Ʌ(+�sa�Ɂ�qu�LH6�t-	y���cj�RKF9�fW/��(�.�*?�Fn[1�Ū(��Ĳ��}|��Z5����_�l�Jyes-��8K������9�#l�Įq��[>c7�#R����Zu�7��KI�$Zu�Ϫ��Ju�U5)R5���2�zRb��j�
�Xɍk��H��
�Ī�����V=k�-��g����|�c�
���c�#±&!?�@X2�r�e��$k�U���^�b���X�h�:S(}��[N��^a=}��*�w��+��X��'�e�����C�ӯ��_���Ԋq�r��}�L��c滔�	RNז��S	Hw�g�mﱔb��^�)J���?if)D���'�\��"p&�1��<J�����o�*�ߙw�V����o2ᐩ���֋Tgo@�BK3ա��=y�Ng �])S�P�sж�H�x+�67�P�G����-m�
T�w!�a9��R'�v�l�<+�8��q����N��l�����O�`[���Q���c[O�i�N�g��b�!�!�o���O��}��Z���?�:��*Bg'6A���=w(��Nv �����][Q�(��NYe>�[�E�/W����N���+X�u��J�"t����Q��TF���[~r���0J%��)C	a�Q��8�Ȱd@�=6,�g���=�J�.�=i*��R-�uG�%}��UJ�Vo�E����^���~`�L9���@��{��@�h�i�6�����[�K��؀�����,U�=����=c:x
�E����>��a�U9��� �5���k�n�*��v��v���tB1%      �   _   x�U��
� �����o�Ed)!Ԑ޾_2an�S}��e1@�X:�q�s���6���_Ҋ40�,J�!��)���*���X`�〈��*�      �   �   x�%��
�@E�ɿX���m�J
�P�6Hq��߈��{rs�ѿ?�������f#�m��\��u�ĩ�Wb���pe�!��=�2t����3��Y��6V�y��e��&Ϋ����F?��Ol3»� s�g��(ǳ�!��TC⤷-2�E�Kt�jA��!���4y      �   �   x�ePM�0=�?F:���8��ďDJ�0du=��K�ᢞB�K^^^��ǳ�P���jH�E2�Rp��T���1�a��z�5�hڤ67�:u����(�϶G��!���Gt�{�/H�KFnBN�U�vl��r$/h��3S3�=����#���� 0�)K���j)	� ��Xa�xV�Sb��B�7�f{g      �   Y  x����j�0���S�\fF�e��C��=�B�l�R
!)�.m߾#K�%['��=���˚��m���T��"6D� �T�>�>�w��N�T�a��B���G�؁F�������x9G�j�X�-R��>h�{*��N��U(�bנ���4�q>f��u,�[4�4Ńf�=��ӿ��ty�I������b$_L8h5D����X�.��أ��K�{�z̚����K�t���R<hZ�xh���_���I��F��M���a��9n�<e���d�A3Q+���&��J[�-/l�KC穁�����I�}�����5�i�V�Ћ���կwH��Ԭ5���r���V"Zg�n ���l�~�b�{#5���|^i>��8���&I��M���B~i��L�Z�i�w-�����%�B�¾C���v׸萼P)�ō	�Ȥ�z��֠�e+�[���6&�E&.k�&����h8��~>�9$����T$�����k��N�d;��I�J����o%�l�-��Y���V��	`�*�����	4������V�d���z)�N;����K�*�j�e��t�Ń�,� �Q��W�ۻ���S�9     