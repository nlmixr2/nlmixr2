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
fit <- nlmixr(one.compartment, theo_sd, est="focei",
              control=list(print=0),
              table=list(npde=TRUE, cwres=TRUE))
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
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> done

print(fit)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.8083 373.4081 393.5877      -179.7041         80.1397        12.43841
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.002142 0.473813   0.473814 0.833    0.001 7.295231
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka           Ka 0.467  0.208 44.5         1.6 (1.06, 2.4)     69.8      1.23% 
#> tcl           Cl  1.01 0.0624 6.18        2.75 (2.43, 3.1)     26.5      3.35% 
#> tv             V  3.46 0.0548 1.58       31.9 (28.6, 35.5)     14.0      10.4% 
#> add.sd           0.694                               0.694                     
#>  
#>   Covariance Type ($covMethod): r,s
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>    • initial ETAs were nudged; (can control by foceiControl(etaNudge=., etaNudge2=)) 
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
#> 1 1      0     0.74 0.109  0.631  0.449  0.890 0.673  0.813  0     0.74   1.07 
#> 2 1      0.25  2.84 3.61  -0.775 -0.505 -0.394 0.307  0.347  3.26 -0.424 -0.227
#> 3 1      0.57  6.57 5.92   0.652 -1.79   0.332 0.0367 0.63   5.83  0.741  0.299
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <dbl>
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
one.ka.0.5 <- fit %>%
    ini(tka=fix(0.5)) %>%
    nlmixr(est="focei", control=list(print=0),
           table=list(cwres=TRUE, npde=TRUE))
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
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> done

print(one.ka.0.5)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>          OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.842 371.4417 388.7385      -179.7209        10.41933        6.499085
#> 
#> ── Time (sec $time): ──
#> 
#>           setup optimize covariance table compress    other
#> elapsed 0.00222 0.267452   0.267453 0.836    0.001 5.041875
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka           Ka   0.5  FIXED FIXED                     0.5     69.9
#> tcl           Cl  1.01 0.0759   7.5       2.75 (2.37, 3.19)     26.5
#> tv             V  3.46 0.0406  1.17       31.8 (29.4, 34.5)     14.0
#> add.sd           0.695                                0.695         
#>        Shrink(SD)%
#> tka         1.22% 
#> tcl         3.39% 
#> tv          10.3% 
#> add.sd            
#>  
#>   Covariance Type ($covMethod): r,s
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>    • initial ETAs were nudged; (can control by foceiControl(etaNudge=., etaNudge2=)) 
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
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD   PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.109  0.631  0.440  0.878 0.67  0.81   0     0.74   1.06 
#> 2 1      0.25  2.84 3.71  -0.867 -0.477 -0.422 0.317 0.337  3.36 -0.517 -0.272
#> 3 1      0.57  6.57 6.03   0.545 -1.75   0.253 0.04  0.6    5.95  0.616  0.247
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <dbl>
```

``` r
## Example 3 -- Fix tka to model estimated value and re-estimate.
one.ka.0.5 <- fit %>%
    ini(tka=fix) %>%
    nlmixr(est="focei", control=list(print=0),
           table=list(cwres=TRUE, npde=TRUE))
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
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> done

print(one.ka.0.5)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>          OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.808 371.4078 388.7046      -179.7039        5.346379        5.226783
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress  other
#> elapsed 0.002171 0.277114   0.277115 0.839    0.001 3.4996
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.    SE  %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka           Ka 0.467 FIXED FIXED                   0.467     69.8      1.18% 
#> tcl           Cl  1.01 0.104  10.3       2.75 (2.24, 3.37)     26.5      3.33% 
#> tv             V  3.46 0.092  2.66       31.8 (26.5, 38.1)     14.0      10.5% 
#> add.sd           0.695                               0.695                     
#>  
#>   Covariance Type ($covMethod): r,s
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>    • initial ETAs were nudged; (can control by foceiControl(etaNudge=., etaNudge2=)) 
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
#> 1 1      0     0.74 0.109  0.631  0.440  0.890 0.67   0.813  0     0.74   1.07 
#> 2 1      0.25  2.84 3.63  -0.785 -0.505 -0.394 0.307  0.347  3.27 -0.434 -0.232
#> 3 1      0.57  6.57 5.93   0.635 -1.79   0.332 0.0367 0.63   5.85  0.724  0.292
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <dbl>
```

``` r
## Example 4 -- Change tka to 0.7 in orginal model function and then estimate
one.ka.0.7 <- one.compartment %>%
    ini(tka=0.7) %>%
    nlmixr(theo_sd, est="focei", control=list(print=0),
           table=list(cwres=TRUE, npde=TRUE))
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> done

