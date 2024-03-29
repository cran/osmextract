test_that("oe_get_network: simplest examples work", {
  withr::local_envvar(
    .new = list(
      "OSMEXT_DOWNLOAD_DIRECTORY" = tempdir(),
      "TESTTHAT" = "true"
    )
  )
  its_pbf = setup_pbf()

  expect_error(oe_get_network("ITS Leeds", quiet = TRUE), NA)
})

test_that("oe_get_network: options in ... work correctly", {
  withr::local_envvar(
    .new = list(
      "OSMEXT_DOWNLOAD_DIRECTORY" = tempdir(),
      "TESTTHAT" = "true"
    )
  )
  its_pbf = setup_pbf()

  expect_warning(oe_get_network("ITS Leeds", layer = "points", quiet = TRUE))
  expect_message(oe_get_network("ITS Leeds", quiet = TRUE), NA)

  driving_network_with_area_tag = oe_get_network(
    "ITS Leeds",
    mode = "driving",
    extra_tags = "area",
    quiet = TRUE
  )
  expect_true("area" %in% colnames(driving_network_with_area_tag))

  # Cannot use -where arg
  expect_error(
    object = oe_get_network(
      place = "ITS Leeds",
      quiet = TRUE,
      vectortranslate_options = c("-where", "ABC")
    ),
    class = "oe_get_network-cannotUseWhere"
  )

  walking_network_27700 = oe_get_network(
    "ITS Leeds",
    mode = "walking",
    vectortranslate_options = c("-t_srs", "EPSG:27700"),
    quiet = TRUE
  )
  expect_true(sf::st_crs(walking_network_27700) == sf::st_crs("EPSG:27700"))
})
