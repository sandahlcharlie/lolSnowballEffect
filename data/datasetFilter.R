library(dplyr)

# set up folder to read csvs from and where to write to
input_dir <- readline(prompt =
                        "Enter the directory path for folder of data: ")
output_dir <- readline(prompt = 
                         "Enter the path where you want to save the output CSV: ")
if (!dir.exists(output_dir)) {
  stop("Directory does not exist: ", output_dir)
}
output_csv <- file.path(output_dir, "output.csv")

# check for files
files <- list.files(input_dir, pattern = "\\.csv$", full.names = TRUE)
if (length(files) == 0) stop("No CSVs found. Check input_dir path.")

# set the columns we want
cols_to_keep <- c(
  "gameid","datacompleteness","position", "side", "result","teamname",
  "kills", "deaths", "assists", "team kpm", "ckpm", "gspd",
  "dpm", "cspm","earned gpm", "vspm",
  "golddiffat10","xpdiffat10","csdiffat10",
  "golddiffat20","xpdiffat20","csdiffat20",
  "firsttower", "firstbaron","firstdragon","firstherald", "firstblood"
)
# set teams to keep just for teams in Worlds 2025
teams_to_keep <- c(
  "Bilibili Gaming", "CTBC Flying Oyster", "FlyQuest", "G2 Esports", "Gen.G",
  "Anyone's Legend", "Hanwha Life Esports", "Movistar KOI", "Secret Whales",
  "Vivo Keyd Stars", "KT Rolster", "100 Thieves", "Fnatic", 
  "PSG Talon", "Top Esports", "T1"
)

# function that takes in a .csv and takes only the columns and teams we want
filtered_df <- function(file) {
  df <- tryCatch(read.csv(file, stringsAsFactors = FALSE),
                 error = function(e) NULL)
  if (is.null(df)) {
    warning("Could not read: ", basename(file))
    return(NULL)
  }
  
  kept <- intersect(cols_to_keep, names(df))
  dropped <- setdiff(cols_to_keep, kept)
  if (length(dropped)) message("From ", basename(file),
                               " missing columns: ",
                               paste(dropped, collapse = ", "))
  
  # checks if a column has whitespace and trims it
  names(df) <- trimws(names(df))
  
  
  # ensure that that data extracted is just team data that is complete
  # from team names selected
  # and does not have a substantial amount of missing values
  filtered_df <- df %>%
    filter(position == "team",
           datacompleteness == "complete",
           teamname %in% teams_to_keep) %>%
    select(any_of(cols_to_keep)) %>%
    select(-any_of(c("datacompleteness", "position")))
  
  return(filtered_df)
  
}

# make the output
outData <- lapply(files, filtered_df) %>%
  bind_rows()

# write out final csv
write.csv(outData, output_csv, row.names = FALSE)
cat("saved to: ", output_csv, "\n")