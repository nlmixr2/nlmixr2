
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nlmixr2

<!-- badges: start -->

![Cran updating
status](https://img.shields.io/badge/CRAN-Not%20Updating-green)
[![R-CMD-check](https://github.com/nlmixr2/nlmixr2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nlmixr2/nlmixr2/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/nlmixr2/nlmixr2/branch/main/graph/badge.svg)](https://app.codecov.io/gh/nlmixr2/nlmixr2?branch=main)
[![CodeFactor](https://www.codefactor.io/repository/github/nlmixr2/nlmixr2/badge)](https://www.codefactor.io/repository/github/nlmixr2/nlmixr2)
[![CRAN
version](http://www.r-pkg.org/badges/version/nlmixr2)](https://cran.r-project.org/package=nlmixr2)
[![CRAN total
downloads](https://cranlogs.r-pkg.org/badges/grand-total/nlmixr2)](https://cran.r-project.org/package=nlmixr2)
[![CRAN total
downloads](https://cranlogs.r-pkg.org/badges/nlmixr2)](https://cran.r-project.org/package=nlmixr2)
<!-- badges: end -->

The vision of nlmixr2 is to develop a R-based open-source nonlinear
mixed-effects modeling software package that can compete with commercial
pharmacometric tools and is suitable for regulatory submissions.

In short, the goal of nlmixr2 is to support easy and robust nonlinear
mixed effects models in R. This is supported by [our team and advisory
committee](https://nlmixr2.org/articles/nlmixr2-team-and-advisory-committee.html)

## Blog for more information

For more information about ongoing development, best practices, and news
about nlmixr2, please see the [nlmixr2 blog](https://blog.nlmixr2.org/).

## Installation

For all versions of R, we need to have a compiler setup to run `nlmixr2`
and `rxode2`

### Windows compilation tools setup

For Windows the compilers come from RTools. Download and the install the
version of RTools for your version of R from
<https://cran.r-project.org/bin/windows/Rtools/>

### Mac compilation tools setup

To setup the mac compilers, simply

1.  Install Xcode from app store

2.  Install gfortran:

    1.  Download and install from <https://mac.r-project.org/tools/>

    2.  Add gfortran directory to the path with:
        `export PATH=$PATH:/usr/local/gfortran/bin`

## R package installation

Installation nlmixr2 itself is easiest the latest version of R because
no further compilation is required and all supporting packages are
available. From R, run:

``` r
install.packages("nlmixr2",dependencies = TRUE)
```

For R-4.0.x and R-4.1.x, the `symengine` package will need to be
downgraded to run in those earlier `R` versions. This can be done by:

``` r
# install.packages("remotes")
remotes::install_version("symengine", version = "0.1.6")
```

followed by:

``` r
install.packages("nlmixr2",dependencies = TRUE)
```

## Checking installation

You can check that your installation is likely setup correctly with the
following command after installing the `nlmixr2` package:

``` r
nlmixr2::nlmixr2CheckInstall()
```

## Development version installation

Once the compilers are setup and a compatible version of `symengine` is
installed, you can install the development version of nlmixr2 and its
nlmixr2-family dependencies either by using the r-universe or by
installing manually.

### Install using the R universe

For many people this is the fastest way to install the development
version of `nlmixr2` since it provides binaries for mac, windows for the
latest and last version of R (no need to wait for a compile).

``` r
install.packages(c("dparser", "nlmixr2data", "lotri", "rxode2ll",
                   "rxode2", "nlmixr2est", "nlmixr2extra", "nlmixr2plot",
                   "nlmixr2"),
                 repos = c('https://nlmixr2.r-universe.dev',
                           'https://cloud.r-project.org'))
```

If you are using a Ubuntu latest flavor (at the time of this writing
`jammy`) you can also use the binaries (though if you use `bspm` you
should install any dependencies first to reduce your computation time)

``` r
# bspm::disable() # if you are using r2u or other ubuntu binary for CRAN
oldOptions <- options()

options(repos=c(
  linux = 'https://nlmixr2.r-universe.dev/bin/linux/jammy/4.2/',
  sources = 'https://nlmixr2.r-universe.dev',
  cran = 'https://cloud.r-project.org'
))
install.packages(c("dparser", "nlmixr2data", "lotri", "rxode2ll",
                   "rxode2", "nlmixr2est", "nlmixr2extra", "nlmixr2plot",
                   "nlmixr2"))

options(oldOptions)
#bspm::enable()
```

Support packages from the R universe can also be installed for the
packages in the `nlmixr2` domain:

``` r
install.packages(c("xpose.nlmixr2", # Additional goodness of fit plots
                                    # baesd on xpose
                   "nlmixr2targets", # Simplify work with the
                                     # `targets` package
                   "babelmixr2", # Convert/run from nlmixr2-based
                                 # models to NONMEM, Monolix, and
                                 # initialize models with PKNCA
                   "nonmem2rx", # Convert from NONMEM to
                                # rxode2/nlmixr2-based models
                   "nlmixr2lib", # a model library and model
                                 # modification functions that
                                 # complement model piping
                   "nlmixr2rpt" # Automated Microsoft Word and
                                # PowerPoint reporting for nlmixr2
                   ),
                 repos = c('https://nlmixr2.r-universe.dev',
                           'https://cloud.r-project.org'))

# Some additional packages outside of the `nlmixr2.r-univers.dev`
# install.packages("remotes")
remotes::install_github("ggPMXdevelopment/ggPMX") # Goodness of fit plots
remotes::install_github("RichardHooijmaijers/shinyMixR") # Shiny run manager (like Piranha)
```

For Ubuntu latest it is similar

``` r
# bspm::disable() # if you are using r2u or other ubuntu binary for CRAN
oldOptions <- options()

options(repos=c(
  linux = 'https://nlmixr2.r-universe.dev/bin/linux/jammy/4.2/',
  sources = 'https://nlmixr2.r-universe.dev',
  cran = 'https://cloud.r-project.org'
))
install.packages(c("xpose.nlmixr2", "nlmixr2targets", "babelmixr2", "nonmem2rx", "nlmixr2lib", "nlmixr2rpt"))

options(oldOptions)
#bspm::enable()
# install.packages("remotes")
remotes::install_github("ggPMXdevelopment/ggPMX") # Goodness of fit plots
remotes::install_github("RichardHooijmaijers/shinyMixR") # Shiny run manager (like Piranha)
```

### Install using `remotes`

This is sure to give the latest development version

``` r
# install.packages("remotes")
remotes::install_github("nlmixr2/dparser-R")
remotes::install_github("nlmixr2/nlmixr2data")
remotes::install_github("nlmixr2/lotri")
remotes::install_github("nlmixr2/rxode2ll")
remotes::install_github("nlmixr2/rxode2")
remotes::install_github("nlmixr2/nlmixr2est")
remotes::install_github("nlmixr2/nlmixr2extra")
remotes::install_github("nlmixr2/nlmixr2plot")
remotes::install_github("nlmixr2/nlmixr2")
```

Optional supporting packages can be installed like so:

``` r
# install.packages("remotes")
# Goodness of fit plots
remotes::install_github("ggPMXdevelopment/ggPMX")
# Additional goodness of fit plots
remotes::install_github("nlmixr2/xpose.nlmixr2")
# Shiny run manager (like Piranha)
remotes::install_github("RichardHooijmaijers/shinyMixR")
# Simplify work with the `targets` package
remotes::install_github("nlmixr2/nlmixr2targets")
# Convert/run from nlmixr2-based models to NONMEM, Monolix, and initialize
# models with PKNCA
remotes::install_github("nlmixr2/babelmixr2")
# Convert from NONMEM to rxode2/nlmixr2-based models
remotes::install_github("nlmixr2/nonmem2rx")
# A library of models and model modification functions
remotes::install_github("nlmixr2/nlmixr2lib")
# Automated Microsoft Word and PowerPoint reporting for nlmixr2
remotes::install_github("nlmixr2/nlmixr2rpt")
```

### Refreshing the installation with the latest CRAN version

If you have difficulties due to errors while compiling models, it may be
useful to re-install all of nlmixr2 and its dependencies. For
development versions, please use the `remotes::install_github()` or the
`install.package()` with the `r-universe` above. For the stable version,
you can get the command with:

``` r
library(nlmixr2)
nlmixr2update()
```

## Example

This is a basic example of a non-linear mixed effect model

``` r
library(nlmixr2)

## The basic model consists of an ini block that has initial estimates
one.compartment <- function() {
  ini({
    tka <- log(1.57); label("Ka")
    tcl <- log(2.72); label("Cl")
    tv <- log(31.5); label("V")
    eta.ka ~ 0.6
    eta.cl ~ 0.3
    eta.v ~ 0.1
    add.sd <- 0.7
  })
  # and a model block with the error specification and model specification
  model({
    ka <- exp(tka + eta.ka)
    cl <- exp(tcl + eta.cl)
    v <- exp(tv + eta.v)
    d/dt(depot) <- -ka * depot
    d/dt(center) <- ka * depot - cl / v * center
    cp <- center / v
    cp ~ add(add.sd)
  })
}

## The fit is performed by the function nlmixr/nlmixr2 specifying the model, data and estimate
fit <- nlmixr2(one.compartment, theo_sd,  est="saem", saemControl(print=0))
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
print(fit)
#> ── nlmixr² SAEM OBJF by FOCEi approximation ──
#> 
#>  Gaussian/Laplacian Likelihoods: AIC() or $objf etc. 
#>  FOCEi CWRES & Likelihoods: addCwres() 
#> 
#> ── Time (sec $time): ──
#> 
#>             setup   optimize covariance preprocess configure  saem postprocess
#> elapsed 0.6147907 3.5104e-05 0.01500671      0.048     1.302 6.394       1.519
#>         table compress     other
#> elapsed 0.051    0.066 0.5331675
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka           Ka 0.456  0.189 41.5       1.58 (1.09, 2.29)     70.4     -0.398 
#> tcl           Cl  1.01 0.0822 8.11       2.76 (2.35, 3.24)     27.2       3.79 
#> tv             V  3.45 0.0432 1.25       31.6 (29.0, 34.4)     13.3       9.73 
#> add.sd           0.697 0.0471 6.75    0.697 (0.605, 0.789)                     
#>  
#>   Covariance Type ($covMethod): sa
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Censoring ($censInformation): No censoring
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 19
#>   ID     TIME    DV  PRED    RES IPRED   IRES  IWRES eta.ka eta.cl   eta.v    cp
#>   <fct> <dbl> <dbl> <dbl>  <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>   <dbl> <dbl>
#> 1 1      0     0.74  0     0.74   0     0.74   1.06   0.105 -0.484 -0.0810  0   
#> 2 1      0.25  2.84  3.26 -0.424  3.87 -1.03  -1.48   0.105 -0.484 -0.0810  3.87
#> 3 1      0.57  6.57  5.84  0.729  6.81 -0.240 -0.344  0.105 -0.484 -0.0810  6.81
#> # ℹ 129 more rows
#> # ℹ 7 more variables: depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>,
#> #   tad <dbl>, dosenum <dbl>
```

# Plotting outputs

## Base R Graphics

You can use the built-in `plot` with the fit and it will produce a
standard set of goodness of fit plots:

``` r
pdf(file="myplots.pdf")
plot(fit)
dev.off()
```

## xpose.nlmixr2

The {xpose.nlmixr2} package extends xpose support for nlmixr2. You
simply need to convert the fit results into an xpose database:

``` r
library(xpose.nlmixr2)
xpdb = xpose_data_nlmixr(fit)
```

Then you can use any of the xpose functions for generating goodness of
fit plots:

``` r
library(xpose)
plt <- dv_vs_ipred(xpdb)
```

## ggPMX

Another option is to use the ggPMX package. You first create a ggPMX
controller object from the nlmixr fit object. Then that controller
object can be used to generate figures:

``` r
library(ggPMX)
ctr = pmx_nlmixr(fit)
pmx_plot_dv_ipred(ctr)
```
