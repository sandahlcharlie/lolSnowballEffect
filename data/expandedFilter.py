import pandas as pd
import os

def validate_io(data, finalData, allowedExt):

    # checks whether file exists
    if not os.path.exists(data):
        raise FileNotFoundError(f"Input file does not exist: {data}")

    # removes the path part of the text and saves the extension
    _, ext = os.path.splitext(data)
    if ext.lower() not in allowedExt:
        raise ValueError(f"Invalid input type: {ext}. Allowed: {allowedExt}")

    # validate input vs output
    if os.path.abspath(data) == os.path.abspath(finalData):
        raise ValueError("Input and output file paths cannot be the same.")

# variables that are the filters
keeperCols = [  "gameid", "side", "result","teamname",
  "kills", "deaths", "assists", "team kpm", "ckpm", "gspd",
  "dpm", "cspm","earned gpm", "vspm",
  "goldat10","xpat10","csat10",
  "goldat20","xpat20","csat20",
  "firsttower", "firstdragon","firstherald", "firstblood"]

keeperTeams = [  "Bilibili Gaming", "CTBC Flying Oyster", "FlyQuest", "G2 Esports", "Gen.G",
"Anyone's Legend", "Hanwha Life Esports", "Movistar KOI", "Secret Whales",
"Vivo Keyd Stars", "KT Rolster", "100 Thieves", "Fnatic", 
"PSG Talon", "Top Esports", "T1"]


print("This program imports a csv from Oracles Elixer and filters for teams in Worlds 2025 and independent variables realted to snowballing.")
inputFile = input("What is the path of your input csv: ")
outputFile = input("Where is the output path: ")
allowedExt = ['.csv']

# make sure the inputs is allowed and not the same as the output
validate_io(inputFile, outputFile, allowedExt)

#read and filter csv
df = pd.read_csv(inputFile, low_memory=False)
df = df[(df['datacompleteness'] == 'complete') & (df['position'] == 'team')] #& (df['teamname'].isin(keeperTeams))]
df = df[keeperCols]
outputFile = os.path.join(outputFile, 'filteredData.csv')

df.to_csv(outputFile, index=False)

