# Tests for oe_match ------------------------------------------------------

test_that("oe_match: simplest examples work", {
  expect_match(oe_match("Italy", quiet = TRUE)$url, "italy")
  expect_match(oe_match("Leeds", provider = "bbbike", quiet = TRUE)$url, "Leeds")
})

test_that("oe_match: error with new classes", {
  expect_error(oe_match(c(1 + 2i, 1 - 2i)), class = "oe_match_NoSupportForClass")
  # See #97 for new classes
})

test_that("oe_match: sfc_POINT objects", {
  # simplest example with geofabrik
  milan_duomo = sf::st_sfc(sf::st_point(c(1514924, 5034552)), crs = 3003)
  expect_match(oe_match(milan_duomo, quiet = TRUE)$url, "italy")

  # simplest example with bbbike
  leeds = sf::st_sfc(sf::st_point(c(430147.8, 433551.5)), crs = 27700)
  expect_match(oe_match(leeds, provider = "bbbike", quiet = TRUE)$url, "Leeds")

  # an sfc_POINT object that does not intersect anything
  # the point is in the middle of the atlantic ocean
  ocean = sf::st_sfc(sf::st_point(c(-39.325649, 29.967632)), crs = 4326)
  expect_error(oe_match(ocean, quiet = TRUE), class = "oe_match_noIntersectProvider")
  expect_error(
    oe_match(ocean, provider = "bbbike", quiet = TRUE),
    class = "oe_match_noIntersectProvider"
  )

  # See https://github.com/osmextract/osmextract/issues/98
  # an sfc_POINT that does intersect two cities with bbbike
  # the problem is (or, at least, it should be) less severe with geofabrik
  amsterdam_utrecht = sf::st_sfc(
    sf::st_point(c(4.988327, 52.260453)),
    crs = 4326
  )
  # The point is midway between amsterdam and utrecth, closer to Amsterdam, and
  # it intersects both bboxes
  expect_match(
   oe_match(amsterdam_utrecht, provider = "bbbike", quiet = TRUE)$url,
    "Amsterdam"
  )
})

test_that("oe_match: numeric input", {
  expect_match(oe_match(c(9.1916, 45.4650), quiet = TRUE)$url, "italy")
})

test_that("oe_match: sf input", {
  my_pt = sf::st_as_sf(sf::st_sfc(sf::st_point(c(9.1916, 45.4650)), crs = 4326))
  expect_match(oe_match(my_pt, quiet = TRUE)$url, "italy")
})

test_that("oe_match: different providers, match_by or max_string_dist args", {
  expect_error(oe_match("Italy", provider = "XXX", quiet = TRUE), class = "load_provider_data-InvalidProvider")
  expect_error(oe_match("Italy", match_by = "XXX", quiet = TRUE), class = "oe_match_chosenColumnDoesNotExist")
  expect_match(oe_match("RU", match_by = "iso3166_1_alpha2", quiet = TRUE)$url, "russia")

  # expect_null(oe_match("Isle Wight"))
  # The previous test was removed in #155 since now oe_match calls nominatim servers in
  # case it doesn't find an exact match, so it should never return NULL
  expect_match(oe_match("Isle Wight", max_string_dist = 3, quiet = TRUE)$url, "isle-of-wight")
  expect_message(oe_match("London", max_string_dist = 3, quiet = FALSE))
})

test_that("oe_match: Cannot specify more than one place", {
  # Characters
  expect_error(oe_match(c("Italy", "Spain")), class = "oe_match_characterPlaceLengthOne")
  expect_error(oe_match("Italy", "Spain"), class = "load_provider_data-InvalidProvider")

  # sfc_POINT
  milan_duomo = sf::st_sfc(sf::st_point(c(1514924, 5034552)), crs = 3003) %>%
    sf::st_transform(4326)
  leeds = sf::st_sfc(sf::st_point(c(430147.8, 433551.5)), crs = 27700) %>%
    sf::st_transform(4326)
  # expect_error(oe_match(c(milan_duomo, leeds)))
  expect_error(oe_match(milan_duomo, leeds), class = "load_provider_data-InvalidProvider")

  # numeric
  expect_error(oe_match(c(9.1916, 45.4650, -1.543794, 53.698968)), class = "oe_match_placeLength2")
  expect_error(oe_match(c(9.1916, 45.4650), c(-1.543794, 53.698968)), class = "load_provider_data-InvalidProvider")
})

test_that("oe_match looks for a place location online", {
  skip_on_cran()
  skip_if_offline("github.com")
  skip_on_ci()

  expect_match(
    oe_match("Olginate", quiet = TRUE)$url,
    "italy/nord-ovest-latest\\.osm\\.pbf"
  )
})

test_that("oe_match: error when input place is far from all zones and match_by != name", {
  expect_error(
    object = oe_match("Olginate", match_by = "id", quiet = TRUE),
    class = "oe_match_noTolerableMatchFound"
  )
})

