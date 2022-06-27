test_that("basic nlmixr tests", {

  one.compartment <- function() {
    ini({
      tka <- 0.45 # Log Ka
      tcl <- 1 # Log Cl
      tv <- 3.45    # Log V
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

  expect_true(nlmixr(one.compartment), "rxUi")

  expect_true(nlmixr2(one.compartment), "rxUi")

  fit <- nlmixr(one.compartment, theo_sd,  est="saem",
                control=list(print=0))

  expect_true(inherits(fit, "nlmixr2FitData"))

  expect_error(plot(fit), NA)

})
