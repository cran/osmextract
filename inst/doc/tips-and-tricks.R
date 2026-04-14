## ----include = FALSE------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", 
  fig.align = "center"
)

# save user's options and pars
user_options = options()
user_par = par(no.readonly = TRUE)

# save files in the tempdir
old_dd = Sys.getenv("OSMEXT_DOWNLOAD_DIRECTORY", tempdir())
Sys.setenv(OSMEXT_DOWNLOAD_DIRECTORY = tempdir())

its_pbf = file.path(
  osmextract::oe_download_directory(), 
  "test_its-example.osm.pbf"
)
file.copy(
  from = system.file("its-example.osm.pbf", package = "osmextract"), 
  to = its_pbf, 
  overwrite = TRUE
)

# set new options
options(width = 100)

## ----setup----------------------------------------------------------------------------------------
library(osmextract)

## -------------------------------------------------------------------------------------------------
osm_id <- c("4419868", "6966733", "7989989", "15333726", "31705837")

out <- oe_get(
  place = "ITS Leeds",
  query = paste0(
    "SELECT * FROM lines WHERE osm_id IN (", paste0(osm_id, collapse = ","), ")"
  ), 
  quiet = TRUE
)
print(out, n = 0L)

## ----include=FALSE------------------------------------------------------------
# reset par, options, and download directory
options(user_options)
par(user_par)
Sys.setenv(OSMEXT_DOWNLOAD_DIRECTORY = old_dd)

