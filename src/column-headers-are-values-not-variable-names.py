import pandas as pd
import datetime
from os import listdir
from os.path import isfile, join
import glob
import re
df = pd.read_csv("./data/pew-raw.csv")
print("pew-raw.csv")
print(df.head(10))
# Problem: The columns headers are composed of the possible income values.
# A tidy version of this dataset is one in which the income values would not be columns headers but rather values in an income column.

print("unptivoted data")
formatted_df = pd.melt(df,
                       ["religion"],
                       var_name="income",
                       value_name="freq")
formatted_df = formatted_df.sort_values(by=["religion"])
print("tidy data")
print(formatted_df.head(10))