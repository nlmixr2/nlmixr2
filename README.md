
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nlmixr2

<!--
## CRAN updating

[![CRAN-status](https://img.shields.io/badge/CRAN-Updating-red)](https://github.com/nlmixr2/rxode2/actions/workflows/R-CMD-check.yaml)

Currently we are updating `PreciseSums` on CRAN; `nlmixr2est` is
linked to `rxode2` which in turn is linked to `PreciseSums`.  While
`PreciseSums`, `rxode2` and `nlmixr2est` are being submitted, the most stable
version of `nlmixr2` comes from the `r-universe`:

```r
install.packages(c("PreciseSums", "dparser", "nlmixr2data", "lotri",
                   "rxode2ll", "rxode2parse", "rxode2random", "rxode2et",
                   "rxode2",  "nlmixr2est", "nlmixr2extra", "nlmixr2plot",
                   "nlmixr2"),
                 repos = c('ttps://nlmixr2.r-universe.dev',
                           'https://cloud.r-project.org'))
```

This is temporary and should resolve itself in a couple of weeks.

You could also compile from source to work around the issue.

-->

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
    
    2.  Add gfortran directory to the path with: `export
        PATH=$PATH:/usr/local/gfortran/bin`

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
please use the following command:

``` r
install.packages(c("dparser", "lotri", "rxode2ll", "rxode2parse",
                   "rxode2random", "rxode2et", "rxode2",
                   "nlmixr2data", "nlmixr2est", "nlmixr2extra",
                   "nlmixr2plot", "nlmixr2"))
```

## Example

This is a basic example which shows you how to solve a common problem:

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
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
print(fit)
#> ── nlmixr² SAEM OBJF by FOCEi approximation ──
#> 
#>  Gaussian/Laplacian Likelihoods: AIC() or $objf etc. 
#>  FOCEi CWRES & Likelihoods: addCwres() 
#> 
#> ── Time (sec $time): ──
#> 
#>           setup covariance  saem table compress    other
#> elapsed 0.00089   0.007004 4.546  0.05    0.018 1.785106
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka           Ka  0.46  0.196 42.7       1.58 (1.08, 2.33)     71.9    -0.291% 
#> tcl           Cl  1.01 0.0839 8.29       2.75 (2.34, 3.25)     27.0      3.42% 
#> tv             V  3.45 0.0469 1.36       31.6 (28.8, 34.7)     14.0      10.7% 
#> add.sd           0.694                               0.694                     
#>  
#>   Covariance Type ($covMethod): linFim
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Censoring ($censInformation): No censoring
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 19
#>   ID     TIME    DV  PRED    RES IPRED   IRES  IWRES eta.ka eta.cl   eta.v    cp
#>   <fct> <dbl> <dbl> <dbl>  <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>   <dbl> <dbl>
#> 1 1      0     0.74  0     0.74   0     0.74   1.07  0.0988 -0.484 -0.0843  0   
#> 2 1      0.25  2.84  3.27 -0.433  3.87 -1.03  -1.49  0.0988 -0.484 -0.0843  3.87
#> 3 1      0.57  6.57  5.85  0.718  6.82 -0.247 -0.356 0.0988 -0.484 -0.0843  6.82
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
