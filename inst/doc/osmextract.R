## ----setup, include = FALSE-----------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", 
  fig.align = "center"
)
Sys.setenv(OSMEXT_DOWNLOAD_DIRECTORY = "")

# save user's options and pars
user_options <- options()
user_par <- par(no.readonly = TRUE)

# set new options
options(width = 100)

## -------------------------------------------------------------------------------------------------
library(osmextract)

## -------------------------------------------------------------------------------------------------
oe_providers()

## -------------------------------------------------------------------------------------------------
class(geofabrik_zones)

## -------------------------------------------------------------------------------------------------
library(sf)

## -------------------------------------------------------------------------------------------------
par(mar = rep(0.1, 4))
plot(st_geometry(geofabrik_zones))

## ---- eval = FALSE--------------------------------------------------------------------------------
#  par(mar = rep(0.1, 4))
#  plot(st_geometry(spData::world), xlim = c(-2, 10), ylim = c(35, 60))
#  plot(st_geometry(bbbike_zones), xlim = c(-2, 10), ylim = c(35, 60), col = "darkred", add = TRUE)

## ---- echo = FALSE, out.width="80%"---------------------------------------------------------------
knitr::include_graphics(
  path = "../man/figures/94461461-772e4d00-01ba-11eb-950c-804ad177729f.png"
)

## -------------------------------------------------------------------------------------------------
oe_match("Italy", quiet = TRUE)
oe_match("Leeds", provider = "bbbike", quiet = TRUE)

## -------------------------------------------------------------------------------------------------
oe_match("RU", match_by = "iso3166_1_alpha2")
oe_match("US", match_by = "iso3166_1_alpha2")

## ---- error = TRUE--------------------------------------------------------------------------------
oe_match("PS", match_by = "iso3166_1_alpha2")
oe_match("IL", match_by = "iso3166_1_alpha2")

## -------------------------------------------------------------------------------------------------
oe_match_pattern("London", provider = "geofabrik")
oe_match_pattern("Yorkshire")
oe_match_pattern("Russia")
oe_match_pattern("Palestine")

## -------------------------------------------------------------------------------------------------
oe_match_pattern("US", match_by = "iso3166_2")

## -------------------------------------------------------------------------------------------------
oe_match_pattern("Washington", provider = "bbbike")

## -------------------------------------------------------------------------------------------------
oe_match_pattern("Israel", full_row = TRUE)[, 1:3]

## -------------------------------------------------------------------------------------------------
oe_match_pattern("London")
oe_match("Greater London")

## ---- error = TRUE--------------------------------------------------------------------------------
# erroneous match
oe_match("London", max_string_dist = 3) 

## -------------------------------------------------------------------------------------------------
oe_match("leeds", provider = "geofabrik")

## ---- eval = FALSE--------------------------------------------------------------------------------
#  oe_match("Milan")
#  #> No exact match found for place = Milan and provider = geofabrik. Best match is Iran.
#  #> Checking the other providers.
#  #> No exact match found in any OSM provider data. Searching for the location online.
#  #> .... (other messages explained below)
#  #> $url
#  #> [1] "https://download.geofabrik.de/europe/italy/nord-ovest-latest.osm.pbf"
#  #> $file_size
#  #> [1] 416306623

## ---- warning = TRUE------------------------------------------------------------------------------
oe_match("Belin")

## -------------------------------------------------------------------------------------------------
milan_duomo = sf::st_sfc(sf::st_point(c(1514924, 5034552)), crs = 3003)
oe_match(milan_duomo)

## ---- error = TRUE--------------------------------------------------------------------------------
yak = c(-120.51084, 46.60156)
oe_match(yak, level = 1, quiet = TRUE)
oe_match(yak, level = 2, quiet = TRUE) # the default
oe_match(yak, level = 3, quiet = TRUE) # error

## -------------------------------------------------------------------------------------------------
milan_leeds = st_sfc(
  st_point(c(9.190544, 45.46416)), # Milan
  st_point(c(-1.543789, 53.7974)), # Leeds
  crs = 4326
)
oe_match(milan_leeds)

## -------------------------------------------------------------------------------------------------
milan_leeds_linestring = st_sfc(
  st_linestring(
    rbind(c(9.190544, 45.46416), c(-1.543789, 53.7974))
  ), 
  crs = 4326
)
oe_match(milan_leeds_linestring)

## -------------------------------------------------------------------------------------------------
oe_match(c(9.1916, 45.4650)) # Duomo di Milano using EPSG: 4326

## -------------------------------------------------------------------------------------------------
# ITS stands for Institute for Transport Studies: https://environment.leeds.ac.uk/transport
(its_details = oe_match("ITS Leeds", provider = "test"))

