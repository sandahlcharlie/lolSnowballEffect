library(dplyr)

# set up folder to read csvs from and where to write to
input_dir <- readline(prompt = "Enter the directory path for folder of data: ")
output_dir <- readline(prompt = "Enter the folder path where you want to save the output CSV: ")
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
  "kills", "deaths", "assists", "teamkpm", "ckpm", "gspd",
  "dpm", "cspm","earnedgpm", "vspm",
  "golddiffat10","xpdiffat10","csdiffat10",
  "golddiffat20","xpdiffat20","csdiffat20",
  "firsttower", "firstbaron","firstdragon","firstherald", "firstblood"
)

# helper to make sure data is read right
one_file <- function(file) {
  df <- tryCatch(read.csv(file, stringsAsFactors = FALSE), error = function(e) NULL)
  if (is.null(df)) {
    warning("Could not read: ", basename(file))
    return(NULL)
  }
  
  kept <- intersect(cols_to_keep, names(df))
  dropped <- setdiff(cols_to_keep, kept)
  if (length(dropped)) message("From ", basename(file),
                               " missing columns: ", paste(dropped, collapse = ", "))
  
  # Filter first, then select (so we can drop 'position' and 'datacompleteness')
  df <- df %>%
    filter(position == "team", datacompleteness == "complete") %>%
    select(any_of(cols_to_keep)) %>%
    mutate(source_file = basename(file))
}

# filter just for teams in Worlds 2025
target_teams <- c(
  "Bilibili Gaming", "CTBC Flying Oyster", "FlyQuest", "G2 Esports", "Gen.G",
  "Anyone's Legend", "Hanwha Life Esports", "Movistar KOI", "Secret Whales",
  "Vivo Keyd Stars", "KT Rolster", "100 Thieves", "Fnatic", 
  "PSG Talon", "Top Esports", "T1"
)

filtered_df <- combined_df %>%
  filter(teamname %in% target_teams) %>%
  select(-any_of(c("source_file", "datacompleteness", "position")))

# write out final csv
write.csv(filtered_df, output_csv, row.names = FALSE)
cat("saved to: ", output_csv, "\n")