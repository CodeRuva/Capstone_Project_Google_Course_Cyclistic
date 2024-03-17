## PRE-CLEANING
#CLEANING MARCH DATA
SELECT 
  ride_id,
  rideable_type,
  EXTRACT(DATE FROM started_at) AS started_date,
  EXTRACT(TIME FROM started_at) AS started_time,
  EXTRACT(DATE FROM ended_at) AS started_date,
  EXTRACT(TIME FROM ended_at) AS ended_time,
  start_station_name,
  start_station_id,
  end_station_name,
  end_station_id,
  start_lat,
  start_lng,
  end_lat,
  end_lng,
  member_casual,
FROM `data-analysis1-409219.cyclistic_data1.tripdata_03`

#CLEANING MARCH DATA
SELECT *
from `data-analysis1-409219.cyclistic_data1.March_21`;

DELETE FROM `data-analysis1-409219.cyclistic_data1.March_21` WHERE end_lat is null;

alter table `data-analysis1-409219.cyclistic_data1.March_21`
RENAME COLUMN end_lat to end_lat_to_drop;

alter table `data-analysis1-409219.cyclistic_data1.March_21`
add column end_lat FLOAT64;

UPDATE `data-analysis1-409219.cyclistic_data1.March_21`
SET end_lat = CAST(end_lat_to_drop as FLOAT64)
WHERE end_lat is null;

SELECT *
FROM `data-analysis1-409219.cyclistic_data1.March_21`;

DELETE FROM `data-analysis1-409219.cyclistic_data1.March_21` WHERE end_lng is null;

alter table `data-analysis1-409219.cyclistic_data1.March_21`
RENAME COLUMN end_lng to end_lng_to_drop;

alter table `data-analysis1-409219.cyclistic_data1.March_21`
add column end_lng FLOAT64;

UPDATE `data-analysis1-409219.cyclistic_data1.March_21`
SET end_lng = CAST(end_lng_to_drop as FLOAT64)
WHERE end_lng is null;

ALTER TABLE `data-analysis1-409219.cyclistic_data1.March_21`
DROP COLUMN end_lat_to_drop,
DROP COLUMN end_lng_to_drop;
#alter table `data-analysis1-409219.cyclistic_data1.tripdata_01`
#alter column end_lat set data type FLOAT64;



## COMBINED ALL THE TABLES FOR EACH MONTH 
CREATE TABLE data-analysis1-409219.cyclistic_data1.Bikeshare_2021 AS 
SELECT *  
FROM `data-analysis1-409219.cyclistic_data1.tripdata_01`
UNION ALL
SELECT * 
  From `data-analysis1-409219.cyclistic_data1.tripdata_02`
UNION ALL
SELECT * 
FROM `data-analysis1-409219.cyclistic_data1.March_21`
UNION ALL
SELECT *  
FROM `data-analysis1-409219.cyclistic_data1.tripdata_04`
UNION ALL
SELECT * 
FROM `data-analysis1-409219.cyclistic_data1.tripdata_05`
UNION ALL
SELECT *  
FROM `data-analysis1-409219.cyclistic_data1.tripdata_06`
UNION ALL
SELECT *
FROM `data-analysis1-409219.cyclistic_data1.tripdata_07`
UNION ALL
SELECT * 
FROM `data-analysis1-409219.cyclistic_data1.tripdata_08`
UNION ALL
SELECT * 
FROM `data-analysis1-409219.cyclistic_data1.tripdata_09`
UNION ALL
SELECT * 
FROM `data-analysis1-409219.cyclistic_data1.tripdata_10`
UNION ALL
SELECT * 
FROM `data-analysis1-409219.cyclistic_data1.tripdata_11`
UNION ALL
SELECT * 
FROM `data-analysis1-409219.cyclistic_data1.tripdata_12`




## CLEANING
Select *
From `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`;

