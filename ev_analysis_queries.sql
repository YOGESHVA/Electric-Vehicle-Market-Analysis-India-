
---DDL (Create Table)
drop  TABLE IF EXISTS ev_india_sales;
create table ev_india_sales(
	year  varchar(10),
	month_name varchar(50),
	date  varchar(200),
	state varchar(100),
	vehicle_class varchar(100),
	vehicle_category varchar(50),
	vehicle_type varchar(50),
	ev_sales_quantity int
);
select * from ev_india_sales;

select count(*) As rows_lodaded from ev_india_sales;

--1Q, Total EV units sold(overall)
select sum(ev_sales_quantity) as total_units_sold
from ev_india_sales;

--2Q,EV sales Trend by year  (units per year)
select year,sum(ev_sales_quantity)as total_sales
from ev_india_sales
group by year
order by year;

--3Q,Monthly Trend(all years combined) 
select month_name,sum(ev_sales_quantity) as units
from ev_india_sales
group by month_name
order by month_name;

--3Q,Total Ev sales by state
select state,sum(ev_sales_quantity) as total_sales
from ev_india_sales
group by state
order by total_sales Desc;

---4Q,EV Sales by vehicle class 
select vehicle_class,sum(ev_sales_quantity) as total_sales
from ev_india_sales
group by vehicle_class
order by total_sales Desc

--5Q,Monthly Ev sales Trend
select month_name,sum(ev_sales_quantity) as total_sales
from ev_india_sales
group by month_name
order by
	case
	when month_name ='January' Then 1
	when month_name ='February' Then 2
	when month_name ='March' Then 3
	when month_name ='April' Then 4
	when month_name ='May' Then 5
	when month_name ='June' Then 6
	when month_name ='July' Then 7
	when month_name ='August' Then 8
	when month_name ='Septmber' Then 9
	when month_name ='October' Then 10
	when month_name ='November' Then 11
	when month_name ='December' Then 12
  End;

--6q,EV Sales Growth%
select year,sum(ev_sales_quantity) as total_sales,
round (sum(ev_sales_quantity)-lag(sum(ev_sales_quantity))over (order by year)
      * 100.0/lag(sum(ev_sales_quantity))over (order by year),2)as growth_percent
from ev_india_sales
group by year
order by year;



---7q,Top 5 States by Ev sales 
select state,sum(ev_sales_quantity) as total_sales
from ev_india_sales
group by state
order by total_sales Desc
limit 5;

--8Q,Vehicle Type Analysis for latest year
select vehicle_type,sum(ev_sales_quantity)as total_sales
from ev_india_sales
where year=(select max(year)from ev_india_sales)
group by  vehicle_type
order by total_sales desc;




--9,State +Vehicle Type Combined Anlysis
select state,vehicle_type,sum(ev_sales_quantity)as total_sales
from ev_india_sales
group by state, vehicle_type
order by total_sales desc;



--10Q,Market share by Vechicle class
select vehicle_class,
round (sum(ev_sales_quantity) * 100/(select sum(ev_sales_quantity)from ev_india_sales),2)as contribution_percent
from ev_india_sales
group by vehicle_class
order by contribution_percent Desc;




--11,Average Monthly Sales by year
select 
year,month_name,round(avg(ev_sales_quantity),2)as avg_monthly_sales
from ev_india_sales
group by year,month_name
order by year,
	case
	when month_name ='January' Then 1
	when month_name ='February' Then 2
	when month_name ='March' Then 3
	when month_name ='April' Then 4
	when month_name ='May' Then 5
	when month_name ='June' Then 6
	when month_name ='July' Then 7
	when month_name ='August' Then 8
	when month_name ='Septmber' Then 9
	when month_name ='October' Then 10
	when month_name ='November' Then 11
	when month_name ='December' Then 12
  End;

--12Q,Yearly trend by Vehicle type(BEV VS PHEV)
select year,vehicle_type,sum(ev_sales_quantity) as units 
from ev_india_sales
group by year,vehicle_type
order by year, vehicle_type;