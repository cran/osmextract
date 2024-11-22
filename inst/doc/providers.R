## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(osmextract)

## -----------------------------------------------------------------------------
oe_providers()

## -----------------------------------------------------------------------------
names(test_zones)
str(test_zones[, c(2, 6, 7)])

## ----eval = FALSE-------------------------------------------------------------
# file.edit("data-raw/geofabrik_zones.R")

## ----eval = FALSE-------------------------------------------------------------
# file.edit("data-raw/bbbike_zones.R")
# # or, even better, use
# usethis::use_data_raw("bbbike_zones")

