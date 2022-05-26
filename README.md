---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# nlmixr2

<!-- badges: start -->
<!-- badges: end -->

The goal of nlmixr2 is to support easy and robust nonlinear mixed effects models in R

## Installation

The easiest way to install nlmixr2 is to use:

``` r
install.packages("nlmixr2")
```

You can install the development version of nlmixr2 and its nlmixr2-family dependencies like so:

``` r
remotes::install_github("nlmixr2/nlmixr2data")
remotes::install_github("nlmixr2/lotri")
remotes::install_github("nlmixr2/rxode2")
remotes::install_github("nlmixr2/nlmixr2est")
remotes::install_github("nlmixr2/nlmixr2extra")
remotes::install_github("nlmixr2/nlmixr2plot")
remotes::install_github("nlmixr2/nlmixr2")
```

Optional supporting packages can be installed like so:

``` r
remotes::install_github("ggPMXdevelopment/ggPMX") # Goodness of fit plots
remotes::install_github("nlmixr2/xpose.nlmixr") # Additional goodness of fit plots
remotes::install_github("RichardHooijmaijers/shinyMixR") # Shiny run manager (like Piranha)
remotes::install_github("nlmixr2/nlmixr2targets") # Simplify work with the `targets` package
```

If you have difficulties due to errors while compiling models, it may
be useful to reinstall all of nlmixr2 and its dependencies.  For
development versions, please use the `remotes::install_github()`
commands above.  For the stable version, please use the following
command:

``` r
install.packages(c("nlmixr2", "nlmixr2est", "rxode2", "nlmixr2plot", "nlmixr2data", "lotri", "nlmixr2extra"))
```


## Example

This is a basic example which shows you how to solve a common problem:


```r
library(nlmixr2)
#> Loading required package: nlmixr2data

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
#> 
#>  
#> 
#> ℹ parameter labels from comments will be replaced by 'label()'
#> 
#> → loading into symengine environment...
#> → pruning branches (`if`/`else`) of saem model...
#> ✔ done
#> → finding duplicate expressions in saem model...
#> → optimizing duplicate expressions in saem model...
#> ✔ done
#> → creating rxode2 include directory
#> → getting R compile options
#> → precompiling headers
#> ✔ done
#> rxode2 2.0.7 using 4 threads (see ?getRxThreads)
#> Error in .model$saem_mod(.cfg) : Mat::operator(): index out of bounds
#> Error: Mat::operator(): index out of bounds
print(fit)
#> Error in print(fit): object 'fit' not found
```

# Default plots


```r
plot(fit)
#> Error in plot(fit): object 'fit' not found
```
