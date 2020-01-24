import pandas as pd
import datetime
from os import listdir
from os.path import isfile, join
import glob
import re
print("weather-raw.csv")
df = pd.read_csv("./data/weather-raw.csv")
print(df.head(10))
# Problems: Variables are stored in both rows (tmin, tmax) and columns (days).
# In order to make this dataset tidy, we want to move the three misplaced variables (tmin, tmax and days) as three individual columns: tmin. tmax and date.


print("Unpivot/melt id, year, month, element to create day_raw column")
df = pd.melt(df, id_vars=["id", "year","month","element"], var_name="day_raw")
print(df.head(10))


# Creating a date from the different columns
def create_date_from_year_month_day(row):
    return datetime.datetime(year=row["year"], month=int(row["month"]), day=row["day"])

print("Extracting day, converting year, month, day to numeric format and create date column")
df["day"] = df["day_raw"].str.extract("d(\d+)", expand=False)  
df["id"] = "MX17004"
df[["year","month","day"]] = df[["year","month","day"]].apply(lambda x: pd.to_numeric(x, errors='ignore'))
df["date"] = df.apply(lambda row: create_date_from_year_month_day(row), axis=1)
print(df.head(10))

print("Remove columns and missing values")
df = df.drop(['year',"month","day", "day_raw"], axis=1)
df = df.dropna()
print(df.head(10))

print("Pivot/unmelt element colum reseting index")
df = df.pivot_table(index=["id","date"], columns="element", values="value")
df.reset_index(drop=False, inplace=True)
print(df.head(10))