UPDATE `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
SET end_station_name = "On Bike Lock"
Where end_station_name = "NOT GIVEN" AND rideable_type = "electric_bike";

UPDATE `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
SET start_station_name = "On Bike Lock"
Where start_station_name = "NOT GIVEN" AND rideable_type = "electric_bike";

UPDATE `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
SET end_station_name = "On Bike Lock" 
Where end_station_name is null AND rideable_type = "electric_bike";

UPDATE `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
SET start_station_name = "On Bike Lock"
Where start_station_name is null AND rideable_type = "electric_bike";
#set the start and end station names to On Bike Lock for the station names for electric bikes

Select end_lng
From `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
Where end_lng is null;
#checked each column for values of "NOT GIVEN" or null to remove them next

DELETE
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
WHERE (end_station_name = "NOT GIVEN" OR end_station_id = "NOT GIVEN") AND start_station_id = "NOT GIVEN";
#removed 414,446 rows where the columns had a value "NOT GIVEN"

DELETE
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
WHERE (end_station_name IS NULL OR end_station_id IS NULL) AND start_station_id IS NULL;
#removed 8,770 rows where the columns has null values

#the above 2 statements did not remove all the NOT GIVEN and NULL values, so had to start all over from below whilst double checking if they were truly removed

select *
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`;

SELECT start_station_id
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
WHERE start_station_id = "NOT GIVEN";
#to check for each column

DELETE FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021` WHERE end_station_name = "NOT GIVEN";
DELETE FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021` WHERE end_station_id = "NOT GIVEN";
DELETE FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021` WHERE start_station_id = "NOT GIVEN";

SELECT end_station_name
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
WHERE end_station_name is null;
#to double check each column

DELETE FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021` WHERE end_station_name is null;
DELETE FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021` WHERE end_station_id is null;
DELETE FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021` WHERE start_station_id is null;



## MORE CLEANING AND DATA EXPLORATION
#TYPES OF RIDEABLE_TYPE
select rideable_type
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
group by rideable_type;

#CHANGED DOCKED_BIKE TO CLASSIC_BIKE 
UPDATE `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
SET rideable_type = 'classic_bike'
WHERE rideable_type = 'docked_bike';

#CLEANED RIDE LENGTH
select *
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
where ride_length >= '12:00:00';

DELETE from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021` where ride_length >= '12:00:00';

#POPULAR END STATION
select end_station_name, COUNT(end_station_name)
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
group by end_station_name
order by COUNT(end_station_name) DESC;

#POPULAR START STATION
select start_station_name, COUNT(start_station_name)
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
group by start_station_name
order by COUNT(start_station_name) DESC;

#REMOVED UNNECESSARY COLUMN
ALTER TABLE `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
DROP COLUMN end_station_id,
DROP COLUMN start_station_id;

#CREATED DAY_STARTED_WEEKLY COLUMN
alter table `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
add column day_started_weekly STRING;

UPDATE `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
SET day_started_weekly = 
  CASE 
    WHEN start_day_of_week = 1 THEN 'Sunday'
    WHEN start_day_of_week = 2 THEN 'Monday'
    WHEN start_day_of_week = 3 THEN 'Tuesday'
    WHEN start_day_of_week = 4 THEN 'Wednesday'
    WHEN start_day_of_week = 5 THEN 'Thursday'
    WHEN start_day_of_week = 6 THEN 'Friday'
    WHEN start_day_of_week = 7 THEN 'Saturday'
    END
WHERE day_started_weekly IS NULL;

#CREATED MONTH COLUMN
#I created column 'Month' which I extracted first from the started_date column and renamed each number of month to the actual name of month
alter table `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
add column Month STRING;

