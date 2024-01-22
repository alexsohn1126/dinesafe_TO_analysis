#### Preamble ####
# Purpose: Simulates income and percent of restaurants with dinesafe infractions in Toronto
# Author: Moohaeng Sohn
# Date: 21 Jan, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install tidyverse


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
# set seed
set.seed(302)

# Possible infraction values
possible_infractions <- c(
  NA,
  "S - Significant",
  "C - Crucial",
  "M - Minor"
)

# Make up some names
restaurants <- c(
  "Alex's Restaurant",
  "Mcdoggies",
  "Cooking food with STA302",
  "Pain and Suffering",
  "Existential Crisis"
)

ward_income_sim <- sample(30000:90000, 25, replace = TRUE)

n_sample = 100
simulated_data <- tibble(
  restaurant = sample(restaurants, n_sample, replace = TRUE),
  infraction = sample(possible_infractions, n_sample, replace = TRUE),
  ward = sample(1:25, n_sample, replace = TRUE),
  ward_income = sample(ward_income_sim, n_sample, replace = TRUE)
)

#### Test data ####
# Type check
simulated_data$restaurant |> is.character()
simulated_data$ward |> is.numeric()
simulated_data$ward_income |> is.numeric()
simulated_data$infraction |> is.character()

# Bound check
simulated_data$ward |> min() >= 1
simulated_data$ward_income |> min() >= 0

simulated_data$ward |> max() <= 25  # Only 25 wards in Toronto

# possible values check
# check whether all infractions are in the possible infraction values
simulated_data$infraction |>
  is.element(possible_infractions) |>
  all()

# check whether wards are all contained within 1 to 25 (all wards in toronto)
simulated_data$ward |>
  is.element(1:25) |>
  all()

