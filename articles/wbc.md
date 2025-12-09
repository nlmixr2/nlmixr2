# Friberg myelosuppression model

``` r
library(nlmixr2)
```

``` r
wbc <- function() {
  ini({
    ## Note that the UI can take expressions
    ## Also note that these initial estimates should be provided on the log-scale
    log_CIRC0 <- log(7.21)
    log_MTT <- log(124)
    log_SLOPU <- log(28.9)
    log_GAMMA <- log(0.239)
    ## Initial estimates should be high for SAEM ETAs
    eta.CIRC0  ~ .1
    eta.MTT  ~ .03
    eta.SLOPU ~ .2
    ##  Also true for additive error (also ignored in SAEM)
    prop.err <- 10
  })
  model({
    CIRC0 = exp(log_CIRC0 + eta.CIRC0)
    MTT = exp(log_MTT + eta.MTT)
    SLOPU = exp(log_SLOPU + eta.SLOPU)
    GAMMA = exp(log_GAMMA)

    # PK parameters from input dataset
    CL = CLI
    V1 = V1I
    V2 = V2I
    Q = 204

    CONC = centr/V1

    # PD parameters
    NN = 3
    KTR = (NN + 1)/MTT
    EDRUG = 1 - SLOPU * CONC
    FDBK = (CIRC0 / circ)^GAMMA

    CIRC = circ

    prol(0) = CIRC0
    tr1(0) = CIRC0
    tr2(0) = CIRC0
    tr3(0) = CIRC0
    circ(0) = CIRC0

    d/dt(centr) = periph * Q/V2 - centr * (CL/V1 + Q/V1)
    d/dt(periph) = centr * Q/V1 - periph * Q/V2
    d/dt(prol) = KTR * prol * EDRUG * FDBK - KTR * prol
    d/dt(tr1) = KTR * prol - KTR * tr1
    d/dt(tr2) = KTR * tr1 - KTR * tr2
    d/dt(tr3) = KTR * tr2 - KTR * tr3
    d/dt(circ) = KTR * tr3 - KTR * circ

    CIRC ~ prop(prop.err)
  })
}
```

## Fit model using saem

``` r
d3 <- read.csv("Simulated_WBC_pacl_ddmore_samePK_nlmixr.csv", na.strings = ".")

fit.S <- nlmixr(wbc, d3, est="saem", list(print=0), table=list(cwres=TRUE, npde=TRUE))
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:03
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00

library(xpose.nlmixr2)

xpdb <- xpose_data_nlmixr(fit.S)

plot(fit.S)
```