## ---- eval = FALSE--------------------------------------------------------------------------------
#  oe_download(
#    file_url = its_details$url,
#    file_size = its_details$file_size,
#    provider = "test",
#    download_directory = "."
#  )

## ---- eval = FALSE--------------------------------------------------------------------------------
#  usethis::edit_r_environ()
#  # Add a line containing: OSMEXT_DOWNLOAD_DIRECTORY=/path/to/save/files

## -------------------------------------------------------------------------------------------------
oe_download_directory()

## -------------------------------------------------------------------------------------------------
its_pbf = oe_download(its_details$url, provider = "test")
list.files(oe_download_directory(), pattern = "pbf|gpkg")

## -------------------------------------------------------------------------------------------------
its_gpkg = oe_vectortranslate(its_pbf)
list.files(oe_download_directory(), pattern = "pbf|gpkg")

## -------------------------------------------------------------------------------------------------
st_layers(its_pbf, do_count = TRUE)

## -------------------------------------------------------------------------------------------------
st_layers(its_gpkg, do_count = TRUE)

## -------------------------------------------------------------------------------------------------
its_gpkg = oe_vectortranslate(its_pbf, layer = "points")
st_layers(its_gpkg, do_count = TRUE)

## -------------------------------------------------------------------------------------------------
oe_get_keys(its_gpkg, layer = "lines")

## -------------------------------------------------------------------------------------------------
its_gpkg = oe_vectortranslate(its_pbf, extra_tags = c("bicycle", "foot"))

## -------------------------------------------------------------------------------------------------
oe_read(its_gpkg)

## -------------------------------------------------------------------------------------------------
oe_read(its_pbf, skip_vectortranslate = TRUE, quiet = FALSE)

## -------------------------------------------------------------------------------------------------
my_url = "https://github.com/ropensci/osmextract/raw/master/inst/its-example.osm.pbf"
oe_read(my_url, provider = "test", quiet = FALSE, force_download = TRUE, force_vectortranslate = TRUE)

## -------------------------------------------------------------------------------------------------
its_lines = oe_get("ITS Leeds")
par(mar = rep(0.1, 4))
plot(its_lines["highway"], lwd = 2, key.pos = NULL)

## ---- eval = FALSE--------------------------------------------------------------------------------
#  oe_get("Andorra")
#  oe_get("Leeds")
#  oe_get("Goa")
#  oe_get("Malta", layer = "points", quiet = FALSE)
#  oe_match("RU", match_by = "iso3166_1_alpha2", quiet = FALSE)
#  
#  oe_get("Andorra", download_only = TRUE)
#  oe_get_keys(oe_get("Andorra", download_only = TRUE))
#  oe_get("Andorra", extra_tags = c("maxspeed", "oneway", "ref", "junction"), quiet = FALSE)
#  oe_get("Andora", stringsAsFactors = FALSE, quiet = TRUE, as_tibble = TRUE) # like read_sf
#  
#  # Geocode the capital of Goa, India
#  (geocode_panaji = tmaptools::geocode_OSM("Panaji, India"))
#  oe_get(geocode_panaji$coords, quiet = FALSE)
#  oe_get(geocode_panaji$coords, provider = "bbbike", quiet = FALSE)
#  oe_get(geocode_panaji$coords, provider = "openstreetmap_fr", quiet = FALSE)
#  
#  # Spatial match starting from the coordinates of Arequipa, Peru
#  geocode_arequipa = c(-71.537005, -16.398874)
#  oe_get(geocode_arequipa, quiet = FALSE)
#  oe_get(geocode_arequipa, provider = "bbbike", quiet = FALSE) # Error
#  oe_get(geocode_arequipa, provider = "openstreetmap_fr", quiet = FALSE) # No country-specific extract

## -------------------------------------------------------------------------------------------------
custom_osmconf_ini = readLines(system.file("osmconf.ini", package = "osmextract"))

## -------------------------------------------------------------------------------------------------
custom_osmconf_ini[[18]] = "report_all_nodes=yes"
custom_osmconf_ini[[21]] = "report_all_ways=yes"

## -------------------------------------------------------------------------------------------------
custom_osmconf_ini[[45]] = "osm_id=no"
custom_osmconf_ini[[53]] = "attributes=highway,lanes"

## -------------------------------------------------------------------------------------------------
temp_ini = tempfile(fileext = ".ini")
writeLines(custom_osmconf_ini, temp_ini)

## -------------------------------------------------------------------------------------------------
oe_get("ITS Leeds", provider = "test", osmconf_ini = temp_ini, quiet = FALSE)

## -------------------------------------------------------------------------------------------------
oe_get("ITS Leeds", provider = "test", quiet = FALSE, force_vectortranslate = TRUE)

