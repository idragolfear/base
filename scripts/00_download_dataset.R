library(RKaggle)
library(readr)
library(here)
raw_data <- RKaggle::get_dataset("uciml/pima-indians-diabetes-database")
raw_data_path <- here::here("data", "raw", "pima-indians-diabetes-database.csv")
dir.create(here::here("data", "raw"), 
           recursive = TRUE, 
           showWarnings = FALSE)
readr::write_csv(raw_data, raw_data_path)