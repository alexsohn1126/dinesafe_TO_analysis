#### Preamble ####
# Purpose: Downloads and saves the relavent data from opendatatoronto
# Author: Moohaeng Sohn
# Date: 19 Jan 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install the required packages shown in workspace setup


#### Workspace setup ####
library(opendatatoronto)
library(openxlsx)
library(tidyverse)
library(sf)

#### Download data ####
# find ward geojson data id (to convert lat-long coordinates to wards)
map_ids <- list_package_resources("5e7a8234-f805-43ac-820f-03d7c360b588") |>
  filter(tolower(format) %in% c('geojson'))
map_ids

# find dinesafe data id
dinesafe_ids <- list_package_resources("ea1d6e57-87af-4e23-b722-6c1f5aa18a8d") |>
  filter(tolower(format) %in% c('csv'))
dinesafe_ids

# find ward profile data id (contains income data)
ward_data_ids <- list_package_resources("6678e1a6-d25f-4dff-b2b7-aa8f042bc2eb") |>
  filter(tolower(format) %in% c('xlsx'))
ward_data_ids

# download resources
ward_map_data <- get_resource("7672dac5-b383-4d7c-90ec-291dc69d37bf")
dinesafe_data <- get_resource("815aedb5-f9d7-4dcd-a33a-4aa7ac5aac50")
ward_data <- get_resource("16a31e1d-b4d9-4cf0-b5b3-2e3937cb4121")

ward_data_2021_census <- ward_data[["2021 One Variable"]] # Only get 2021 data


#### Save data ####
ward_geojson_dest <- "inputs/data/ward_map_data.geojson"
dinesafe_dest <- "inputs/data/raw_dinesafe_data.csv"
ward_data_dest <- "inputs/data/raw_ward_data.xlsx"

# st_write cannot overwrite files so we do it manually
if (file.exists(ward_geojson_dest)) {
  file.remove(ward_geojson_dest)
}

st_write(ward_map_data, ward_geojson_dest, driver = "GeoJSON")
write_csv(dinesafe_data, dinesafe_dest)
write.xlsx(ward_data_2021_census, ward_data_dest)


         
