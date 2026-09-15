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

fit := nlmixr(pheno, pheno_sd, "saem",
              control=list(print=0),
              table=list(cwres=TRUE, npde=TRUE))

print(fit)
#> ── nlmixr² SAEM OBJF by FOCEi approximation ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 688.7367 985.6076 1003.868      -486.8038        20.63833        19.53368
#> 
#> ── Time (sec $time): ──
#> 
#>              setup   optimize covariance preprocess configure  saem postprocess
#> elapsed 0.08438001 3.4232e-05 0.02600548      0.033     1.171 9.861       0.012
#>         table compress
#> elapsed 3.617    0.084
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>          Est.        SE      %RSE    Back-transformed(95%CI) BSV(CV%)
#> tcl     -5.00    0.0663      1.33 0.00671 (0.00589, 0.00764)     51.8
#> tv      0.347    0.0530      15.3          1.41 (1.27, 1.57)     41.6
#> add.err  2.78 6.95e-310 2.50e-308          2.78 (2.78, 2.78)         
#>         Shrink(SD)%
#> tcl           2.57 
#> tv            1.30 
#> add.err            
#>  
#>   Covariance Type ($covMethod): sa
#>   Some strong fixed parameter correlations exist ($cor) :
#>                         cor:tv,tcl          cor:om.eta.cl,add.err 
#>                         0.903                        -0.0986   
#>   cor:cov.eta.v.eta.cl,add.err           cor:om.eta.v,add.err 
#>                        0.0345                         -0.0645   
#> cor:cov.eta.v.eta.cl,om.eta.cl         cor:om.eta.v,om.eta.cl 
#>                         0.851                          0.509  
#>  cor:om.eta.v,cov.eta.v.eta.cl 
#>                         0.816  
#>  
#> 
#>   Correlations in between subject variability (BSV) matrix:
#>     cor:eta.v,eta.cl 
#>           0.962  
#>  
#> 
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Censoring ($censInformation): No censoring
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 155 × 26
#>   ID     TIME    DV EPRED  ERES   NPDE    NPD   PDE    PD  PRED    RES    WRES
#>   <fct> <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl> <dbl> <dbl> <dbl>  <dbl>   <dbl>
#> 1 1        2   17.3  18.9 -1.62 -0.332 -0.100 0.37  0.46   17.5 -0.210 -0.0279
#> 2 1      112.  31    29.7  1.31  0.253  0.253 0.6   0.6    28.0  3.04   0.249 
#> 3 2        2    9.7  11.4 -1.75 -0.664 -0.245 0.253 0.403  10.5 -0.806 -0.160 
#> # ℹ 152 more rows
#> # ℹ 14 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.cl <dbl>, eta.v <dbl>, A1 <dbl>, cl <dbl>,
#> #   v <dbl>, ke <dbl>, tad <dbl>, dosenum <int>
```

### Basic Goodness of Fit Plots

``` r

plot(fit)
```

![](addingCovariances_files/figure-html/unnamed-chunk-5-1.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-2.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-3.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-4.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-5.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-6.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-7.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-8.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-9.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-10.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-11.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-12.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-13.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-14.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-15.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-16.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-17.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-18.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-19.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-20.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-21.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-22.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-23.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-24.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-25.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-26.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-27.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-28.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-29.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-30.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-31.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-32.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-33.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-34.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-35.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-36.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-37.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-38.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-39.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-40.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-41.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-42.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-43.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-44.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-45.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-46.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-47.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-48.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-49.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-50.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-51.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-52.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-53.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-54.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-55.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-56.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-57.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-58.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-59.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-60.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-61.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-62.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-63.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-64.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-65.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-66.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-67.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-68.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-69.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-70.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-71.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-72.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-73.png)

![](addingCovariances_files/figure-html/unnamed-chunk-5-74.png)

Those individual plots are not that great, it would be better to see the
actual curves; You can with `augPred`

``` r

plot(augPred(fit))
```

![](addingCovariances_files/figure-html/unnamed-chunk-6-1.png)

![](addingCovariances_files/figure-html/unnamed-chunk-6-2.png)

![](addingCovariances_files/figure-html/unnamed-chunk-6-3.png)

![](addingCovariances_files/figure-html/unnamed-chunk-6-4.png)

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
