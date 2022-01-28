#library(YeastPhosphoAtlas)

test_that("internal database can be connected to", {
  con <- get_db_connection()
  expect_true(DBI::dbIsValid(con))
  expect_equal(DBI::dbListTables(con),
               c("condition", "protein",
                 "quantification", "sample",
                 "site"))
})

test_that("protein sites can be queried", {
  sites <- get_sites_by_prot_ref("YHR030C")
  expect_equal(nrow(sites), 7)
  expect_equal(ncol(sites), 3)
})

test_that("quantifications can by queried", {
  quants <- get_quants_by_site_id(15723)
  expect_equal(nrow(quants), 309)
  expect_equal(ncol(quants), 6)
})