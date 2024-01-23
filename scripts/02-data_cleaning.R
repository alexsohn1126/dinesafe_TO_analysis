#### Preamble ####
# Purpose: Cleans and combines raw ward map, dinesafe, and ward income data to one csv
# Author: Moohaeng Sohn
# Date: 21 Jan, 2024
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
  tail(-2) # Don't want first 2 columns

# Mark each dinesafe inspections with a ward using longitude and latitude and ward map data
get_ward <- function(long, lat) {
  # fine which shape id this longitude latitude combo lays in
  point <- st_point(c(long, lat))
  id <- st_within(point, ward_map)[[1]]
  
  # if cannot find id, throw an error: https://stackoverflow.com/a/35463249
  if(!any(id)){
    stop("Could not find a ward for a restaurant")
  }
  
  # get ward area number using id
  ward <- ward_map_properties |>
    filter(X_id == id) |>
    pull(AREA_SHORT_CODE)
  return(ward)
}

# Select relavent dinesafe data columns and convert (infraction) Severity to NA that is a string "NA - Not Applicable"
# Put each inspection into their respective wards and also add ward income
# Takes a long time to run! About 5 to 10 minutes in my machine
cleaned_dinesafe_data <- raw_dinesafe_data |>
  mutate(Severity = na_if(Severity, "NA - Not Applicable")) |>
  mutate(ward = Map(get_ward, Longitude, Latitude)) |>            # Map Longitude, latitude combo into get_ward func
  mutate(ward = sapply(ward, function(x) as.numeric(x[[1]]))) |>  # Convert ward into numeric
  mutate(median_ward_income = sapply(ward, function(x) as.numeric(median_income_ward[x]))) |>   # Convert median income into numeric based on ward
  select(restaurant = Establishment.Name, dinesafe_infraction = Severity, ward, median_ward_income)

#### Save data ####
write_csv(
  x = cleaned_dinesafe_data,
  file = "outputs/data/cleaned_dinesafe_data.csv"
)

