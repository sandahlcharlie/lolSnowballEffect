# lolSnowballEffect
This is the final project for the stat 311 course at Metro State University for the Fall 2025 semester. In this project we will use linear regression to make a predictive model for the amount of gold a team has at 20 minutes as it relates to cs, kills, xp, and gold at 10 minutes as well as multiple per minute metrics.
# Instructions
[Final Project](Final_Project_Stat311-Fall2025.pdf)

Most Recent Filtered Dataset:
[data/filteredData.csv](data/filteredData.csv)

The data is from [Oracle’s Elixir](https://oracleselixir.com/tools/downloads)  
and hosted on [Google Drive](https://drive.google.com/drive/u/1/folders/1gLSw0RLjBbtaNy0dgnGQDAZOHIgCe-HH).
We are using the data from 2025.

# Filter script
***datasetFilter.R is DEPRECIATED, please use filter.py***

Run filter.py in python in a terminal or IDE.
The script is to filter Oracle's Elixer data to only keep teams that are in Worlds 2025 from the 2025 esports season. It also sorts for only columns that are relevent to our regression analysis.  
The script will ask for the input file and an output folder to save a file called 'filteredData.csv'.

There is also an expaneded filter that does not filter out teams. I found some winning bias in the original dataset using only worlds teams. There is also a expanded dataset with all teams and the independent variable columns we chose.
