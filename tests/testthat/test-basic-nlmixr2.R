test_that("basic nlmixr tests", {
  one.compartment <- function() {
    ini({
      tka <- 0.45
      tcl <- 1
      tv <- 3.45
      eta.ka ~ 0.6
      eta.cl ~ 0.3
      eta.v ~ 0.1
      add.sd <- 0.7
    })
    model({
      ka <- exp(tka + eta.ka)
      cl <- exp(tcl + eta.cl)
      v <- exp(tv + eta.v)
      d/dt(depot) = -ka * depot
      d/dt(center) = ka * depot - cl / v * center
      cp = center / v
      cp ~ add(add.sd)
    })
  }

  expect_true(inherits(nlmixr(one.compartment), "rxUi"))

  expect_true(inherits(nlmixr2(one.compartment), "rxUi"))

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
    fit <- nlmixr(one.compartment, theo_sd,  est="saem",
                  control=saemControl(print=0, nBurn = 1, nEm = 1))
  )

  expect_equal(fit$ui$modelName, "one.compartment")
  expect_true(inherits(fit, "nlmixr2FitData"))
  expect_error(plot(fit), NA)
})