![](wbc_files/figure-html/saem-1.png)![](wbc_files/figure-html/saem-2.png)![](wbc_files/figure-html/saem-3.png)![](wbc_files/figure-html/saem-4.png)![](wbc_files/figure-html/saem-5.png)![](wbc_files/figure-html/saem-6.png)![](wbc_files/figure-html/saem-7.png)![](wbc_files/figure-html/saem-8.png)![](wbc_files/figure-html/saem-9.png)![](wbc_files/figure-html/saem-10.png)![](wbc_files/figure-html/saem-11.png)![](wbc_files/figure-html/saem-12.png)![](wbc_files/figure-html/saem-13.png)![](wbc_files/figure-html/saem-14.png)![](wbc_files/figure-html/saem-15.png)![](wbc_files/figure-html/saem-16.png)![](wbc_files/figure-html/saem-17.png)![](wbc_files/figure-html/saem-18.png)![](wbc_files/figure-html/saem-19.png)![](wbc_files/figure-html/saem-20.png)![](wbc_files/figure-html/saem-21.png)![](wbc_files/figure-html/saem-22.png)![](wbc_files/figure-html/saem-23.png)![](wbc_files/figure-html/saem-24.png)![](wbc_files/figure-html/saem-25.png)![](wbc_files/figure-html/saem-26.png)![](wbc_files/figure-html/saem-27.png)![](wbc_files/figure-html/saem-28.png)![](wbc_files/figure-html/saem-29.png)![](wbc_files/figure-html/saem-30.png)![](wbc_files/figure-html/saem-31.png)![](wbc_files/figure-html/saem-32.png)![](wbc_files/figure-html/saem-33.png)![](wbc_files/figure-html/saem-34.png)![](wbc_files/figure-html/saem-35.png)![](wbc_files/figure-html/saem-36.png)![](wbc_files/figure-html/saem-37.png)![](wbc_files/figure-html/saem-38.png)![](wbc_files/figure-html/saem-39.png)![](wbc_files/figure-html/saem-40.png)![](wbc_files/figure-html/saem-41.png)![](wbc_files/figure-html/saem-42.png)![](wbc_files/figure-html/saem-43.png)![](wbc_files/figure-html/saem-44.png)![](wbc_files/figure-html/saem-45.png)![](wbc_files/figure-html/saem-46.png)![](wbc_files/figure-html/saem-47.png)![](wbc_files/figure-html/saem-48.png)![](wbc_files/figure-html/saem-49.png)![](wbc_files/figure-html/saem-50.png)![](wbc_files/figure-html/saem-51.png)![](wbc_files/figure-html/saem-52.png)![](wbc_files/figure-html/saem-53.png)![](wbc_files/figure-html/saem-54.png)![](wbc_files/figure-html/saem-55.png)![](wbc_files/figure-html/saem-56.png)![](wbc_files/figure-html/saem-57.png)![](wbc_files/figure-html/saem-58.png)![](wbc_files/figure-html/saem-59.png)![](wbc_files/figure-html/saem-60.png)![](wbc_files/figure-html/saem-61.png)![](wbc_files/figure-html/saem-62.png)![](wbc_files/figure-html/saem-63.png)![](wbc_files/figure-html/saem-64.png)![](wbc_files/figure-html/saem-65.png)![](wbc_files/figure-html/saem-66.png)![](wbc_files/figure-html/saem-67.png)![](wbc_files/figure-html/saem-68.png)![](wbc_files/figure-html/saem-69.png)![](wbc_files/figure-html/saem-70.png)

``` r
print(dv_vs_pred(xpdb) +
      ylab("Observed Neutrophil Count (10^9/L)") +
      xlab("Population Predicted Neutrophil Count (10^9/L)"))
```

![](wbc_files/figure-html/saem-71.png)

``` r

print(dv_vs_ipred(xpdb) +
      ylab("Observed Neutrophil Count (10^9/L)") +
      xlab("Individual Predicted Neutrophil Count (10^9/L)"))
```

![](wbc_files/figure-html/saem-72.png)

``` r

print(res_vs_pred(xpdb) +
      ylab("Conditional Weighted Residuals") +
      xlab("Population Predicted Neutrophil Count (10^9/L)"))
```

![](wbc_files/figure-html/saem-73.png)

``` r

print(res_vs_idv(xpdb) +
      ylab("Conditional Weighted Residuals") +
      xlab("Time (h)"))
```

![](wbc_files/figure-html/saem-74.png)

``` r

print(prm_vs_iteration(xpdb))
```

![](wbc_files/figure-html/saem-75.png)

``` r

print(absval_res_vs_idv(xpdb, res = 'IWRES') +
      ylab("Individual Weighted Residuals") +
      xlab("Time (h)"))
```

![](wbc_files/figure-html/saem-76.png)

``` r

print(absval_res_vs_pred(xpdb, res = 'IWRES') +
      ylab("Individual Weighted Residuals") +
      xlab("Population Predicted Neutrophil Count (10^9/L)"))
```

![](wbc_files/figure-html/saem-77.png)

``` r

print(ind_plots(xpdb, nrow=3, ncol=4) +
      ylab("Predicted and Observed Neutrophil Count (10^9/L)") +
      xlab("Time (h)"))
```

![](wbc_files/figure-html/saem-78.png)![](wbc_files/figure-html/saem-79.png)![](wbc_files/figure-html/saem-80.png)![](wbc_files/figure-html/saem-81.png)

``` r

print(res_distrib(xpdb) +
      ylab("Density") +
      xlab("Conditional Weighted Residuals"))
```

