#Data Cleaning 
# 1 Import Libaries and Load the data 
#Importing Essential Libaries
import pandas as pd                     #Pandas is used for data handling
df=pd.read_csv("EV_Data.csv")           #We load dataset into to a Data Frame(df)
print("Preview of Dataset:")            # df.head():It shows the top 5 rows - helps quickly verify column
print(df.head())
 
#2,Check Basic Information  
#Check the structure and data types
print("\n Dataset Info:")             
df.info()                               #info()- tells  you each columns type

#Check for missing values
print("\n Missing values:")
print(df.isnull().sum())                # Showing how many missing entries per column

#Summary statistics
print("\n Summary stats:")       
print(df.describe())                     #Gives Numerical summaries(mean,media,mode)

#3,Clean the data
 # Strip whitespace from column names
df.columns=df.columns.str.strip()  #Reomove Extra spaces
 #Remove rows with missing or invalid values in important columns
df=df.dropna(subset=["State","EV_Sales_Quantity"]) # Remove Nulls
 #Covert column types
df["EV_Sales_Quantity"]=df["EV_Sales_Quantity"].astype(int)
 #Standardize column names (make lowercase,replace spaces with underscore)
df.columns=df.columns.str.lower().str.replace(" ","_")

 #Clean month name(if any)
if "month" in df.columns:  #Ensures all numbers and integers 
    df["month"]=df["month"].astype(str).str.strip().str.title()
 #Create a year-Month  column for time-series analysis 
if {"year","month"}.issubset(df.columns):     #Create a new year_month column 
    df["year_month"]=df["year"].astype(str)+ "-" + df["month"] 

#4,Verfy After Cleaning

print("\n Cleaned Data Preview:")
print(df.head(20))
print("\n Data Shape After Cleaning:",df.shape)

#Saved Clean Data Set 
df.to_csv("Cleaned_ev_sales_india.csv",index=False)
print("\n Cleaned data saved successfully as 'cleaned_ev_sales_india.csv'")



    