test_that("oe_match: test level parameter", {
  # See https://github.com/ropensci/osmextract/issues/160
  yak = c(-120.51084, 46.60156)

  expect_equal(
    oe_match(yak, level = 1, quiet = TRUE)$url,
    "https://download.geofabrik.de/north-america-latest.osm.pbf"
  )
  expect_equal(
    oe_match(yak, quiet = TRUE)$url,
    "https://download.geofabrik.de/north-america/us/washington-latest.osm.pbf"
  )
  expect_error(
    oe_match(yak, level = 3, quiet = TRUE),
    class = "oe_match_noIntersectLevel"
  )
})

test_that("oe_match:sfc objects with multiple places", {
  milan_duomo = sf::st_sfc(sf::st_point(c(1514924, 5034552)), crs = 3003) %>%
    sf::st_transform(4326)
  leeds = sf::st_sfc(sf::st_point(c(430147.8, 433551.5)), crs = 27700) %>%
    sf::st_transform(4326)
  expect_match(
    oe_match(c(milan_duomo, leeds), quiet = TRUE)$url,
    "https://download.geofabrik.de/europe-latest.osm.pbf"
  )
})

test_that("oe_match can use different providers", {
  expect_match(
    oe_match("leeds", quiet = TRUE)$url,
    "bbbike/Leeds/Leeds\\.osm\\.pbf"
  )
})

test_that("oe_match works with a bbox in input", {
  # See https://github.com/ropensci/osmextract/issues/185
  my_bbox = sf::st_bbox(
    c(xmin = 11.23602, ymin = 47.80478, xmax = 11.88867, ymax = 48.24261),
    crs = 4326
  )
  expect_match(
    oe_match(my_bbox, quiet = TRUE)$url,
    "oberbayern-latest.osm.pbf"
  )
})

test_that("oe_match returns a warning message with missing CRS in bbox input", {
  # See https://github.com/ropensci/osmextract/issues/185#issuecomment-810378795
  my_bbox = sf::st_bbox(
    c(xmin = 11.23602, ymin = 47.80478, xmax = 11.88867, ymax = 48.24261)
  )
  expect_warning(
    oe_match(my_bbox, quiet = TRUE),
    "The input place has no CRS, setting crs = 4326."
  )
})

test_that("oe_match does not create a variable in global env after https://github.com/ropensci/osmextract/pull/246", {
  oe_match("Leeds", quiet = TRUE)
  expect_false(exists("provider", where = .GlobalEnv))
})

# Tests for oe_match_pattern ----------------------------------------------

test_that("oe_match_pattern: simplest examples work", {
  match_yorkshire = oe_match_pattern("Yorkshire")
  expect_gte(length(match_yorkshire), 1)

  match_yorkshire = oe_match_pattern("Yorkshire", full_row = TRUE)
  expect_gte(length(match_yorkshire), 1)

  match_empty_no_place = oe_match_pattern("ABC")
  expect_length(match_empty_no_place, 0L)

  match_empty_no_field = oe_match_pattern("Yorkshire", match_by = "ABC")
  expect_length(match_empty_no_field, 0L)
})

test_that("oe_match_pattern: works with numeric input", {
  skip_on_cran() # since it takes several seconds
  match_milan = oe_match_pattern(c(9, 45))
  expect_gte(length(match_milan), 1)

  match_milan = oe_match_pattern(c(9, 45), full_row = TRUE)
  expect_gte(length(match_milan), 1)

  expect_error(oe_match_pattern(1:3), class = "oe_match_pattern-numericInputLengthNe2")
})

test_that("oe_match_pattern: works with sf/bbox input", {
  skip_on_cran() # since it takes several seconds
  milan = sf::st_bbox(c(xmin = 9.1293, ymin = 45.4399, xmax = 9.2282, ymax = 45.5049))
  expect_warning(oe_match_pattern(milan), "The input has no CRS")
  sf::st_crs(milan) = 4326

  match_milan = oe_match_pattern(milan)
  expect_gte(length(match_milan), 1)

  match_milan = oe_match_pattern(
    sf::st_transform(sf::st_as_sf(sf::st_as_sfc(milan)), 3003),
    full_row = TRUE
  )
  expect_gte(length(match_milan), 1)
})

test_that("oe_match_pattern: test spatial combine", {
  skip_on_cran()
  milan = sf::st_point(c(9, 45))
  palermo = sf::st_point(c(13, 38))
  MI_PA = sf::st_sfc(milan, palermo, crs = 4326)
  expect_identical(oe_match_pattern(MI_PA)$geofabrik, c("Europe", "Italy"))
})

test_that("oe-match: detecting version works", {
  latest_match <- oe_match("Italy", quiet = TRUE)
  expect_true(grepl("latest", latest_match$url))

  version2020_match <- oe_match("Italy", quiet = TRUE, version = "200101")
  expect_true(grepl("200101", version2020_match$url))
})

test_that("oe-match: warning with version and provider", {
  expect_warning(
    oe_match("Leeds", provider = "bbbike", version = "2", quiet = TRUE),
    regexp = "version != 'latest' is only supported for 'geofabrik' provider."
  )
  expect_warning(
    oe_match("Lombardia", version = "ABC", quiet = TRUE),
    regexp = "version != 'latest' is only supported for 'geofabrik' provider."
  )
})
