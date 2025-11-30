# Random Effect Covariances

![nlmixr](logo.png)

nlmixr

## Adding Covariances between random effects

You can simply add co-variances between two random effects by adding the
effects together in the model specification block, that is
`eta.cl+eta.v ~`. After that statement, you specify the lower triangular
matrix of the fit with [`c()`](https://rdrr.io/r/base/c.html).

An example of this is the phenobarbitol data:

``` r
## Load phenobarbitol data
library(nlmixr2)
```

### Model Specification

``` r
pheno <- function() {
  ini({
    tcl <- log(0.008) # typical value of clearance
    tv <-  log(0.6)   # typical value of volume
    ## var(eta.cl)
    eta.cl + eta.v ~ c(1, 
                       0.01, 1) ## cov(eta.cl, eta.v), var(eta.v)
                      # interindividual variability on clearance and volume
    add.err <- 0.1    # residual variability
  })
  model({
    cl <- exp(tcl + eta.cl) # individual value of clearance
    v <- exp(tv + eta.v)    # individual value of volume
    ke <- cl / v            # elimination rate constant
    d/dt(A1) = - ke * A1    # model differential equation
    cp = A1 / v             # concentration in plasma
    cp ~ add(add.err)       # define error model
  })
}
```

### Fit with SAEM

``` r
fit <- nlmixr(pheno, pheno_sd, "saem",
              control=list(print=0), 
              table=list(cwres=TRUE, npde=TRUE))
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

print(fit)
#> ── nlmixr² SAEM OBJF by FOCEi approximation ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 689.3203 986.1912 1004.452      -487.0956        6.033342        5.252589
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance   saem table compress
#> elapsed 0.002997    9e-06   0.029018 13.855 4.229    0.001
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>          Est.     SE %RSE    Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tcl     -5.02  0.075  1.5 0.00663 (0.00573, 0.00769)     51.8      3.26% 
#> tv       0.35 0.0548 15.7          1.42 (1.27, 1.58)     41.9      1.40% 
#> add.err  2.76                                   2.76                     
#>  
#>   Covariance Type ($covMethod): linFim
#>   Correlations in between subject variability (BSV) matrix:
#>     cor:eta.v,eta.cl 
#>           0.946  
#>  
#> 
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Censoring ($censInformation): No censoring
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 155 × 26
#>   ID     TIME    DV EPRED  ERES   NPDE     NPD   PDE    PD  PRED    RES    WRES
#>   <fct> <dbl> <dbl> <dbl> <dbl>  <dbl>   <dbl> <dbl> <dbl> <dbl>  <dbl>   <dbl>
#> 1 1        2   17.3  18.9 -1.58 -0.350 -0.0920 0.363 0.463  17.5 -0.162 -0.0214
#> 2 1      112.  31    29.7  1.25  0.245  0.245  0.597 0.597  28.0  2.98   0.244 
#> 3 2        2    9.7  11.4 -1.71 -0.664 -0.202  0.253 0.42   10.5 -0.777 -0.154 
#> # ℹ 152 more rows
#> # ℹ 14 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.cl <dbl>, eta.v <dbl>, A1 <dbl>, cl <dbl>,
#> #   v <dbl>, ke <dbl>, tad <dbl>, dosenum <dbl>
```

### Basic Goodness of Fit Plots

``` r
plot(fit)
```

![](addingCovariances_files/figure-html/unnamed-chunk-5-1.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-2.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-3.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-4.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-5.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-6.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-7.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-8.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-9.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-10.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-11.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-12.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-13.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-14.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-15.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-16.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-17.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-18.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-19.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-20.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-21.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-22.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-23.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-24.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-25.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-26.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-27.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-28.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-29.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-30.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-31.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-32.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-33.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-34.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-35.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-36.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-37.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-38.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-39.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-40.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-41.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-42.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-43.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-44.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-45.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-46.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-47.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-48.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-49.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-50.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-51.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-52.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-53.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-54.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-55.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-56.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-57.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-58.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-59.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-60.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-61.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-62.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-63.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-64.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-65.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-66.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-67.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-68.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-69.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-70.png)![](addingCovariances_files/figure-html/unnamed-chunk-5-71.png)

Those individual plots are not that great, it would be better to see the
actual curves; You can with `augPred`

``` r
plot(augPred(fit))
```

![](addingCovariances_files/figure-html/unnamed-chunk-6-1.png)![](addingCovariances_files/figure-html/unnamed-chunk-6-2.png)![](addingCovariances_files/figure-html/unnamed-chunk-6-3.png)![](addingCovariances_files/figure-html/unnamed-chunk-6-4.png)

### Two types of VPCs

``` r
library(ggplot2)
p1 <- vpcPlot(fit, show=list(obs_dv=TRUE));
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
p1 <- p1 + ylab("Concentrations")

## A prediction-corrected VPC
p2 <- vpcPlot(fit, pred_corr = TRUE, show=list(obs_dv=TRUE))
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
p2 <- p2 + ylab("Prediction-Corrected Concentrations")

library(patchwork)
p1 / p2
```

![](addingCovariances_files/figure-html/unnamed-chunk-7-1.png)
