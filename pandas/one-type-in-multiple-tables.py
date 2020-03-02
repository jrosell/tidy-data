import pandas as pd
import datetime
from os import listdir
from os.path import isfile, join
import glob
import re
print("yyyy-baby-names-illinois.csv")
# Problem: The data is spread across multiple tables/files. The “Year” variable is present in the file name.
# We'll append the files together and extract the “Year” variable.
 
def extract_year(string):
    match = re.match(".+(\d{4})", string) 
    if match != None: return match.group(1)
    
path = './data/'
allFiles = glob.glob(path + "/201*-baby-names-illinois.csv")
frame = pd.DataFrame()
df_list= []
for file_ in allFiles:
    df = pd.read_csv(file_,index_col=None, header=0)
    print(file_)
    print(df.head(5))
    df.columns = map(str.lower, df.columns)
    df["year"] = extract_year(file_)
    df_list.append(df)

print("Appended data with year column")
df = pd.concat(df_list)
print(df)