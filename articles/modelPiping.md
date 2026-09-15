# Modifying nlmixr2 models by piping

![nlmixr](logo.png)

nlmixr

## Changing models via piping

As in the running nlmixr vignette, Let’s start with a very simple PK
example, using the single-dose theophylline dataset generously provided
by Dr. Robert A. Upton of the University of California, San Francisco:

``` r

library(nlmixr2)

one.compartment <- function() {
  ini({
    tka <- 0.45; label("Ka")
    tcl <- 1; label("Cl")
    tv <- 3.45; label("V")
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
```

We can try the First-Order Conditional Estimation with Interaction
(FOCEi) method to find a good solution:

``` r

fit := nlmixr2(one.compartment, theo_sd, est="focei",
               control=list(print=0),
               table=list(npde=TRUE, cwres=TRUE))

print(fit)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>          OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.804 373.4038 393.5834      -179.7019          329.39        1.737811
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance preprocess postprocess table compress
#> elapsed 4.075974 1.523337   4.344075      0.031       0.013 0.681    0.001
#>             other
#> elapsed 0.9796149
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter   Est.      SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka           Ka 0.4663  0.1911 40.99    1.594 (1.096, 2.318)    70.00
#> tcl           Cl  1.012 0.08366 8.266    2.751 (2.335, 3.241)    26.80
#> tv             V  3.460 0.04654 1.345    31.81 (29.03, 34.84)    13.88
#> add.sd           0.6947 0.04951 7.127 0.6947 (0.5976, 0.7917)         
#>        Shrink(SD)%
#> tka         1.421 
#> tcl         3.968 
#> tv          10.28 
#> add.sd            
#>  
#>   Covariance Type ($covMethod): analytic
#>   Fixed parameter correlations in $cor
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>   Censoring ($censInformation): No censoring
#>   Minimization message ($message):  
#>     relative convergence (4) 
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 28
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD    PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.114  0.626  0.477  0.866 0.683  0.807  0     0.74   1.07 
#> 2 1      0.25  2.84 3.64  -0.799 -0.440 -0.394 0.33   0.347  3.27 -0.429 -0.229
#> 3 1      0.57  6.57 5.94   0.631 -1.79   0.332 0.0367 0.63   5.84  0.732  0.295
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <int>
```

## Changing and fixing parameter values in models

Something that you may want to do is change initial estimates with a
model. It is simple to modify the model definition and change them
yourself, but you may also want to change them in a specific way; For
example try a range of starting values to see how the system behaves
(either by full estimation or by a posthoc estimation). In these
situations it can be come tedious to modify the models by hand.

nlmixr provides the ability to:

1.  Change parameter estimates before or after running a model. (ie
    `ini(tka=0.5)`)
2.  Fix parameters to arbitrary values, or estimated values (ie
    `ini(tka=fix(0.5))` or `ini(tka=fix)`)

The easiest way to illustrate this is by showing a few examples of
piping changes to the model:

``` r

## Example 1 -- Set inital estimate to 0.5 (shown w/posthoc)
one.ka.0.5 <- fit %>%
    ini(tka=0.5) %>%
    nlmixr(est="posthoc", control=list(print=0),
           table=list(cwres=TRUE, npde=TRUE))

print(one.ka.0.5)
```

``` r

## Example 2 -- Fix tka to 0.5 and re-estimate.
one.ka.0.5.fix.mod <- fit %>% ini(tka=fix(0.5))
one.ka.0.5.fix := nlmixr2(one.ka.0.5.fix.mod, theo_sd, est="focei",
                          control=list(print=0),
                          table=list(cwres=TRUE, npde=TRUE))

print(one.ka.0.5.fix)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.8398 371.4396 388.7364      -179.7198        300.4872         1.68228
#> 
#> ── Time (sec $time): ──
#> 
#>            setup  optimize covariance preprocess postprocess table compress
#> elapsed 2.863721 0.6288163   3.631362      0.082       0.012 0.691    0.001
#>             other
#> elapsed 0.1091007
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter   Est.      SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka           Ka 0.5000   FIXED FIXED                   1.649    70.09
#> tcl           Cl  1.012 0.08356 8.259    2.750 (2.335, 3.240)    26.80
#> tv             V  3.461 0.04628 1.337    31.84 (29.08, 34.86)    13.88
#> add.sd           0.6948 0.04953 7.128 0.6948 (0.5977, 0.7919)         
#>        Shrink(SD)%
#> tka         1.421 
#> tcl         4.013 
#> tv          10.14 
#> add.sd            
#>  
#>   Covariance Type ($covMethod): analytic
#>   Fixed parameter correlations in $cor
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>   Censoring ($censInformation): No censoring
#>   Minimization message ($message):  
#>     false convergence (8) 
#>   In an ODE system, false convergence may mean "useless" evaluations were performed.
#>   See https://tinyurl.com/yyrrwkce
#>   It could also mean the convergence is poor, check results before accepting fit
#>   You may also try a good derivative free optimization:
#>     nlmixr2(...,control=list(outerOpt="bobyqa"))
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 28
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD    PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.114  0.626  0.468  0.866 0.68   0.807  0     0.74   1.07 
#> 2 1      0.25  2.84 3.72  -0.885 -0.350 -0.422 0.363  0.337  3.36 -0.516 -0.271
#> 3 1      0.57  6.57 6.03   0.535 -1.79   0.262 0.0367 0.603  5.95  0.618  0.248
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <int>
```