UPDATE `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
SET Month = 
  CASE
    WHEN EXTRACT(Month FROM started_date) = 1 THEN 'Jan'
    WHEN EXTRACT(Month FROM started_date) = 2 THEN 'Feb'
    WHEN EXTRACT(Month FROM started_date) = 3 THEN 'Mar'
    WHEN EXTRACT(Month FROM started_date) = 4 THEN 'Apr'
    WHEN EXTRACT(Month FROM started_date) = 5 THEN 'May'
    WHEN EXTRACT(Month FROM started_date) = 6 THEN 'Jun'
    WHEN EXTRACT(Month FROM started_date) = 7 THEN 'Jul'
    WHEN EXTRACT(Month FROM started_date) = 8 THEN 'Aug'
    WHEN EXTRACT(Month FROM started_date) = 9 THEN 'Sep'
    WHEN EXTRACT(Month FROM started_date) = 10 THEN 'Oct'
    WHEN EXTRACT(Month FROM started_date) = 11 THEN 'Nov'
    WHEN EXTRACT(Month FROM started_date) = 12 THEN 'Dec'
    END
WHERE Month IS NULL;

#COMPARES NUMBER OF CASUAL MEMBERS TO ANNUAL MEMBERS
Select member_casual, count(member_casual) AS count_mem
From `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
GROUP BY member_casual;

#CLEAN RIDE_LENGTH FOR RIDES LESS THAN A MINUTE
select ride_length
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
where ride_length <= '00:01:00';

DELETE from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021` where ride_length <= '00:01:00';

#TIMESTAMP DIFF FUNCTION
#The TIMEDIFF() function returns the difference between two time/datetime expressions.
#The TIMESTAMP() function returns a datetime value based on a date or datetime value.
#TIMESTAMP_DIFF	Gets the number of intervals between two TIMESTAMP values (TIMESTAMP_DIFF(timestamp_expression_a, timestamp_expression_b, date_part)). Works like DATE_DIFF(DATE, DATE, PART).

SELECT member_casual, rideable_type, ride_length, time_diff(ended_at , started_at, MINUTE) AS time_min
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`;

ALTER TABLE `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
Add column time_min INT;

#RIDE_LENGTH CLEANED TO MAKE IT EASIER TO FIND AVERAGE RIDES
UPDATE `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
SET time_min = time_diff(ended_at , started_at, MINUTE)
WHERE time_min IS NULL;




## ANALYSIS OF DATA
SELECT *
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`;

#TOTAL RIDES
SELECT count(*) AS totalrides
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`;

#TOTAL RIDES PER MEMBER PER RIDE TYPE
SELECT member_casual,rideable_type, count(*) AS totalrides
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
GROUP BY member_casual, rideable_type;

#AVG TIME PER MEMBER
SELECT member_casual, ROUND(AVG(time_min),2) AS avg_time
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
GROUP BY member_casual;

#AVG TIME PER MEMBER PER RIDE TYPE
SELECT member_casual, rideable_type, ROUND(AVG(time_min),2) AS avg_timespent
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
GROUP BY member_casual, rideable_type;

#AVG TIME PER DAY FOR EACH
SELECT member_casual, day_started_weekly, ROUND(AVG(time_min),2) AS avg_time_per_day
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
GROUP BY member_casual, day_started_weekly;

#DAY WITH THE MOST RIDES IN 2021
SELECT day_started_weekly, COUNT(day_started_weekly) as ride_count_per_day
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
GROUP BY day_started_weekly;

#RIDES PER DAY FOR CASUAL
SELECT member_casual, day_started_weekly, count(day_started_weekly) AS total_rides_each_day
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
WHERE member_casual = "casual"
GROUP BY member_casual, day_started_weekly
ORDER BY count(day_started_weekly) desc;

#RIDES PER DAY FOR MEMBER
SELECT member_casual, day_started_weekly, count(day_started_weekly) AS total_rides_each_day
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
WHERE member_casual = "member"
GROUP BY member_casual, day_started_weekly
ORDER BY count(day_started_weekly) desc;

