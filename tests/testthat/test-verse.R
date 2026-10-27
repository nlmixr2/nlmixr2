test_that("core packages attach after optional ones (#419)", {
  core <- .verse$core
  on.exit(.verse$core <- core)
  .updatePackageCore()
  expect_equal(tail(.verse$core, length(core)), core)
})