``` r

## Example 3 -- Fix tka to model estimated value and re-estimate.
one.ka.0.5.fixEst.mod <- fit %>% ini(tka=fix)
one.ka.0.5.fixEst := nlmixr2(one.ka.0.5.fixEst.mod, theo_sd, est="focei",
                             control=list(print=0),
                             table=list(cwres=TRUE, npde=TRUE))

print(one.ka.0.5.fixEst)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>          OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.804 371.4038 388.7006      -179.7019        301.6824        1.687471
#> 
#> ── Time (sec $time): ──
#> 
#>           setup optimize covariance preprocess postprocess table compress
#> elapsed 3.09949 0.323362    3.74241       0.09       0.011 0.712    0.001
#>              other
#> elapsed 0.08473797
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter   Est.      SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka           Ka 0.4663   FIXED FIXED                   1.594    70.03
#> tcl           Cl  1.012 0.08354 8.253    2.752 (2.336, 3.241)    26.80
#> tv             V  3.460 0.04628 1.338    31.82 (29.06, 34.84)    13.88
#> add.sd           0.6947 0.04951 7.127 0.6947 (0.5976, 0.7917)         
#>        Shrink(SD)%
#> tka         1.448 
#> tcl         3.966 
#> tv          10.26 
#> add.sd            
#>  
#>   Covariance Type ($covMethod): analytic
#>   Fixed parameter correlations in $cor
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>   Censoring ($censInformation): No censoring
#>   Minimization message ($message):  
#>     false convergence (8) 
#>   In an ODE system, false convergence may mean "useless" evaluations were performed.
#>   See https://tinyurl.com/yyrrwkce
#>   It could also mean the convergence is poor, check results before accepting fit
#>   You may also try a good derivative free optimization:
#>     nlmixr2(...,control=list(outerOpt="bobyqa"))
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 28
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD    PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.114  0.626  0.477  0.866 0.683  0.807  0     0.74   1.07 
#> 2 1      0.25  2.84 3.64  -0.798 -0.440 -0.394 0.33   0.347  3.27 -0.428 -0.229
#> 3 1      0.57  6.57 5.94   0.633 -1.79   0.332 0.0367 0.63   5.84  0.734  0.296
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <int>
```

``` r

## Example 4 -- Change tka to 0.7 in orginal model function and then estimate
one.ka.0.7.mod <- one.compartment %>% ini(tka=0.7)
one.ka.0.7 := nlmixr2(one.ka.0.7.mod, theo_sd, est="focei",
                      control=list(print=0),
                      table=list(cwres=TRUE, npde=TRUE))

print(one.ka.0.7)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.8046 373.4043 393.5839      -179.7022        322.1083        1.744194
#> 
#> ── Time (sec $time): ──
#> 
#>              setup optimize covariance preprocess postprocess table compress
#> elapsed 0.06368274 1.360862   0.256714      0.033       0.009 0.224    0.001
#>              other
#> elapsed 0.06674127
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter   Est.      SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka           Ka 0.4645  0.1906 41.03    1.591 (1.095, 2.312)    69.76
#> tcl           Cl  1.013 0.08353 8.249    2.753 (2.337, 3.243)    26.74
#> tv             V  3.460 0.04663 1.348    31.82 (29.04, 34.86)    13.91
#> add.sd           0.6948 0.04953 7.129 0.6948 (0.5977, 0.7919)         
#>        Shrink(SD)%
#> tka         1.206 
#> tcl         3.869 
#> tv          10.35 
#> add.sd            
#>  
#>   Covariance Type ($covMethod): analytic
#>   Fixed parameter correlations in $cor
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>   Censoring ($censInformation): No censoring
#>   Minimization message ($message):  
#>     relative convergence (4) 
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 28
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD    PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.114  0.626  0.477  0.866 0.683  0.807  0     0.74   1.07 
#> 2 1      0.25  2.84 3.63  -0.792 -0.440 -0.394 0.33   0.347  3.26 -0.423 -0.227
#> 3 1      0.57  6.57 5.93   0.638 -1.79   0.332 0.0367 0.63   5.83  0.740  0.299
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <int>
```