print(one.ka.0.7)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF     AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.8242 373.424 393.6036       -179.712         33.3521        7.996146
#> 
#> ── Time (sec $time): ──
#> 
#>          setup optimize covariance table compress    other
#> elapsed 0.0019 0.465221   0.465222 0.381    0.001 2.112657
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka           Ka 0.483  0.147 30.5       1.62 (1.21, 2.16)     70.6      1.87% 
#> tcl           Cl  1.01 0.0984 9.74       2.75 (2.27, 3.33)     26.3      3.32% 
#> tv             V  3.46 0.0432 1.25       31.9 (29.3, 34.7)     14.3      11.1% 
#> add.sd           0.696                               0.696                     
#>  
#>   Covariance Type ($covMethod): r,s
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>    • initial ETAs were nudged; (can control by foceiControl(etaNudge=., etaNudge2=)) 
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
#> 1 1      0     0.74 0.109  0.631  0.440  0.878 0.67   0.81   0     0.74   1.06 
#> 2 1      0.25  2.84 3.66  -0.825 -0.496 -0.394 0.31   0.347  3.31 -0.469 -0.247
#> 3 1      0.57  6.57 5.97   0.599 -1.79   0.288 0.0367 0.613  5.89  0.680  0.271
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <dbl>
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

$$\begin{aligned}
{ka} & {= \exp\left( {tka} + {eta.ka} \right)} \\
{cl} & {= \exp\left( {tcl} + {eta.cl} \right)} \\
v & {= \exp\left( {tv} + {eta.v} \right)} \\
\frac{d\ depot}{dt} & {= - {ka} \times {depot}} \\
\frac{d\ center}{dt} & {= {ka} \times {depot} - \frac{cl}{v} \times {center}} \\
{cp} & {= \frac{center}{v}} \\
{cp} & {\sim add(add.sd)}
\end{aligned}$$

And, if you’d prefer for volume to come before clearance in the
parameter table (`fit$parFixed`), you can change that, too.

``` r
fit %>%
  ini(
    tv <- label("Central volume"),
    append = "tcl"
  )
```

$$\begin{aligned}
{ka} & {= \exp\left( {tka} + {eta.ka} \right)} \\
{cl} & {= \exp\left( {tcl} + {eta.cl} \right)} \\
v & {= \exp\left( {tv} + {eta.v} \right)} \\
\frac{d\ depot}{dt} & {= - {ka} \times {depot}} \\
\frac{d\ center}{dt} & {= {ka} \times {depot} - \frac{cl}{v} \times {center}} \\
{cp} & {= \frac{center}{v}} \\
{cp} & {\sim add(add.sd)}
\end{aligned}$$

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
noEta <- fit %>%
    model(ka <- exp(tka)) %>%
    nlmixr(est="focei", control=list(print=0),
           table=list(cwres=TRUE, npde=TRUE))
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
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> done

print(noEta)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 176.5786 431.1784 448.4752      -209.5892        34.35318        7.143069
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.002172 0.292177   0.292178 0.844    0.001 3.657473
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka           Ka 0.436  0.169 38.8       1.55 (1.11, 2.15)                     
#> tcl           Cl 0.991 0.0759 7.66       2.69 (2.32, 3.12)     30.1      7.47% 
#> tv             V  3.48  0.048 1.38       32.5 (29.6, 35.7)     15.3      6.95% 
#> add.sd            1.02                                1.02                     
#>  
#>   Covariance Type ($covMethod): r,s
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>    • initial ETAs were nudged; (can control by foceiControl(etaNudge=., etaNudge2=)) 
#>   Censoring ($censInformation): No censoring
#>   Minimization message ($message):  
#>     relative convergence (4) 
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 27
#>   ID     TIME    DV EPRED   ERES    NPDE    NPD    PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>   <dbl>  <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.160  0.580  0.0753  0.486 0.53   0.687  0     0.74   0.725
#> 2 1      0.25  2.84 3.18  -0.341 -1.38   -0.245 0.0833 0.403  3.12 -0.284 -0.253
#> 3 1      0.57  6.57 5.68   0.891 -0.524   0.674 0.3    0.75   5.62  0.952  0.722
#> # ℹ 129 more rows
#> # ℹ 15 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.cl <dbl>, eta.v <dbl>, depot <dbl>,
#> #   center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>, dosenum <dbl>
```

Of course you could also add an eta on a parameter in the same way;

``` r
addBackKa <- noEta %>%
    model({ka <- exp(tka + bsv.ka)}) %>%
    ini(bsv.ka=0.1) %>%
    nlmixr(est="focei", control=list(print=0),
           table=list(cwres=TRUE, npde=TRUE))
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
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> done

