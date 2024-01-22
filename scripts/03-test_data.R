#### Preamble ####
# Purpose: Tests cleaned dinesafe dataset
# Author: Moohaeng Sohn
# Date: 21 Jan, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run 02-data_cleaning.R and download required libraries


#### Workspace setup ####
library(tidyverse)

#### Load data ####
cleaned_data <- read_csv("outputs/data/cleaned_dinesafe_data.csv")

#### Test data ####
possible_infractions <- c(
  NA,
  "S - Significant",
  "C - Crucial",
  "M - Minor"
)

# Type check
cleaned_data$restaurant |> is.character()
cleaned_data$ward |> is.numeric()
cleaned_data$ward_income |> is.numeric()
cleaned_data$dinesafe_infraction |> is.character()

# Bound check
cleaned_data$ward |> min() >= 1
cleaned_data$ward_income |> min() >= 0

cleaned_data$ward |> max() <= 25  # Only 25 wards in Toronto

# possible values check
# check whether all infractions are in the possible infraction values
cleaned_data$dinesafe_infraction |>
  is.element(possible_infractions)|>
  all()
# check whether wards are all contained within 1 to 25 (all wards in toronto)
cleaned_data$ward |>
  is.element(1:25) |>
  all()

