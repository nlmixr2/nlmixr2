test_that("ini piping", {
  model <- function () {
    description <- "One compartment PK model with linear clearance"
    ini({
      lka <- 0.45
      label("Absorption rate (Ka)")
      lcl <- 1
      label("Clearance (CL)")
      lvc <- 3.45
      label("Central volume of distribution (V)")
      prop.err <- c(0, 0.5)
      label("Proportional residual error (fraction)")
    })
    model({
      ka <- exp(lka + etalka)
      cl <- exp(lcl)
      vc <- exp(lvc)
      linCmt() ~ prop(prop.err)
    })
  }

  suppressMessages(
    expect_error(ini(model, etalka~1), NA)
  )
})
