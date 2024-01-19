#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(sf)

#### Download data ####
# download ward geojson data (to convert lat-long coordinates to wards)
map_ids <- list_package_resources("5e7a8234-f805-43ac-820f-03d7c360b588") |> 
  filter(tolower(format) %in% c('geojson')) |>
  pull(id)

# download dinesafe data
dinesafe_ids <- list_package_resources("ea1d6e57-87af-4e23-b722-6c1f5aa18a8d") |> 
  filter(tolower(format) %in% c('csv')) |>
  pull(id)

# get resources
ward_map_data <- get_resource(map_ids[1])
dinesafe_data <- get_resource(dinesafe_ids[2])

# plot map with all the dinesafe restaurants TODO: COMMENT THIS OUT OR DELETE BEFORE SUBMITTING
ggplot(ward_map_data) +
  geom_sf() +
  geom_point(data = dinesafe_data, aes(x=Longitude, y=Latitude))




#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
#write_csv(the_raw_data, "inputs/data/raw_data.csv") 

         