#RIDES PER DAY MEMBER AND CASUAL 
SELECT member_casual, day_started_weekly, count(day_started_weekly) AS total_rides_per_day
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
GROUP BY member_casual, day_started_weekly
ORDER BY total_rides_per_day DESC;

#RIDES PER MONTH FOR BOTH
SELECT member_casual, month, count(month) AS total_rides_per_month
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
GROUP BY member_casual, Month
ORDER BY month,total_rides_per_month DESC;

#RIDES PER MONTH CASUAL
SELECT member_casual, month, count(month) AS total_rides_per_month
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
WHERE member_casual = "casual"
GROUP BY member_casual, Month;

#RIDES PER MONTH MEMBER
SELECT member_casual, month, count(month) AS total_rides_per_month
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
WHERE member_casual = "member"
GROUP BY member_casual, Month;

#EXTRACTING TIME BY THE HOUR
#RIDES PER HOUR FOR MEMBER AND CASUAL
SELECT member_casual, EXTRACT(HOUR FROM started_at) AS hour_started, COUNT(*) AS total_rides_hourly
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
GROUP BY member_casual, hour_started;

#RIDES PER HOUR CASUAL
SELECT member_casual, EXTRACT(HOUR FROM started_at) AS hour_started, COUNT(*) AS total_rides_hourly
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
WHERE member_casual = "casual"
GROUP BY member_casual, hour_started;

#RIDES PER HOUR MEMBER
SELECT member_casual, EXTRACT(HOUR FROM started_at) AS hour_started, COUNT(*) AS total_rides_hourly
FROM `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
WHERE member_casual = "member"
GROUP BY member_casual, hour_started;

#GIVES YOU THE MOST POPULAR END_STATION_NAME FOR MEMBER
select end_station_name,ROUND(avg(end_lat),5) as end_lat,ROUND(avg(end_lng),5) as end_lng, COUNT(end_station_name) AS end_station_count
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
Where end_station_name <> "On Bike Lock" AND member_casual = 'member'
group by end_station_name
order by COUNT(end_station_name) DESC;

#GIVES YOU THE MOST POPULAR END_STATION_NAME FOR CASUAL
select end_station_name,ROUND(avg(end_lat),5) as end_lat,ROUND(avg(end_lng),5) as end_lng, COUNT(end_station_name) AS end_station_count
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
Where end_station_name <> "On Bike Lock" AND member_casual = 'casual'
group by end_station_name
order by COUNT(end_station_name) DESC;

#THE MOST POPULAR START STATION NAME FOR MEMBER
select start_station_name, ROUND(avg(start_lat),5) as start_lat, ROUND(avg(start_lng),5) as start_lng,COUNT(start_station_name) AS start_station_count
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
where end_station_name <> "On Bike Lock" AND member_casual = 'member'
group by start_station_name
order by COUNT(start_station_name) DESC;

#THE MOST POPULAR START STATION NAME FOR CASUAL
select start_station_name, ROUND(avg(start_lat),5) as start_lat, ROUND(avg(start_lng),5) as start_lng,COUNT(start_station_name) AS start_station_count
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
where end_station_name <> "On Bike Lock" AND member_casual = 'casual'
group by start_station_name
order by COUNT(start_station_name) DESC;

#TOP ENDING BIKE LOCK LOCATION FOR MEMBER
select member_casual, end_lat, end_lng, count(member_casual) AS total_bike_locks
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
where member_casual = 'member' and end_station_name = "On Bike Lock"
group by member_casual, end_lat, end_lng
order by total_bike_locks DESC; 

#TOP ENDING BIKE LOCK LOCATION FOR CASUAL
select member_casual, end_lat, end_lng, count(member_casual) AS total_bike_locks
from `data-analysis1-409219.cyclistic_data1.Bikeshare_2021`
where member_casual = 'casual' and end_station_name = "On Bike Lock"
group by member_casual, end_lat, end_lng
order by total_bike_locks DESC; 


##END OF PROJECT##



























