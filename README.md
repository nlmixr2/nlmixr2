
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nlmixr2

<!-- badges: start -->

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

The goal of nlmixr2 is to support easy and robust nonlinear mixed
effects models in R

## Installation

For all versions of R, we need to have a compiler setup to run `nlmixr2`
and `rxode2`

### Windows compilation tools setup

For Windows the compilers come from Rtools. For R version 4.2 and above
you need to have Rtools42, for R-4.0.x, and R-4.1.x you need Rtools40.
Download and the install from
<https://cran.r-project.org/bin/windows/Rtools/>

### Mac compilation tools setup

To setup the mac compilers, simply

1.  Install Xcode from app store

2.  Install gfortran:

    1.  Download and install from <https://mac.r-project.org/tools/>

    2.  Add gfortran directory to the path with:
        `export PATH=$PATH:/usr/local/gfortran/bin`

## R package installation

Installation nlmixr2 itself is easiest in R-4.2.x because no further
compilation is required and all supporting packages are available. From
R, run:

``` r
install.packages("nlmixr2",dependencies = TRUE)
```

For R-4.0.x and R-4.1.x, the crucial package symengine is currently not
on CRAN and will have to be installed from MRAN first by running:

``` r
install.packages("symengine", repos="https://cran.microsoft.com/snapshot/2022-01-01/")
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
nlmixr2-family dependencies like so:

``` r
remotes::install_github("nlmixr2/nlmixr2data")
remotes::install_github("nlmixr2/lotri")
remotes::install_github("nlmixr2/rxode2ll")
remotes::install_github("nlmixr2/rxode2parse")
remotes::install_github("nlmixr2/rxode2")
remotes::install_github("nlmixr2/nlmixr2est")
remotes::install_github("nlmixr2/nlmixr2extra")
remotes::install_github("nlmixr2/nlmixr2plot")
remotes::install_github("nlmixr2/nlmixr2")
```

Optional supporting packages can be installed like so:

``` r
remotes::install_github("ggPMXdevelopment/ggPMX") # Goodness of fit plots
remotes::install_github("nlmixr2/xpose.nlmixr2") # Additional goodness of fit plots
remotes::install_github("RichardHooijmaijers/shinyMixR") # Shiny run manager (like Piranha)
remotes::install_github("nlmixr2/nlmixr2targets") # Simplify work with the `targets` package
```

If you have difficulties due to errors while compiling models, it may be
useful to reinstall all of nlmixr2 and its dependencies. For development
versions, please use the `remotes::install_github()` commands above. For
the stable version, please use the following command:

``` r
install.packages(c("dparser", "lotri", "rxode2ll", "rxode2parse",
                   "rxode2random", "rxode2et", "rxode2",
                   "nlmixr2data", "nlmixr2est", "nlmixr2extra",
                   "nlmixr2plot", "nlmixr2", "dparser"))
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(nlmixr2)
#> Warning: package 'nlmixr2' was built under R version 4.2.2

## The basic model consiss of an ini block that has initial estimates
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
  # and a model block with the error sppecification and model specification
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

## The fit is performed by the function nlmixr/nlmix2 specifying the model, data and estimate
fit <- nlmixr2(one.compartment, theo_sd,  est="saem", saemControl(print=0))
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
#>         setup saem table compress other
#> elapsed 0.002 7.27  0.13     0.09 2.888
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka       Log Ka 0.454  0.196 43.1       1.57 (1.07, 2.31)     71.5   -0.0203% 
#> tcl       Log Cl  1.02 0.0853  8.4       2.76 (2.34, 3.26)     27.6      3.46% 
#> tv         Log V  3.45 0.0454 1.32       31.5 (28.8, 34.4)     13.4      9.89% 
#> add.sd           0.693                               0.693                     
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
#> 1 1      0     0.74  0     0.74   0     0.74   1.07   0.103 -0.491 -0.0820  0   
#> 2 1      0.25  2.84  3.27 -0.426  3.87 -1.03  -1.48   0.103 -0.491 -0.0820  3.87
#> 3 1      0.57  6.57  5.85  0.723  6.82 -0.246 -0.356  0.103 -0.491 -0.0820  6.82
#> # … with 129 more rows, and 7 more variables: depot <dbl>, center <dbl>,
#> #   ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>, dosenum <dbl>
```

# Plotting outputs

## Base R Graphics

You can use base plots with the fit and it will produce a standard set
of goodness of fit plots:

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

Another option is to use the ggPMX package. You first creat a ggPMX
controller object from the nlmixr fit object. Then that controller
object can be used to generate figures:

``` r
library(ggPMX)
ctr = pmx_nlmixr(fit)
pmx_plot_dv_ipred(ctr)
```