## -------------------------------------------------------------------------------------------------
oe_get("ITS Leeds", provider = "test", osmconf_ini = temp_ini, quiet = FALSE, extra_tags = "foot")

## -------------------------------------------------------------------------------------------------
my_vectortranslate = c(
  "-f", "GPKG", #output file format
  "-overwrite", # overwrite an existing layer
  "-lco", "GEOMETRY_NAME=geometry", # layer creation options, 
  "-t_srs", "EPSG:27700", # British National Grid CRS
  "lines" #layer
)
# Check the CRS
oe_get("ITS Leeds", vectortranslate_options = my_vectortranslate, quiet = FALSE)

## -------------------------------------------------------------------------------------------------
my_vectortranslate = c(
  "-f", "GPKG", # specify the output file format
  "-overwrite", # overwrite an existing layer
  "-lco", "GEOMETRY_NAME=geometry", # layer creation options,
  "-t_srs", "EPSG:27700", # British National Grid CRS
  # SQL-like query where we select only the following fields
  "-select", "osm_id, highway", 
  # SQL-like query where we select only the features where highway is in (footway, cycleway)
  "-where", "highway IN ('footway', 'cycleway')",
  "lines" # we want to read-in the lines layer
)

## -------------------------------------------------------------------------------------------------
its_leeds = oe_get("ITS Leeds", vectortranslate_options = my_vectortranslate, quiet = FALSE)

## ---- eval = FALSE--------------------------------------------------------------------------------
#  # 1. download the data and skip gpkg conversion
#  oe_get("Portugal", download_only = TRUE, skip_vectortranslate = TRUE)
#  
#  # 2. Define the vectortranslate options
#  my_vectortranslate = c(
#    "-f", "GPKG", #output file format
#    "-overwrite", # overwrite an existing file
#    "-lco", "GEOMETRY_NAME=geometry", # layer creation options,
#    # SQL-like query where we select only the features where highway in (primary, secondary, tertiary)
#    "-select", "osm_id, highway",
#    "-where", "highway IN ('primary', 'secondary', 'tertiary')",
#    "lines" #layer
#  )
#  
#  # 3. Convert and read-in
#  system.time({
#    portugal1 = oe_get("Portugal", vectortranslate_options = my_vectortranslate)
#  })
#  #>   user  system elapsed
#  #>  26.77    9.53   35.18

## ---- eval = FALSE--------------------------------------------------------------------------------
#  system.time({
#    portugal2 = oe_get("Portugal", quiet = FALSE, force_vectortranslate = TRUE)
#    portugal2 = portugal2 %>%
#      dplyr::select(osm_id, highway) %>%
#      dplyr::filter(highway %in% c('primary', 'secondary', 'tertiary'))
#  })
#  #>   user  system elapsed
#  #> 144.12   26.40  175.97
#  
#  nrow(portugal1) == nrow(portugal2)
#  #> TRUE

## -------------------------------------------------------------------------------------------------
my_vectortranslate = c(
  "-f", "GPKG",
  "-overwrite",
  "-spat", c(-1.559184 , 53.807739 , -1.557375 , 53.808094 ),
  "lines"
)
its_small = oe_get ("ITS Leeds", vectortranslate_options = my_vectortranslate)

## ---- echo = FALSE, out.width="85%"---------------------------------------------------------------
its_leeds = oe_get("ITS Leeds", force_vectortranslate = TRUE, quiet = TRUE)

par(mar = rep(0.1, 4))
plot(st_geometry(its_leeds), reset = FALSE, col = "grey")
plot(st_geometry(its_small), lwd = 3, col = "darkred", add = TRUE)
plot(st_as_sfc(st_bbox(c(xmin = -1.559184 , ymin = 53.807739 , xmax = -1.557375 , ymax = 53.808094), crs = 4326)), add = TRUE, lwd = 3)

## ---- eval = FALSE--------------------------------------------------------------------------------
#  # 1. Define the polygonal boundary
#  la_valletta = st_sfc(st_point(c(456113.1, 3972853)), crs = 32633) %>%
#    st_buffer(5000)
#  
#  # 2. Define the vectortranslate options
#  my_vectortranslate = c(
#    "-f", "GPKG",
#    "-overwrite",
#    "-t_srs", "EPSG:32633",
#    "-select", "highway",
#    "-where", "highway IN ('primary', 'secondary', 'tertiary', 'unclassified')",
#    "-clipdst", st_as_text(la_valletta),
#    "-nlt", "PROMOTE_TO_MULTI",
#    "lines"
#  )
#  
#  # 3. Read-in data
#  system.time({
#    oe_get("Malta", vectortranslate_options = my_vectortranslate)
#  })
#  #> The input place was matched with: Malta
#  #> The chosen file was already detected in the download directory. Skip downloading.
#  #> Start with the vectortranslate operations on the input file!
#  #> 0...10...20...30...40...50...60...70...80...90...100 - done.
#  #> Finished the vectortranslate operations on the input file!
#  #> Reading layer `lines' from data source `...' using driver `GPKG'
#  #> Simple feature collection with 1206 features and 1 field
#  #> geometry type:  MULTILINESTRING
#  #> dimension:      XY
#  #> bbox:           xmin: 451113.3 ymin: 3967859 xmax: 460364.8 ymax: 3976642
#  #> projected CRS:  WGS 84 / UTM zone 33N
#  #>   user  system elapsed
#  #>   1.87    0.85    3.47

