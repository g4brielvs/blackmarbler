
library(purrr)
library(furrr)
library(stringr)
library(rhdf5)
library(raster)
library(dplyr)
library(sf)
library(lubridate)
library(geodata)
library(exactextractr)

bearer <- read.csv("~/Desktop/bearer_bm.csv") %>%
  pull(token)

gha_1_sf <- gadm(country = "GHA", level=1, path = tempdir()) %>% st_as_sf()

r <- bm_raster(roi_sf = gha_1_sf,
               product_id = "VNP46A4",
               date = 2019:2020,
               bearer = bearer,
               output_type = "aggregation",
               output_location_type = "file",
               aggregation_fun = c("mean", "median"),
               file_dir = "~/Desktop/bmtest",
               file_prefix = NULL,
               file_skip_if_exists = TRUE)


