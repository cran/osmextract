## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  echo = TRUE,
  collapse = TRUE,
  comment = "#>", 
  fig.align = "center"
)

# save user's pars
user_par = par(no.readonly = TRUE)

## -----------------------------------------------------------------------------
library(osmextract)
library(sf)

## ---- eval = FALSE------------------------------------------------------------
#  lima = tmaptools::geocode_OSM("Lima, Peru")$coords

## ---- echo = FALSE------------------------------------------------------------
lima = c(-77.0365256, -12.0621065)

## ---- warning = FALSE, message = FALSE----------------------------------------
oe_match(lima, provider = "geofabrik")
oe_match(lima, provider = "bbbike")
oe_match(lima, provider = "openstreetmap_fr")

## -----------------------------------------------------------------------------
par(mar = rep(0, 4))
plot(geofabrik_zones[geofabrik_zones$level == 1, "name"], key.pos = NULL, main = NULL)

## -----------------------------------------------------------------------------
plot(geofabrik_zones[geofabrik_zones$level == 2, "name"], key.pos = NULL, main = NULL)

## -----------------------------------------------------------------------------
plot(geofabrik_zones[geofabrik_zones$level == 3, "name"], key.pos = NULL, main = NULL)

## -----------------------------------------------------------------------------
# Russian federation is considered as a level 1 zone
plot(openstreetmap_fr_zones[openstreetmap_fr_zones$level == 1, "name"], key.pos = NULL, main = NULL)

## -----------------------------------------------------------------------------
plot(openstreetmap_fr_zones[openstreetmap_fr_zones$level == 2, "name"], key.pos = NULL, main = NULL)

## -----------------------------------------------------------------------------
plot(openstreetmap_fr_zones[openstreetmap_fr_zones$parent == "china", "name"], key.pos = NULL, main = NULL)

## -----------------------------------------------------------------------------
plot(openstreetmap_fr_zones[openstreetmap_fr_zones$parent == "india", "name"], key.pos = NULL, main = NULL)

## -----------------------------------------------------------------------------
ids_2 = openstreetmap_fr_zones$parent %in% "france"
ids_3 = openstreetmap_fr_zones$parent %in% openstreetmap_fr_zones$id[ids_2]

plot(openstreetmap_fr_zones[ids_2 | ids_3, "name"], key.pos = NULL, main = NULL)

## -----------------------------------------------------------------------------
ids_2 = openstreetmap_fr_zones$parent %in% "brazil"
ids_3 = openstreetmap_fr_zones$parent %in% openstreetmap_fr_zones$id[ids_2]

plot(openstreetmap_fr_zones[ids_2 | ids_3, "name"], key.pos = NULL, main = NULL)

## ---- eval = FALSE------------------------------------------------------------
#  par(mar = rep(0, 4))
#  plot(sf::st_geometry(spData::world))
#  plot(sf::st_geometry(bbbike_zones), border = "darkred", add = TRUE, lwd = 3)

## ---- echo = FALSE, out.width="100%"------------------------------------------
knitr::include_graphics(
  "../man/figures/96640949-3f7f7480-1324-11eb-9dca-a971c8103a4e.png"
)

## ---- include=FALSE-----------------------------------------------------------
par(user_par)

