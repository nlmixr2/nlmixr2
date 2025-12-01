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
#>           OBJF      AIC     BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.8346 373.4344 393.614      -179.7172        214.0002        4.968035
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.002072 0.531717   0.531719  0.85    0.001 6.289492
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka           Ka 0.476  0.204  42.8        1.61 (1.08, 2.4)     69.8
#> tcl           Cl  1.01  0.177  17.5       2.75 (1.94, 3.89)     26.4
#> tv             V  3.46 0.0188 0.542         31.8 (30.7, 33)     14.6
#> add.sd           0.695                                0.695         
#>        Shrink(SD)%
#> tka         1.14% 
#> tcl         3.91% 
#> tv          12.1% 
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
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD    PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.109  0.631  0.449  0.878 0.673  0.81   0     0.74   1.06 
#> 2 1      0.25  2.84 3.64  -0.804 -0.496 -0.394 0.31   0.347  3.29 -0.452 -0.240
#> 3 1      0.57  6.57 5.95   0.617 -1.79   0.323 0.0367 0.627  5.87  0.703  0.282
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
#>           OBJF     AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.8652 371.465 388.7618      -179.7325        14.86323        7.504417
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.002275 0.272308   0.272309 0.851    0.001 4.046108
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka           Ka   0.5  FIXED FIXED                     0.5     69.8
#> tcl           Cl  1.01 0.0825  8.15       2.75 (2.34, 3.23)     26.4
#> tv             V  3.46 0.0376  1.09       31.8 (29.6, 34.3)     14.6
#> add.sd           0.695                                0.695         
#>        Shrink(SD)%
#> tka         1.07% 
#> tcl         3.93% 
#> tv          12.0% 
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
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD    PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.109  0.631  0.440  0.878 0.67   0.81   0     0.74   1.06 
#> 2 1      0.25  2.84 3.71  -0.866 -0.477 -0.412 0.317  0.34   3.36 -0.515 -0.270
#> 3 1      0.57  6.57 6.02   0.546 -1.79   0.271 0.0367 0.607  5.95  0.619  0.248
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
#>           OBJF      AIC     BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.8354 371.4352 388.732      -179.7176        15.81358        11.88774
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.002211 0.277093   0.277094  0.85    0.001 3.724602
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.    SE  %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka           Ka 0.476 FIXED FIXED                   0.476     69.9      1.21% 
#> tcl           Cl  1.01 0.304  30.1       2.75 (1.51, 4.99)     26.4      3.89% 
#> tv             V  3.46 0.183   5.3       31.8 (22.2, 45.6)     14.6      12.1% 
#> add.sd           0.695                               0.695                     
#>  
#>   Covariance Type ($covMethod): s
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Information about run found ($runInfo):
#>    • gradient problems with initial estimate and covariance; see $scaleInfo 
#>    • using S matrix to calculate covariance, can check sandwich or R matrix with $covRS and $covR 
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
#> 1 1      0     0.74 0.109  0.631  0.449  0.878 0.673  0.81   0     0.74   1.06 
#> 2 1      0.25  2.84 3.65  -0.808 -0.496 -0.394 0.31   0.347  3.29 -0.455 -0.241
#> 3 1      0.57  6.57 5.96   0.611 -1.79   0.314 0.0367 0.623  5.87  0.697  0.280
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
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.9169 373.5166 393.6963      -179.7583        123.6119        26.02286
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.001902 0.466907   0.466908 0.375    0.001 1.997283
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.    SE %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka           Ka 0.491 0.498  101      1.63 (0.616, 4.33)     70.4      1.65% 
#> tcl           Cl  1.01 0.163 16.2       2.75 (1.99, 3.78)     25.8      3.06% 
#> tv             V  3.46 0.632 18.2        31.9 (9.26, 110)     15.1      13.3% 
#> add.sd           0.698                              0.698                     
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
#> 1 1      0     0.74 0.109  0.631  0.458  0.878 0.677  0.81   0     0.74   1.06 
#> 2 1      0.25  2.84 3.68  -0.836 -0.477 -0.394 0.317  0.347  3.32 -0.481 -0.252
#> 3 1      0.57  6.57 5.98   0.588 -1.79   0.297 0.0367 0.617  5.90  0.668  0.266
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
#> FOCEi 176.5806 431.1804 448.4772      -209.5902        34.62689        7.136017
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.002034 0.293339   0.293341 0.848    0.001 4.278286
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka           Ka 0.432  0.169   39       1.54 (1.11, 2.14)                     
#> tcl           Cl 0.988  0.076 7.69       2.69 (2.32, 3.12)     30.8      8.66% 
#> tv             V  3.48 0.0475 1.36       32.5 (29.6, 35.6)     15.3      6.89% 
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
#> 2 1      0.25  2.84 3.17  -0.331 -1.38   -0.245 0.0833 0.403  3.12 -0.275 -0.245
#> 3 1      0.57  6.57 5.67   0.904 -0.515   0.685 0.303  0.753  5.61  0.964  0.733
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
#>           OBJF     AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.9593 373.559 393.7387      -179.7795        55.36797        6.117935
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.002152 0.470023   0.470024 0.855    0.001 6.538801
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka           Ka 0.488  0.231 47.3       1.63 (1.04, 2.56)     65.8     -2.82% 
#> tcl           Cl  1.02  0.281 27.5        2.77 (1.6, 4.81)     27.4      6.24% 
#> tv             V  3.46 0.0553  1.6       31.8 (28.5, 35.4)     14.8      13.4% 
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
#>   ID     TIME    DV EPRED   ERES   NPDE    NPD   PDE    PD  PRED    RES   WRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74 0.109  0.631  0.431  0.878 0.667 0.81   0     0.74   1.06 
#> 2 1      0.25  2.84 3.72  -0.882 -0.915 -0.314 0.18  0.377  3.33 -0.489 -0.268
#> 3 1      0.57  6.57 6.05   0.516 -1.28   0.279 0.1   0.61   5.92  0.653  0.272
#> # ℹ 129 more rows
#> # ℹ 16 more variables: IPRED <dbl>, IRES <dbl>, IWRES <dbl>, CPRED <dbl>,
#> #   CRES <dbl>, CWRES <dbl>, eta.cl <dbl>, eta.v <dbl>, bsv.ka <dbl>,
#> #   depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>,
#> #   dosenum <dbl>
```

You can see the name change by examining the `omega` matrix:

``` r
addBackKa$omega
#>            eta.cl      eta.v    bsv.ka
#> eta.cl 0.07247903 0.00000000 0.0000000
#> eta.v  0.00000000 0.02155343 0.0000000
#> bsv.ka 0.00000000 0.00000000 0.3599338
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
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.2568 370.8565 388.1534      -179.4283         2.74697        2.743088
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress    other
#> elapsed 0.002336 0.296661   0.296662 0.871    0.001 4.210341
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>          Parameter  Est.     SE  %RSE Back-transformed(95%CI) BSV(CV%)
#> tka             Ka   0.5  FIXED FIXED                     0.5     70.5
#> tcl             Cl  1.03 0.0689  6.72       2.79 (2.44, 3.19)     26.4
#> tv               V  3.46 0.0707  2.04       31.7 (27.6, 36.4)     14.5
#> add.sd             0.693                                0.693         
#> covWtPow            0.75  FIXED FIXED                    0.75         
#>          Shrink(SD)%
#> tka           2.11% 
#> tcl           6.23% 
#> tv            14.1% 
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
#> 1 1      0     0.74 0.109  0.631  0.394  0.890 0.653  0.813  0     0.74   1.07 
#> 2 1      0.25  2.84 3.72  -0.884 -0.332 -0.431 0.37   0.333  3.37 -0.529 -0.275
#> 3 1      0.57  6.57 6.03   0.537 -1.79   0.262 0.0367 0.603  5.96  0.608  0.242
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
#> FOCEi 104.4951 363.0949 386.1573      -173.5474        61.98699        8.664907
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table compress   other
#> elapsed 0.002045 0.485137   0.485138 0.854    0.001 6.46168
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>          Parameter  Est.     SE %RSE Back-transformed(95%CI) BSV(CV%)
#> tka             Ka 0.407  0.233 57.4       1.5 (0.951, 2.37)     69.5
#> tcl             Cl  1.02 0.0472 4.61       2.78 (2.54, 3.05)     26.5
#> tv               V  3.46 0.0737 2.13         32 (27.7, 36.9)     13.9
#> add.err            0.287                               0.287         
#> prop.err           0.129                               0.129         
#>          Shrink(SD)%
#> tka           1.88% 
#> tcl           3.17% 
#> tv            17.3% 
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
#> 1 1      0     0.74 0.0451  0.695  0.866  2.33  0.807 0.99   0     0.74   2.58 
#> 2 1      0.25  2.84 3.42   -0.582 -0.654 -0.271 0.257 0.393  3.10 -0.258 -0.149
#> 3 1      0.57  6.57 5.73    0.844 -0.341  0.385 0.367 0.65   5.60  0.973  0.395
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
