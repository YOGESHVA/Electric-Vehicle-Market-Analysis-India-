# Electric-Vehicle-Market-Analysis-India
The Project showcases a complete data analytics pipeline-from Python - data cleaning, to SQL data modeling and finally Power Bi Visualization
# Project Overview -
The Objective of this project is to understand how **Electrical Vehicle(EV)** adoption has grown across India and identify:
-Which state lead in Ev sales
-Which vehicle types are most popular 
-How sales have changed Year-over-year (YOY)
-The overall market growth trend
This project simulates a real-world analytics workflow - from **data cleaning in Python**,**analysis in SQL**,and **interactive visualization in Power BI**

## Tools & Technologies used 
| Tool | Purpose |
| Python (Pandas,Numpy) | Data cleaning & preprocessing |
| SQL (PostgreSQL,pgAdmin)| Data storage,queying,and analysis|
|Power BI|Data Visualization and dashboard creation |
|GitHub |Project hosting & version control|
**Data Cleaning & Preprocessing**
Import Libaries and Load the data 

**1**, Importing Essential Libaries
import pandas as pd                     
df=pd.read_csv("EV_Data.csv")           
print("Preview of Dataset:")
print(df.head())
 
**2**,Check Basic Information  
# Check the structure and data types
print("\n Dataset Info:")             
df.info()                               
# Check for missing values
print("\n Missing values:")
print(df.isnull().sum())                

# Summary statistics
print("\n Summary stats:")       
print(df.describe())                

 **3**,Clean the data
 # Strip whitespace from column names
df.columns=df.columns.str.strip()  
 #Remove rows with missing or invalid values in important columns
df=df.dropna(subset=["State","EV_Sales_Quantity"]) 
 # Covert column types
df["EV_Sales_Quantity"]=df["EV_Sales_Quantity"].astype(int)
 #Standardize column names (make lowercase,replace spaces with underscore)
df.columns=df.columns.str.lower().str.replace(" ","_")

 # Clean month name(if any)
if "month" in df.columns:  #Ensures all numbers and integers 
    df["month"]=df["month"].astype(str).str.strip().str.title()
 #Create a year-Month  column for time-series analysis 
if {"year","month"}.issubset(df.columns):      
    df["year_month"]=df["year"].astype(str)+ "-" + df["month"] 

**4**,Verfy After Cleaning

print("\n Cleaned Data Preview:")
print(df.head(20))
print("\n Data Shape After Cleaning:",df.shape)

# Saved Clean Data Set 
df.to_csv("Cleaned_ev_sales_india.csv",index=False)
print("\n Cleaned data saved successfully as 'cleaned_ev_sales_india.csv'")
After Cleaned Data Load into PostgreSQL for analysis

## SQL (PostgreSQL,pgAdmin)| Data storage,queying,and analysis
# DDL (Create Table)
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

**1Q**, Total EV units sold(overall)
select sum(ev_sales_quantity) as total_units_sold
from ev_india_sales;

**2Q**,EV sales Trend by year  (units per year)
select year,sum(ev_sales_quantity)as total_sales
from ev_india_sales
group by year
order by year;

**3Q**,Monthly Trend(all years combined) 
select month_name,sum(ev_sales_quantity) as units
from ev_india_sales
group by month_name
order by month_name;

**4Q**,Total Ev sales by state
select state,sum(ev_sales_quantity) as total_sales
from ev_india_sales
group by state
order by total_sales Desc;

**5Q**,EV Sales by vehicle class 
select vehicle_class,sum(ev_sales_quantity) as total_sales
from ev_india_sales
group by vehicle_class
order by total_sales Desc

**6Q**,Monthly Ev sales Trend
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

**7Q**,EV Sales Growth%
select year,sum(ev_sales_quantity) as total_sales,
round (sum(ev_sales_quantity)-lag(sum(ev_sales_quantity))over (order by year)
      * 100.0/lag(sum(ev_sales_quantity))over (order by year),2)as growth_percent
from ev_india_sales
group by year
order by year;

**8Q**,Top 5 States by Ev sales 
select state,sum(ev_sales_quantity) as total_sales
from ev_india_sales
group by state
order by total_sales Desc
limit 5;

**9Q**,Vehicle Type Analysis for latest year
select vehicle_type,sum(ev_sales_quantity)as total_sales
from ev_india_sales
where year=(select max(year)from ev_india_sales)
group by  vehicle_type
order by total_sales desc;

**10Q**,State +Vehicle Type Combined Anlysis
select state,vehicle_type,sum(ev_sales_quantity)as total_sales
from ev_india_sales
group by state, vehicle_type
order by total_sales desc;

**11Q**,Market share by Vechicle class
select vehicle_class,
round (sum(ev_sales_quantity) * 100/(select sum(ev_sales_quantity)from ev_india_sales),2)as contribution_percent
from ev_india_sales
group by vehicle_class
order by contribution_percent Desc;

**12Q**,Average Monthly Sales by year
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

**13Q**,Yearly trend by Vehicle type(BEV VS PHEV)
select year,vehicle_type,sum(ev_sales_quantity) as units 
from ev_india_sales
group by year,vehicle_type
order by year, vehicle_type;

After Analysis Load The Data Into Power Bi 

## Power BI Dashboard Overview 
This dashboard provides a comprehensive overview of **Electric Vehicle (EV) sales across India**.It highlights national growth trends,top-performing states,and the most popular vehicle categories.
First Load the data into Power Bi.
# Dashboard Sections
1. **Filters (Left Panel)**
   -**Year Selector:** Allows filtering date by specific years (2014-2024).
   -**Month Selector:** Enables monthly trend analysis.
   -**State Selector:** View EV sales by individual states.
   -**Vehicle Category Filter:** Compare between 2-Wheelers,3-Wheelers,and others.
2. **Top KPIs (Top Row)**
   -**Total EV Sales:** Displays total sales across all years (eg., 4M)
   -**YoY Growth %:**  Shows year-over-over growth (1.36%)
   -**Total States:** Number of India states selling EVs (34)
   -**Top Vehicle Category:** Most popular category (eg., 2-Wheelers).
3. **Visual Insights (Middle Section)**
   --**Total EV Sales Growth (line Chart):** Tracks EV adoption growth by year
   --**Top 5 States (Bar Chart):** Displays states with the highest EV sales - Uttra Pradesh,Maharashtra,Karnataka,Delhi,and Rajasthan.
   --**EV Sales by Vehicle Category (Column Chart):** Compare sales between 2-Wheelers ,3-Wheelers,4-Wheelers,and others.
   --**EV Sales by Vehicle Type (Donut Chart):** Visual breakdown of market share by type.
   --**EV sales by State (Map):** Geographical distribution of EV adoption across India.
4. **Key Insights**
   -EV adoption has seen steady growth since 2014.
   -**2-Wheelers** dominate the market,making up nearly 50% of total sales.
   --Northern and Western states (Uttra Pradesh,Maharashtra,Karnataka) are leading contributers.
   --Consistent YoY growth indicates a postive trend in EV adoption nationwide.
   