![](wbc_files/figure-html/saem-82.png)

``` r

vpcPlot(fit.S, n=500, n_bins = 10, show=list(obs_dv=TRUE),
        ylab = "Neutrophil Count (10^9/L)", xlab = "Time (h)")
#> [====|====|====|====|====|====|====|====|====|====] 0:00:05
```

![](wbc_files/figure-html/saem-83.png)

``` r

vpcPlot(fit.S, n=500, bins = c(0,170,300,350,500,600,900,3000,4580),
        show=list(obs_dv=TRUE), ylab = "Neutrophil Count (10^9/L)", xlab = "Time (h)")
#> [====|====|====|====|====|====|====|====|====|====] 0:00:05
```

![](wbc_files/figure-html/saem-84.png)

## Fit model using FOCEi

``` r
fit.F <- nlmixr(wbc, d3, est="focei", list(print=0), table=list(cwres=TRUE, npde=TRUE))
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:26 
#> done
#> [====|====|====|====|====|====|====|====|====|====] 0:00:03
```

### FOCEi goodness of fit plots

``` r
xpdb <- xpose_data_nlmixr(fit.F)
plot(fit.F)
```

![](wbc_files/figure-html/foceiGof-1.png)![](wbc_files/figure-html/foceiGof-2.png)![](wbc_files/figure-html/foceiGof-3.png)![](wbc_files/figure-html/foceiGof-4.png)![](wbc_files/figure-html/foceiGof-5.png)![](wbc_files/figure-html/foceiGof-6.png)![](wbc_files/figure-html/foceiGof-7.png)![](wbc_files/figure-html/foceiGof-8.png)![](wbc_files/figure-html/foceiGof-9.png)![](wbc_files/figure-html/foceiGof-10.png)![](wbc_files/figure-html/foceiGof-11.png)![](wbc_files/figure-html/foceiGof-12.png)![](wbc_files/figure-html/foceiGof-13.png)![](wbc_files/figure-html/foceiGof-14.png)![](wbc_files/figure-html/foceiGof-15.png)![](wbc_files/figure-html/foceiGof-16.png)![](wbc_files/figure-html/foceiGof-17.png)![](wbc_files/figure-html/foceiGof-18.png)![](wbc_files/figure-html/foceiGof-19.png)![](wbc_files/figure-html/foceiGof-20.png)![](wbc_files/figure-html/foceiGof-21.png)![](wbc_files/figure-html/foceiGof-22.png)![](wbc_files/figure-html/foceiGof-23.png)![](wbc_files/figure-html/foceiGof-24.png)![](wbc_files/figure-html/foceiGof-25.png)![](wbc_files/figure-html/foceiGof-26.png)![](wbc_files/figure-html/foceiGof-27.png)![](wbc_files/figure-html/foceiGof-28.png)![](wbc_files/figure-html/foceiGof-29.png)![](wbc_files/figure-html/foceiGof-30.png)![](wbc_files/figure-html/foceiGof-31.png)![](wbc_files/figure-html/foceiGof-32.png)![](wbc_files/figure-html/foceiGof-33.png)![](wbc_files/figure-html/foceiGof-34.png)![](wbc_files/figure-html/foceiGof-35.png)![](wbc_files/figure-html/foceiGof-36.png)![](wbc_files/figure-html/foceiGof-37.png)![](wbc_files/figure-html/foceiGof-38.png)![](wbc_files/figure-html/foceiGof-39.png)![](wbc_files/figure-html/foceiGof-40.png)![](wbc_files/figure-html/foceiGof-41.png)![](wbc_files/figure-html/foceiGof-42.png)![](wbc_files/figure-html/foceiGof-43.png)![](wbc_files/figure-html/foceiGof-44.png)![](wbc_files/figure-html/foceiGof-45.png)![](wbc_files/figure-html/foceiGof-46.png)![](wbc_files/figure-html/foceiGof-47.png)![](wbc_files/figure-html/foceiGof-48.png)![](wbc_files/figure-html/foceiGof-49.png)![](wbc_files/figure-html/foceiGof-50.png)![](wbc_files/figure-html/foceiGof-51.png)![](wbc_files/figure-html/foceiGof-52.png)![](wbc_files/figure-html/foceiGof-53.png)![](wbc_files/figure-html/foceiGof-54.png)![](wbc_files/figure-html/foceiGof-55.png)![](wbc_files/figure-html/foceiGof-56.png)![](wbc_files/figure-html/foceiGof-57.png)![](wbc_files/figure-html/foceiGof-58.png)![](wbc_files/figure-html/foceiGof-59.png)![](wbc_files/figure-html/foceiGof-60.png)![](wbc_files/figure-html/foceiGof-61.png)![](wbc_files/figure-html/foceiGof-62.png)![](wbc_files/figure-html/foceiGof-63.png)![](wbc_files/figure-html/foceiGof-64.png)![](wbc_files/figure-html/foceiGof-65.png)![](wbc_files/figure-html/foceiGof-66.png)![](wbc_files/figure-html/foceiGof-67.png)![](wbc_files/figure-html/foceiGof-68.png)![](wbc_files/figure-html/foceiGof-69.png)![](wbc_files/figure-html/foceiGof-70.png)

