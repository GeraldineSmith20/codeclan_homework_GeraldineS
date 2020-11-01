library(tidyverse)
library(janitor)
library(assertr)
meteorites <- read_csv("meteorite_landings.csv")
meteorites <- clean_names(meteorites)
verify(meteorites, colnames(meteorites) == list("id", "name", "mass_g", "fall", "year", "geo_location"))
pattern <- "[0-9]+[.][0-9]+"
meteorites <- meteorites %>% mutate(latitude = str_extract(geo_location, pattern))
pattern2 <- "[,][ ][-]*[0-9]+[.][0-9]+"
pattern3 <- "[-]*[0-9]+[.][0-9]+"
meteorites <- meteorites %>%  mutate(longitude = str_extract(geo_location, pattern2))
meteorites <- meteorites %>% mutate(longitude = str_extract(longitude, pattern3))
meteorites <- meteorites %>% mutate(latitude = as.numeric(latitude))
meteorites <- meteorites %>% mutate(longitude = as.numeric(longitude))
meteorites <- meteorites %>% mutate(latitude = coalesce(latitude, 0, na.rm = TRUE))
meteorites <- meteorites %>% mutate(longitude = coalesce(longitude, 0, na.rm = TRUE))
verify(meteorites, latitude >= -90 & latitude <= 90)
verify(meteorites, longitude >= -180 & latitude <= 180)
meteorites <- meteorites %>% filter(mass_g >= 1000)
meteorites <- meteorites %>% arrange(desc(year))



