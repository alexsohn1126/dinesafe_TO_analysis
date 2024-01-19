#### Preamble ####
# Purpose: Simulates income and percent of restaurants with dinesafe infractions in Toronto
# Author: Moohaeng Sohn
# Date: 19 Jan 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install tidyverse


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
# set seed
set.seed(302)
simulated_data <- tibble(
  ward = 1:25,
  ward_income = sample(1:100000, 25, replace = TRUE),
  dinesafe_infraction_ratio = rbeta(25, shape1 = 2, shape2 = 6)
)

#### Test data ####
# Type check
simulated_data$ward |> is.numeric()
simulated_data$ward_income |> is.numeric()
simulated_data$dinesafe_infraction_ratio |> is.numeric()

# Bound check
simulated_data$ward |> min() >= 1
simulated_data$ward_income |> min() >= 0
simulated_data$dinesafe_infraction_ratio |> min() >= 0

simulated_data$ward |> max() <= 25  # Only 25 wards in Toronto
simulated_data$dinesafe_infraction_ratio |> max() <= 1

