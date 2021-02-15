# osmextract 0.2.1

This is a minor release. 

* We modified several examples and tests to fix several errors noticed during CRAN tests (#175). 

# osmextract 0.2.0

Published on CRAN! 

### NEW FEATURES

* Add a `level` parameter to `oe_match()`. It is used to choose between multiple hierarchically nested OSM extracts. The default behaviour is to select the smallest administrative unit (#160).
* Modify the behaviour of `oe_match()`. The function checks all implemented providers in case the input `place` is not matched with any geographical zone for the chosen provider (#155).
* Add a simple interface to Nominatim API that enables `oe_match()` to geolocate text strings that cannot be found in the providers (#155). 

### MINOR IMPROVEMENTS

* Normalise the paths managed by `oe_download_directory` and `oe_download` (#150 and #161) 
* `oe_get_keys` returns an informative error when there is no other_tags field in the input file (#158)

### BUG FIXES

* Fix the structure of `geofabrik_zones` object (#167)
* Fix warning messages related to ... in `oe_get()` (#152)

### DOCUMENTATION FIXES

* Simplify several warning messages in case of spatial matching
* Simplify startup message (#156)
* Add more details related to download timeouts (#145)
* Documented values returned by `oe_find()` and `oe_search()`

# osmextract 0.1.0

* Finish development of the main functions
* Submit to rOpenSci for peer-review