## ---- echo = FALSE, eval = FALSE------------------------------------------------------------------
#  malta_regular = oe_get("Malta", force_vectortranslate = TRUE) %>%
#    dplyr::filter(highway %in% c('primary', 'secondary', 'tertiary', 'unclassified')) %>%
#    st_transform(32633)
#  malta_small = oe_get("Malta", vectortranslate_options = my_vectortranslate)
#  
#  par(mar = rep(0.1, 4))
#  plot(st_geometry(malta_regular), col = "grey", reset = FALSE)
#  plot(st_boundary(la_valletta), add = TRUE, lwd = 2)
#  plot(st_geometry(malta_small), add = TRUE, col = "darkred", lwd = 2)

## ---- echo=FALSE, out.width="80%", fig.align="center"---------------------------------------------
knitr::include_graphics("../man/figures/104240598-9d6fb400-545c-11eb-93b5-3563908ff4af.png")

## ---- eval = FALSE--------------------------------------------------------------------------------
#  system.time({
#    malta_crop = oe_get("Malta", force_vectortranslate = TRUE, force_download = TRUE) %>%
#      dplyr::filter(highway %in% c('primary', 'secondary', 'tertiary', 'unclassified')) %>%
#      st_transform(32633) %>%
#      st_crop(la_valletta)
#  })

## ---- echo = FALSE, eval = FALSE------------------------------------------------------------------
#  malta_regular = oe_get("Malta", force_vectortranslate = TRUE) %>%
#    dplyr::filter(highway %in% c('primary', 'secondary', 'tertiary', 'unclassified')) %>%
#    st_transform(32633)
#  
#  par(mar = rep(0.1, 4))
#  plot(st_geometry(malta_regular), col = "grey", reset = FALSE)
#  plot(st_boundary(la_valletta), add = TRUE, lwd = 2)
#  plot(st_geometry(malta_crop), add = TRUE, col = "darkred", lwd = 2)

## ---- echo=FALSE, out.width="80%", fig.align='center'---------------------------------------------
knitr::include_graphics("../man/figures/104241581-32bf7800-545e-11eb-896b-3f535dd1af5e.png")

## ---- eval = FALSE--------------------------------------------------------------------------------
#  malta_small = oe_get(
#    "Malta",
#    query = "
#    SELECT highway, geometry
#    FROM 'lines'
#    WHERE highway IN ('primary', 'secondary', 'tertiary', 'unclassified')",
#    wkt_filter = st_as_text(st_transform(la_valletta, 4326)),
#    force_vectortranslate = TRUE
#  )

## ---- echo = FALSE, eval = FALSE------------------------------------------------------------------
#  malta_regular = oe_get("Malta", force_vectortranslate = TRUE) %>%
#    dplyr::filter(highway %in% c('primary', 'secondary', 'tertiary', 'unclassified'))
#  
#  par(mar = rep(0.1, 4))
#  plot(st_geometry(malta_regular), col = "grey", reset = FALSE)
#  plot(st_boundary(la_valletta) %>% st_transform(4326), add = TRUE, lwd = 2)
#  plot(st_geometry(malta_small), col = "darkred", add = TRUE, lwd = 2)

## ---- echo = FALSE, fig.align="center", out.width="80%"-------------------------------------------
knitr::include_graphics("../man/figures/104243054-4966ce80-5460-11eb-951b-ca1ce9d09f33.png")

## -------------------------------------------------------------------------------------------------
# No extra tag
colnames(oe_get("ITS Leeds"))

# One extra tag
oe_get_keys(oe_get("ITS Leeds", provider = "test", download_only = TRUE))
colnames(oe_get(
  "ITS Leeds", 
  provider = "test", 
  query = "SELECT *, hstore_get_value(other_tags, 'bicycle') AS bicycle FROM lines"
))

## ---- include=FALSE-----------------------------------------------------------
# reset par and options
options(user_options)
par(user_par)

