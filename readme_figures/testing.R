
#remove.packages("blackmarbler")
devtools::install_github("ramarty/blackmarbler")
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
library(blackmarbler)

bearer <- read.csv("~/Desktop/bearer_bm.csv") %>%
  pull(token)

gha_1_sf <- gadm(country = "GHA", level=1, path = tempdir()) %>% st_as_sf()

r_ntl <- bm_raster(roi_sf = gha_1_sf,
                   product_id = "VNP46A2",
                   date = "2021-01-01",
                   bearer = bearer)

r_ntl <- bm_raster(roi_sf = gha_1_sf,
                   product_id = "VNP46A4",
                   date = 2021,
                   bearer = bearer)

ntl_df <- bm_extract(roi_sf = gha_1_sf,
                     product_id = "VNP46A3",
                     date = "2021-01-01",
                     bearer = bearer)

r_ntl <- bm_raster(roi_sf = gha_1_sf,
                   product_id = "VNP46A3",
                   date = ymd("2020-01-01"),
                   bearer = bearer,
                   variable = "NearNadir_Composite_Snow_Free")

r_ntl2 <- bm_raster(roi_sf = gha_1_sf,
                    product_id = "VNP46A3",
                    date = ymd("2020-01-01"),
                    bearer = bearer,
                    variable = "NearNadir_Composite_Snow_Free_Quality")


roi_sf = gha_1_sf
product_id = "VNP46A3"
date = ymd("2020-01-01")
bearer = bearer
variable = "NearNadir_Composite_Snow_Free_Quality"

output_location_type = "r_memory"
file_dir = NULL
file_prefix = NULL
file_skip_if_exists = TRUE


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