## Changing parameter labels and order

For aesthetic reasons, sometimes it is preferred to update parameter
labels and the order of parameters. These changes do not affect the
estimation of the parameters. They only affect the output tables and
order of parameters.

By using these, you can modify a model with model piping and still have
the desired output table format ready to use in a report.

For example, you can change the label from `"Ka"` to `"Absorption rate"`
as follows:

``` r

fit %>%
  ini(
    tka <- label("Absorption rate")
  )
```

``` math
\begin{align*}
{ka} & = \exp\left({tka}+{eta.ka}\right) \\
{cl} & = \exp\left({tcl}+{eta.cl}\right) \\
{v} & = \exp\left({tv}+{eta.v}\right) \\
\frac{d \: depot}{dt} & = -{ka} {\times} {depot} \\
\frac{d \: center}{dt} & = {ka} {\times} {depot}-\frac{{cl}}{{v}} {\times} {center} \\
{cp} & = \frac{{center}}{{v}} \\
{cp} & \sim add({add.sd})
\end{align*}
```

And, if you’d prefer for volume to come before clearance in the
parameter table (`fit$parFixed`), you can change that, too.

``` r

fit %>%
  ini(
    tv <- label("Central volume"),
    append = "tcl"
  )
```

``` math
\begin{align*}
{ka} & = \exp\left({tka}+{eta.ka}\right) \\
{cl} & = \exp\left({tcl}+{eta.cl}\right) \\
{v} & = \exp\left({tv}+{eta.v}\right) \\
\frac{d \: depot}{dt} & = -{ka} {\times} {depot} \\
\frac{d \: center}{dt} & = {ka} {\times} {depot}-\frac{{cl}}{{v}} {\times} {center} \\
{cp} & = \frac{{center}}{{v}} \\
{cp} & \sim add({add.sd})
\end{align*}
```

