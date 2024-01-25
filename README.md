# Dinesafe and Toronto's Wards

## Overview

This paper aims to find out the relationship between DineSafe infractions and different wards in Toronto. We have found that while there is near-zero correlation between the ward's median houshold income and DineSafe infraction proportion, we did find that wards on the eastern end of the city commit more crucial infraction while the wards in the center of Toronto commit more minor to signficant infractions.

## File Structure

The repo is structured as:

-   `inputs/data` contains the data sources used in analysis including the raw data.
-   `inputs/sketches` contains sketches made before the paper was written
-   `inputs/LLM` contains conversations with ChatGPT 3.5 that was used for coding for this analysis
-   `outputs/data` contains the cleaned dataset that was constructed.
-   `outputs/paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.

## LLM Usage

LLM (ChatGPT 3.5) was used to assist in coding related to mapping longitude and latitude data and finding wards for that coordinate. For a complete chat log, check `inputs/LLM/usage.txt`. No other LLM was used.
