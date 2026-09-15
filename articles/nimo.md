# Nimotuzumab

![nlmixr](logo.png)

nlmixr

This is an example of a complex model that can be estimated.

In the example below, a target-mediated drug disposition PK model for
nimotuzumab is illustrated (Rodríguez-Vera et al. 2015).

![Model Schematic](nimo_fig1.PNG)

Model Schematic

## nlmixr model

``` r


library(nlmixr2)
library(xpose)
library(xpose.nlmixr2)
library(ggplot2)

nimo <- function() {
  ini({
    ## Note that the UI can take expressions
    ## Also note that these initial estimates should be provided on the log-scale
    tcl <- log(0.001)
    tv1 <- log(1.45)
    tQ <- log(0.004)
    tv2 <- log(44)
    tkss <- log(12)
    tkint <- log(0.3)
    tksyn <- log(1)
    tkdeg <- log(7)
    ## Initial estimates should be high for SAEM ETAs
    eta.cl  ~ 2
    eta.v1  ~ 2
    eta.kss ~ 2
    ##  Also true for additive error (also ignored in SAEM)
    add.err <- 10
  })
  model({
    cl <- exp(tcl + eta.cl)
    v1 <- exp(tv1 + eta.v1)
    Q  <- exp(tQ)
    v2 <- exp(tv2)
    kss <- exp(tkss + eta.kss)
    kint <- exp(tkint)
    ksyn <- exp(tksyn)
    kdeg <- exp(tkdeg)

    k <- cl/v1
    k12 <- Q/v1
    k21 <- Q/v2

    eff(0) <- ksyn/kdeg ##initializing compartment

    ## Concentration is calculated
    conc = 0.5*(central/v1-eff-kss)+0.5*sqrt((central/v1-eff-kss)**2+4*kss*central/v1)

    d/dt(central)  = -(k+k12)*conc*v1+k21*peripheral-kint*eff*conc*v1/(kss+conc)
    d/dt(peripheral) = k12*conc*v1-k21*peripheral  ##Free Drug second compartment amount
    d/dt(eff) = ksyn - kdeg*eff - (kint-kdeg)*conc*eff/(kss+conc)

    IPRED=log(conc)

    IPRED ~ add(add.err)
  })
}
```

## Fit

``` r

fit := nlmixr(nimo, nimoData, est="saem")
```

## Goodness of fit Plots

``` r

## Add cwres/npde after fit
fit  <- fit %>% addCwres() %>% addNpde()
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00

plot(fit) ## Standard nlmixr plots
```

![](nimo_files/figure-html/unnamed-chunk-3-1.png)

![](nimo_files/figure-html/unnamed-chunk-3-2.png)

![](nimo_files/figure-html/unnamed-chunk-3-3.png)

![](nimo_files/figure-html/unnamed-chunk-3-4.png)

![](nimo_files/figure-html/unnamed-chunk-3-5.png)

![](nimo_files/figure-html/unnamed-chunk-3-6.png)

![](nimo_files/figure-html/unnamed-chunk-3-7.png)

![](nimo_files/figure-html/unnamed-chunk-3-8.png)

![](nimo_files/figure-html/unnamed-chunk-3-9.png)

![](nimo_files/figure-html/unnamed-chunk-3-10.png)

![](nimo_files/figure-html/unnamed-chunk-3-11.png)

![](nimo_files/figure-html/unnamed-chunk-3-12.png)

![](nimo_files/figure-html/unnamed-chunk-3-13.png)

![](nimo_files/figure-html/unnamed-chunk-3-14.png)

![](nimo_files/figure-html/unnamed-chunk-3-15.png)

![](nimo_files/figure-html/unnamed-chunk-3-16.png)

![](nimo_files/figure-html/unnamed-chunk-3-17.png)

![](nimo_files/figure-html/unnamed-chunk-3-18.png)

![](nimo_files/figure-html/unnamed-chunk-3-19.png)

![](nimo_files/figure-html/unnamed-chunk-3-20.png)

![](nimo_files/figure-html/unnamed-chunk-3-21.png)

![](nimo_files/figure-html/unnamed-chunk-3-22.png)

![](nimo_files/figure-html/unnamed-chunk-3-23.png)

![](nimo_files/figure-html/unnamed-chunk-3-24.png)

![](nimo_files/figure-html/unnamed-chunk-3-25.png)

![](nimo_files/figure-html/unnamed-chunk-3-26.png)

![](nimo_files/figure-html/unnamed-chunk-3-27.png)

![](nimo_files/figure-html/unnamed-chunk-3-28.png)

![](nimo_files/figure-html/unnamed-chunk-3-29.png)

![](nimo_files/figure-html/unnamed-chunk-3-30.png)

![](nimo_files/figure-html/unnamed-chunk-3-31.png)

![](nimo_files/figure-html/unnamed-chunk-3-32.png)

![](nimo_files/figure-html/unnamed-chunk-3-33.png)

![](nimo_files/figure-html/unnamed-chunk-3-34.png)

![](nimo_files/figure-html/unnamed-chunk-3-35.png)

![](nimo_files/figure-html/unnamed-chunk-3-36.png)

![](nimo_files/figure-html/unnamed-chunk-3-37.png)

![](nimo_files/figure-html/unnamed-chunk-3-38.png)

![](nimo_files/figure-html/unnamed-chunk-3-39.png)

![](nimo_files/figure-html/unnamed-chunk-3-40.png)

![](nimo_files/figure-html/unnamed-chunk-3-41.png)

![](nimo_files/figure-html/unnamed-chunk-3-42.png)

