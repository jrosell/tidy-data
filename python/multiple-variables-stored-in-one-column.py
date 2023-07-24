import pandas as pd
import datetime
from os import listdir
from os.path import isfile, join
import glob
import re
print("tb-raw.csv")
df = pd.read_csv("./data/tb-raw.csv")
print(df.head(10))
# Problems: Some columns contain multiple values: sex and age. Mixture of zeros and missing values NaN. This is due to the data collection process and the distinction is important for this dataset.
# In order to tidy this dataset, we’ll first need to melt columns into a single one, then we'll derive three columns from it: sex, age_lower and age_upper.

print("unpivot data")
df = pd.melt(df, id_vars=["country","year"], value_name="cases", var_name="sex_and_age")
print(df.head(10))

print("Extract sex, age_lower and age_upper")
tmp_df = df["sex_and_age"].str.extract("(\D)(\d+)(\d{2})")
tmp_df.columns = ["sex", "age_lower", "age_upper"]
print(tmp_df.head(10))

print("Add Age column")
tmp_df["age"] = tmp_df["age_lower"] + "-" + tmp_df["age_upper"]
print(tmp_df.head(10))


print("Merge unpivoted data and wrangled data")
df = pd.concat([df, tmp_df], axis=1) 
print(df.head(10))

print("Drop unnecesary columns and rows and sort them")
df = df.drop(['sex_and_age',"age_lower","age_upper"], axis=1)
df = df.dropna()
df = df.sort_values(ascending=True,by=["country", "year", "sex", "age"])
print(df.head(10))