``` r
print(dv_vs_pred(xpdb) +
      ylab("Observed Neutrophil Count (10^9/L)") +
      xlab("Population Predicted Neutrophil Count (10^9/L)"))
```

![](wbc_files/figure-html/foceiGof-71.png)

``` r

print(dv_vs_ipred(xpdb) +
      ylab("Observed Neutrophil Count (10^9/L)") +
      xlab("Individual Predicted Neutrophil Count (10^9/L)"))
```

![](wbc_files/figure-html/foceiGof-72.png)

``` r

print(res_vs_pred(xpdb) +
      ylab("Conditional Weighted Residuals") +
      xlab("Population Predicted Neutrophil Count (10^9/L)"))
```

![](wbc_files/figure-html/foceiGof-73.png)

``` r

print(res_vs_idv(xpdb) +
      ylab("Conditional Weighted Residuals") +
      xlab("Time (h)"))
```

![](wbc_files/figure-html/foceiGof-74.png)

``` r

print(absval_res_vs_idv(xpdb, res = 'IWRES') +
      ylab("Individual Weighted Residuals") +
      xlab("Time (h)"))
```

![](wbc_files/figure-html/foceiGof-75.png)

``` r

print(absval_res_vs_pred(xpdb, res = 'IWRES') +
      ylab("Individual Weighted Residuals") +
      xlab("Population Predicted Neutrophil Count (10^9/L)"))
```

![](wbc_files/figure-html/foceiGof-76.png)

``` r

print(ind_plots(xpdb, nrow=3, ncol=4) +
      ylab("Predicted and Observed Neutrophil Count (10^9/L)") +
      xlab("Time (h)"))
```

![](wbc_files/figure-html/foceiGof-77.png)![](wbc_files/figure-html/foceiGof-78.png)![](wbc_files/figure-html/foceiGof-79.png)![](wbc_files/figure-html/foceiGof-80.png)

``` r

print(res_distrib(xpdb) +
      ylab("Density") +
      xlab("Conditional Weighted Residuals"))
```

![](wbc_files/figure-html/foceiGof-81.png)

``` r

# 10 bins is slightly better than auto bin
vpcPlot(fit.F, n=500, n_bins = 10, show=list(obs_dv=TRUE),
        ylab = "Neutrophil Count (10^9/L)", xlab = "Time (h)")
#> [====|====|====|====|====|====|====|====|====|====] 0:00:05
```

![](wbc_files/figure-html/foceiGof-82.png)

``` r

# specify bins
vpcPlot(fit.F, n=500, bins = c(0, 170, 300, 350, 500, 600, 900, 3000, 4580),
        show=list(obs_dv=TRUE),
        ylab = "Neutrophil Count (10^9/L)", xlab = "Time (h)")
#> [====|====|====|====|====|====|====|====|====|====] 0:00:05
```

![](wbc_files/figure-html/foceiGof-83.png)
