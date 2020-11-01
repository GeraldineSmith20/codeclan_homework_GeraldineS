#Meteorites Project

This project analyses data from NASA, which records meteorites that have either landed or been ound on earth since 1583.

weekend_homework.R
==================
This file performs the following functions
- loads in the R packages required for analysis (tidyverse, janitor and assertr)
- loads in the supplied data (in .csv format) and stores this as variable "meteorites""
- verifies that the data contains the correct column names required for analysis
- splits the geolocation column into latitude and longitude figures, ensuring they are stored as numbers
- verifies latitude and longitude values are in the correct range
- removes meteorite data observations with mass less than 1000 g
- arranges the remaining data set by year, descending.

main_script_meteorites.Rmd
==========================

This script performs the following analysis of the supplied data
- summarises the number of NA values in each column
- displays the meteorites with the 10 largest mass values, ignoring values where year was not recorded
- groups observations by fall type and displays the average mass for each group - fell and found
- counts the number of meteorite observations per year and displays these from 2000 to 2013.