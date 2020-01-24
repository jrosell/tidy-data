import pandas as pd
import datetime
from os import listdir
from os.path import isfile, join
import glob
import re

# Frist clean
print("billboard-raw.csv")
df = pd.read_csv("./data/billboard.csv", encoding="mac_latin2")
print(df.head(10))
# Problems: The columns headers are composed of values. If a song is in the Top 100 for less than 75 weeks, the remaining columns are filled with missing values. Multiple observational units (the song and its rank) in a single table.
# A tidy version of this dataset is one without the week’s numbers as columns but rather as values of a single column. Use of two tables.

print("unpivot data")
id_vars = ["year",
           "artist.inverted",
           "track",
           "time",
           "genre",
           "date.entered",
           "date.peaked"]
df = pd.melt(frame=df,id_vars=id_vars, var_name="week", value_name="rank")
print(df.head(10))

print("drop missing")
df = df.dropna()
print(df.head(10))

print("format dates")
df["week"] = df['week'].str.extract('(\d+)', expand=False).astype(int)
df["rank"] = df["rank"].astype(int)
df['date'] = pd.to_datetime(df['date.entered']) + pd.to_timedelta(df['week'], unit='w') - pd.DateOffset(weeks=1)
df = df[["year", 
         "artist.inverted",
         "track",
         "time",
         "genre",
         "week",
         "rank",
         "date"]]
df = df.sort_values(ascending=True, by=["year","artist.inverted","track","week","rank"])
print(df.head(10))
billboard = df

print("song_id created")
songs_cols = ["year", "artist.inverted", "track", "time", "genre"]
songs = billboard[songs_cols].drop_duplicates()
songs = songs.reset_index(drop=True)
songs["song_id"] = songs.index
print(songs.head(10))

print("table ranks created")
ranks = pd.merge(billboard, songs, on=["year","artist.inverted", "track", "time", "genre"])
ranks = ranks[["song_id", "date","rank"]]
print(ranks.head(10))