See the documentation for
[`ini`](https://nlmixr2.github.io/rxode2/reference/ini.html) for more
about how you can modify parameters with model piping.

## Changing model features

When developing models, often you add and remove between subject
variability to parameters, add covariates to the effects, and/or change
the residual errors. You can change lines in the model by piping the fit
or the nlmixr model specification function to a `model`

### Adding or Removing between subject variability

Often in developing a model you add and remove between subject
variability to certain model parameters. For example, you could remove
the between subject variability in the ka parameter by changing that
line in the model;

For example to remove a eta from a prior fit or prior model
specification function, simply pipe it to the model function. You can
then re-estimate by piping it to the `nlmixr` function again.

``` r

## Remove eta.ka on ka
noEta.mod <- fit %>% model(ka <- exp(tka))
noEta := nlmixr2(noEta.mod, theo_sd, est="focei",
                 control=list(print=0),
                 table=list(cwres=TRUE, npde=TRUE))

print(noEta)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 176.5761 431.1758 448.4726      -209.5879        70.37994        2.857719
#> 
#> ── Time (sec $time): ──
#> 
#>            setup  optimize covariance preprocess postprocess table compress
#> elapsed 2.714166 0.5672109   3.425366      0.032       0.009 0.741    0.001
#>              other
#> elapsed 0.07425645
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter   Est.      SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka           Ka 0.4330 0.07891 18.23    1.542 (1.321, 1.800)         
#> tcl           Cl 0.9903  0.1003 10.13    2.692 (2.212, 3.277)    30.38
#> tv             V  3.480 0.05551 1.595    32.45 (29.10, 36.18)    15.34
#> add.sd            1.020 0.06954 6.815   1.020 (0.8840, 1.157)         
#>        Shrink(SD)%
#> tka               
#> tcl         7.886 
#> tv          7.050 
#> add.sd            
#>  
#>   Covariance Type ($covMethod): analytic
#>   Fixed parameter correlations in $cor
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>   Censoring ($censInformation): No censoring
#>   Minimization message ($message):  
#>     relative convergence (4) 
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 27
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD    PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.167  0.573  0.126  0.477 0.55   0.683  0     0.74   0.725
#> 2 1      0.25  2.84 3.18  -0.339 -1.36  -0.253 0.0867 0.4    3.12 -0.280 -0.249
#> 3 1      0.57  6.57 5.68   0.893 -0.524  0.685 0.3    0.753  5.61  0.957  0.726
#> # ℹ 129 more rows
#> # ℹ 15 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.cl <dbl>, eta.v <dbl>, depot <dbl>,
#> #   center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>, dosenum <int>
```

Of course you could also add an eta on a parameter in the same way;

``` r

addBackKa.mod <- noEta %>%
  model({ka <- exp(tka + bsv.ka)}) %>%
  ini(bsv.ka=0.1)
addBackKa := nlmixr2(addBackKa.mod, theo_sd, est="focei",
                     control=list(print=0),
                     table=list(cwres=TRUE, npde=TRUE))

print(addBackKa)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF     AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.8042 373.404 393.5836       -179.702         330.491        1.735464
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance preprocess postprocess table compress
#> elapsed 2.922645  1.24079   3.632343      0.033       0.011 0.719    0.001
#>             other
#> elapsed 0.0932216
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter   Est.      SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka           Ka 0.4616  0.1926 41.72    1.587 (1.088, 2.314)    70.76
#> tcl           Cl  1.013 0.08341 8.234    2.754 (2.339, 3.243)    26.70
#> tv             V  3.459 0.04664 1.348    31.80 (29.02, 34.84)    13.92
#> add.sd           0.6937 0.04933 7.112 0.6937 (0.5970, 0.7904)         
#>        Shrink(SD)%
#> tka         2.079 
#> tcl         3.760 
#> tv          10.32 
#> add.sd            
#>  
#>   Covariance Type ($covMethod): analytic
#>   Fixed parameter correlations in $cor
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>   Censoring ($censInformation): No censoring
#>   Minimization message ($message):  
#>     false convergence (8) 
#>   In an ODE system, false convergence may mean "useless" evaluations were performed.
#>   See https://tinyurl.com/yyrrwkce
#>   It could also mean the convergence is poor, check results before accepting fit
#>   You may also try a good derivative free optimization:
#>     nlmixr2(...,control=list(outerOpt="bobyqa"))
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 28
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD    PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.114  0.626  0.477  0.878 0.683   0.81  0     0.74   1.07 
#> 2 1      0.25  2.84 3.67  -0.833 -0.878 -0.279 0.19    0.39  3.26 -0.417 -0.222
#> 3 1      0.57  6.57 5.96   0.612 -1.45   0.305 0.0733  0.62  5.82  0.747  0.299
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.cl <dbl>, eta.v <dbl>, bsv.ka <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <int>
```

You can see the name change by examining the `omega` matrix:

``` r

addBackKa$omega
#>            eta.cl      eta.v    bsv.ka
#> eta.cl 0.06887358 0.00000000 0.0000000
#> eta.v  0.00000000 0.01920327 0.0000000
#> bsv.ka 0.00000000 0.00000000 0.4059005
```

Note that new between subject variability parameters are distinguished
from other types of parameters (ie population parameters, and individual
covariates) by their name. Parameters starting or ending with the
following names are assumed to be between subject variability
parameters:

- eta (from NONMEM convention)
- ppv (per patient variability)
- psv (per subject variability)
- iiv (inter-individual variability)
- bsv (between subject variability)
- bpv (between patient variability)

### Adding Covariate effects

``` r

## Note currently cov is needed as a prefix so nlmixr knows this is an
## estimated parameter not a parameter
wt70.mod <- fit %>%
  model({cl <- exp(tcl + eta.cl)*(WT/70)^covWtPow}) %>%
  ini(covWtPow=fix(0.75)) %>%
  ini(tka=fix(0.5))
wt70 := nlmixr2(wt70.mod, theo_sd, est="focei",
                control=list(print=0),
                table=list(cwres=TRUE, npde=TRUE))

print(wt70)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF      AIC     BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.1774 370.7772 388.074      -179.3886        276.6418        1.592193
#> 
#> ── Time (sec $time): ──
#> 
#>           setup  optimize covariance preprocess postprocess table compress
#> elapsed 3.04174 0.6115323   4.034777      0.068       0.015 0.742    0.003
#>              other
#> elapsed 0.08895074
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>          Parameter   Est.      SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka             Ka 0.5000   FIXED FIXED                   1.649    69.40
#> tcl             Cl  1.021 0.08192 8.020    2.777 (2.365, 3.261)    26.16
#> tv               V  3.462 0.04615 1.333    31.87 (29.11, 34.89)    13.80
#> add.sd             0.6964 0.04978 7.149 0.6964 (0.5988, 0.7939)         
#> covWtPow           0.7500   FIXED FIXED                  0.7500         
#>          Shrink(SD)%
#> tka           1.373 
#> tcl           5.174 
#> tv            11.67 
#> add.sd              
#> covWtPow            
#>  
#>   Covariance Type ($covMethod): analytic
#>   Fixed parameter correlations in $cor
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>   Censoring ($censInformation): No censoring
#>   Minimization message ($message):  
#>     false convergence (8) 
#>   In an ODE system, false convergence may mean "useless" evaluations were performed.
#>   See https://tinyurl.com/yyrrwkce
#>   It could also mean the convergence is poor, check results before accepting fit
#>   You may also try a good derivative free optimization:
#>     nlmixr2(...,control=list(outerOpt="bobyqa"))
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 29
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD    PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.114  0.626  0.431  0.866 0.667  0.807  0     0.74   1.06 
#> 2 1      0.25  2.84 3.71  -0.872 -0.297 -0.422 0.383  0.337  3.35 -0.508 -0.269
#> 3 1      0.57  6.57 6.01   0.562 -1.79   0.279 0.0367 0.61   5.93  0.642  0.261
#> # ℹ 129 more rows
#> # ℹ 17 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <int>, WT <dbl>
```

### Changing residual errors

Changing the residual errors is also just as easy, by simply specifying
the error you wish to change:

``` r

## Since there are 0 predictions in the data, these are changed to
## 0.0150 to show proportional error change.
d <- theo_sd
d$DV[d$EVID == 0 & d$DV == 0] <- 0.0150

addPropModel.mod <- fit %>%
  model({cp ~ add(add.err)+prop(prop.err)}) %>%
  ini(prop.err=0.1)
addPropModel := nlmixr2(addPropModel.mod, d, est="focei",
                        control=list(print=0),
                        table=list(cwres=TRUE, npde=TRUE))

print(addPropModel)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF      AIC     BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 104.4158 363.0156 386.078      -173.5078        316.9885        5.562998
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance preprocess postprocess table compress
#> elapsed 3.311904 1.206956   5.213404      0.031       0.011 0.731    0.001
#>              other
#> elapsed 0.08673691
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>          Parameter   Est.      SE  %RSE  Back-transformed(95%CI) BSV(CV%)
#> tka             Ka 0.4159  0.1933 46.47     1.516 (1.038, 2.214)    70.11
#> tcl             Cl  1.025 0.07720 7.535     2.786 (2.395, 3.241)    25.80
#> tv               V  3.468 0.04717 1.360     32.08 (29.25, 35.19)    13.44
#> add.err            0.2818 0.07938 28.17  0.2818 (0.1262, 0.4374)         
#> prop.err           0.1312 0.01779 13.56 0.1312 (0.09634, 0.1661)         
#>          Shrink(SD)%
#> tka           2.594 
#> tcl           1.198 
#> tv            16.44 
#> add.err             
#> prop.err            
#>  
#>   Covariance Type ($covMethod): analytic
#>   Fixed parameter correlations in $cor
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>   Censoring ($censInformation): No censoring
#>   Minimization message ($message):  
#>     false convergence (8) 
#>   In an ODE system, false convergence may mean "useless" evaluations were performed.
#>   See https://tinyurl.com/yyrrwkce
#>   It could also mean the convergence is poor, check results before accepting fit
#>   You may also try a good derivative free optimization:
#>     nlmixr2(...,control=list(outerOpt="bobyqa"))
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 28
#>   ID     TIME    DV  EPRED   ERES   NPDE    NPD   PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.0462  0.694  1.08   2.47  0.86  0.993  0     0.74   2.63 
#> 2 1      0.25  2.84 3.45   -0.614 -0.623 -0.279 0.267 0.39   3.11 -0.270 -0.155
#> 3 1      0.57  6.57 5.75    0.823 -0.341  0.376 0.367 0.647  5.61  0.959  0.389
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <int>
```

There is much more you can do with piping. For a more complete
discussion see [see rxode2 piping
documentation](https://nlmixr2.github.io/rxode2/articles/Modifying-Models.html).
Since `rxode2` and `nlmixr2` models can share the same functional form
the piping applies to fits as well as model definitions.
