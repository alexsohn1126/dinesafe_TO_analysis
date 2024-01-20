#### Preamble ####
# Purpose: Cleans and combines raw ward map, dinesafe, and ward income data to one csv
# Author: Moohaeng Sohn
# Date: Jan 19, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run 01-download_data.R and download required libraries

#### Workspace setup ####
library(tidyverse)
library(openxlsx)
library(sf)

#### Clean data ####
# load all 3 datasets
ward_map <- st_read("inputs/data/ward_map_data.geojson")
raw_dinesafe_data <- read_csv("inputs/data/raw_dinesafe_data.csv")
raw_ward_data <- read.xlsx("inputs/data/raw_ward_data.xlsx")

# get properties for each area id in ward_map
ward_map_properties <- as_tibble(ward_map)

# filter xlsx to the data we want (median household for each ward)
median_income_ward <- raw_ward_data |>
  filter(City.of.Toronto.Profiles == "Median total income of households in 2020 ($)") |>
  unlist() |>
  unname() |>
  tail(-2)

# select relavent dinesafe data columns and convert
# (infraction) Severity to NA that is a string "NA - Not Applicable"
cleaned_dinesafe_data <- raw_dinesafe_data |>
  select(Severity, Latitude, Longitude) |>
  mutate(Severity = na_if(Severity, "NA - Not Applicable"))

# Mark each dinesafe inspections with a ward using longitude and latitude and ward map data
get_ward <- function(long, lat) {
  point <- st_point(c(long, lat))
  id <- st_within(point, ward_map)[[1]]
  if(!any(id)){
    return("-1")
  }
  ward <- ward_map_properties |>
    filter(X_id == id) |>
    pull(AREA_SHORT_CODE)
  return(ward)
}

# Takes a long time to run! About 5 to 10 minutes in my machine
cleaned_dinesafe_data <- cleaned_dinesafe_data |> 
  mutate(ward = Map(get_ward, Longitude, Latitude)) |>
  mutate(ward = sapply(ward, function(x) as.numeric(x[[1]]))) |>
  mutate(median_ward_income = sapply(ward, function(x) as.numeric(median_income_ward[x]))) |>
  select(dinesafe_infraction = Severity, ward, median_ward_income)

#### Save data ####
write_csv(
  x = cleaned_dinesafe_data,
  file = "outputs/data/cleaned_dinesafe_data.csv"
)