![](nimo_files/figure-html/unnamed-chunk-3-43.png)

![](nimo_files/figure-html/unnamed-chunk-3-44.png)

![](nimo_files/figure-html/unnamed-chunk-3-45.png)

![](nimo_files/figure-html/unnamed-chunk-3-46.png)

![](nimo_files/figure-html/unnamed-chunk-3-47.png)

![](nimo_files/figure-html/unnamed-chunk-3-48.png)

![](nimo_files/figure-html/unnamed-chunk-3-49.png)

![](nimo_files/figure-html/unnamed-chunk-3-50.png)

![](nimo_files/figure-html/unnamed-chunk-3-51.png)

![](nimo_files/figure-html/unnamed-chunk-3-52.png)

![](nimo_files/figure-html/unnamed-chunk-3-53.png)

![](nimo_files/figure-html/unnamed-chunk-3-54.png)

![](nimo_files/figure-html/unnamed-chunk-3-55.png)

![](nimo_files/figure-html/unnamed-chunk-3-56.png)

![](nimo_files/figure-html/unnamed-chunk-3-57.png)

![](nimo_files/figure-html/unnamed-chunk-3-58.png)

![](nimo_files/figure-html/unnamed-chunk-3-59.png)

![](nimo_files/figure-html/unnamed-chunk-3-60.png)

![](nimo_files/figure-html/unnamed-chunk-3-61.png)

![](nimo_files/figure-html/unnamed-chunk-3-62.png)

![](nimo_files/figure-html/unnamed-chunk-3-63.png)

![](nimo_files/figure-html/unnamed-chunk-3-64.png)

![](nimo_files/figure-html/unnamed-chunk-3-65.png)

![](nimo_files/figure-html/unnamed-chunk-3-66.png)

![](nimo_files/figure-html/unnamed-chunk-3-67.png)

![](nimo_files/figure-html/unnamed-chunk-3-68.png)

![](nimo_files/figure-html/unnamed-chunk-3-69.png)

![](nimo_files/figure-html/unnamed-chunk-3-70.png)

![](nimo_files/figure-html/unnamed-chunk-3-71.png)

![](nimo_files/figure-html/unnamed-chunk-3-72.png)

![](nimo_files/figure-html/unnamed-chunk-3-73.png)

![](nimo_files/figure-html/unnamed-chunk-3-74.png)

``` r


################################################################################
## Xpose plots; Need to print otherwise running a script won't
## show xpose plots
################################################################################
xpdb <- xpose_data_nlmixr(fit) ## first convert to nlmixr object

print(dv_vs_pred(xpdb) +
      ylab("Observed Nimotuzumab Concentrations (ug/mL)") +
      xlab("Population Predicted Nimotuzumab Concentrations (ug/mL)"))
```

![](nimo_files/figure-html/unnamed-chunk-3-75.png)

``` r


print(dv_vs_ipred(xpdb) +
      ylab("Observed Nimotuzumab Concentrations (ug/mL)") +
      xlab("Individual Predicted Nimotuzumab Concentrations (ug/mL)"))
```

![](nimo_files/figure-html/unnamed-chunk-3-76.png)

``` r


print(res_vs_pred(xpdb) +
      ylab("Conditional Weighted Residuals") +
      xlab("Population Predicted Nimotuzumab Concentrations (ug/mL)"))
```

![](nimo_files/figure-html/unnamed-chunk-3-77.png)

``` r


print(res_vs_idv(xpdb) +
      ylab("Conditional Weighted Residuals") +
      xlab("Time (h)"))
```

![](nimo_files/figure-html/unnamed-chunk-3-78.png)

``` r


print(prm_vs_iteration(xpdb))
```

![](nimo_files/figure-html/unnamed-chunk-3-79.png)

``` r


print(absval_res_vs_idv(xpdb, res = 'IWRES') +
      ylab("Individual Weighted Residuals") +
      xlab("Time (h)"))
```

![](nimo_files/figure-html/unnamed-chunk-3-80.png)

``` r


print(absval_res_vs_pred(xpdb, res = 'IWRES') +
      ylab("Individual Weighted Residuals") +
      xlab("Population Predicted Nimotuzumab Concentrations (ug/mL)"))
```

![](nimo_files/figure-html/unnamed-chunk-3-81.png)

``` r


print(ind_plots(xpdb, nrow=3, ncol=4) +
      ylab("Predicted and Observed Nimotuzumab concentrations (ug/mL)") +
      xlab("Time (h)"))
```

![](nimo_files/figure-html/unnamed-chunk-3-82.png)

``` r


print(res_distrib(xpdb) +
     ylab("Density") +
     xlab("Conditional Weighted Residuals"))
```

![](nimo_files/figure-html/unnamed-chunk-3-83.png)

``` r


################################################################################
##Visual Predictive Checks
################################################################################
vpcPlot(fit,n=500,stratify=c("DOS"), show=list(obs_dv=T),
       bins = c(-0.5,0,25,75,100,200,400,600,750,900,1100,1200,1400,1600,1900,2150,2300),
       ylab = "Nimotuzumab Concentrations (ug/mL)", xlab = "Time (h)")
```

![](nimo_files/figure-html/unnamed-chunk-3-84.png)

``` r


vpcPlot(fit,n=500, show=list(obs_dv=T),
       bins = c(-0.5,0,25,75,100,200,400,600,750,900,1100,1200,1400,1600,1900,2150,2300),
       ylab = "Nimotuzumab Concentrations (ug/mL)", xlab = "Time (h)")
```

![](nimo_files/figure-html/unnamed-chunk-3-85.png)