print(addBackKa)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.8435 373.4432 393.6229      -179.7216        73.84612        6.153534
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.002364 0.466276   0.466277 0.838    0.001 5.281083
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka           Ka 0.468  0.192  41.1         1.6 (1.1, 2.33)     67.5
#> tcl           Cl  1.01 0.0662  6.53       2.75 (2.42, 3.13)     26.4
#> tv             V  3.46  0.034 0.981         31.8 (29.8, 34)     14.4
#> add.sd           0.695                                0.695         
#>        Shrink(SD)%
#> tka        -1.06% 
#> tcl         3.46% 
#> tv          11.6% 
#> add.sd            
#>  
#>   Covariance Type ($covMethod): r,s
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>    • initial ETAs were nudged; (can control by foceiControl(etaNudge=., etaNudge2=)) 
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
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD   PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.109  0.631  0.431  0.878 0.667 0.81   0     0.74   1.06 
#> 2 1      0.25  2.84 3.67  -0.833 -0.954 -0.297 0.17  0.383  3.27 -0.432 -0.236
#> 3 1      0.57  6.57 5.98   0.587 -1.26   0.297 0.103 0.617  5.84  0.729  0.300
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.cl <dbl>, eta.v <dbl>, bsv.ka <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <dbl>
```

You can see the name change by examining the `omega` matrix:

``` r
addBackKa$omega
#>           eta.cl     eta.v    bsv.ka
#> eta.cl 0.0671624 0.0000000 0.0000000
#> eta.v  0.0000000 0.0204582 0.0000000
#> bsv.ka 0.0000000 0.0000000 0.3751437
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
wt70 <- fit %>%
  model({cl <- exp(tcl + eta.cl)*(WT/70)^covWtPow}) %>%
  ini(covWtPow=fix(0.75)) %>%
  ini(tka=fix(0.5)) %>%
  nlmixr(est="focei", control=list(print=0),
         table=list(cwres=TRUE, npde=TRUE))
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
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> done

print(wt70)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>          OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.199 370.7987 388.0956      -179.3994        38.31823        1.292621
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.002228 0.287358   0.287359 0.866    0.001 3.945055
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>          Parameter  Est.     SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka             Ka   0.5  FIXED FIXED                     0.5     69.2
#> tcl             Cl  1.02   0.28  27.6        2.76 (1.6, 4.79)     26.3
#> tv               V  3.46 0.0457  1.32       31.8 (29.1, 34.8)     14.0
#> add.sd             0.696                                0.696         
#> covWtPow            0.75  FIXED FIXED                    0.75         
#>          Shrink(SD)%
#> tka           1.12% 
#> tcl           5.73% 
#> tv            12.3% 
#> add.sd              
#> covWtPow            
#>  
#>   Covariance Type ($covMethod): r,s
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>    • initial ETAs were nudged; (can control by foceiControl(etaNudge=., etaNudge2=)) 
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
#> 1 1      0     0.74 0.109  0.631  0.403  0.878 0.657  0.81   0     0.74   1.06 
#> 2 1      0.25  2.84 3.70  -0.864 -0.440 -0.422 0.33   0.337  3.36 -0.518 -0.274
#> 3 1      0.57  6.57 6.01   0.555 -1.79   0.271 0.0367 0.607  5.95  0.624  0.253
#> # ℹ 129 more rows
#> # ℹ 17 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <dbl>, WT <dbl>
```

### Changing residual errors

Changing the residual errors is also just as easy, by simply specifying
the error you wish to change:

``` r
## Since there are 0 predictions in the data, these are changed to
## 0.0150 to show proportional error change.
d <- theo_sd
d$DV[d$EVID == 0 & d$DV == 0] <- 0.0150

addPropModel <- fit %>%
    model({cp ~ add(add.err)+prop(prop.err)}) %>%
    ini(prop.err=0.1) %>%
    nlmixr(d,est="focei",
           control=list(print=0),
           table=list(cwres=TRUE, npde=TRUE))
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
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> done

print(addPropModel)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 104.3596 362.9593 386.0217      -173.4797        59.54252        8.632435
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.002184 0.466246   0.466247 0.834    0.001 7.277323
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>          Parameter  Est.     SE %RSE Back-transformed(95%CI) BSV(CV%)
#> tka             Ka 0.397  0.198 49.8       1.49 (1.01, 2.19)     69.5
#> tcl             Cl  1.02 0.0745 7.27       2.79 (2.41, 3.22)     25.7
#> tv               V  3.47 0.0461 1.33           32 (29.2, 35)     13.0
#> add.err            0.274                               0.274         
#> prop.err           0.134                               0.134         
#>          Shrink(SD)%
#> tka           2.38% 
#> tcl           1.11% 
#> tv            16.4% 
#> add.err             
#> prop.err            
#>  
#>   Covariance Type ($covMethod): r,s
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • last objective function was not at minimum, possible problems in optimization 
#>    • ETAs were reset to zero during optimization; (Can control by foceiControl(resetEtaP=.)) 
#>    • initial ETAs were nudged; (can control by foceiControl(etaNudge=., etaNudge2=)) 
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
#> 1 1      0     0.74 0.0431  0.697  0.994  2.71  0.84  0.997  0     0.74   2.70 
#> 2 1      0.25  2.84 3.39   -0.552 -0.674 -0.271 0.25  0.393  3.07 -0.230 -0.135
#> 3 1      0.57  6.57 5.69    0.881 -0.297  0.403 0.383 0.657  5.56  1.01   0.414
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <dbl>
```

There is much more you can do with piping. For a more complete
discussion see [see rxode2 piping
documentation](https://nlmixr2.github.io/rxode2/articles/Modifying-Models.html).
Since `rxode2` and `nlmixr2` models can share the same functional form
the piping applies to fits as well as model definitions.
