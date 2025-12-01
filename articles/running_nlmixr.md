# Running PK models with nlmixr

![nlmixr](logo.png)

nlmixr

## Running PK models with nlmixr

nlmixr uses a unified interface for specifying and running models. Let’s
start with a very simple PK example, using the single-dose theophylline
dataset generously provided by Dr. Robert A. Upton of the University of
California, San Francisco:

``` r
## Load libraries
library(nlmixr2)
str(theo_sd)
#> 'data.frame':    144 obs. of  7 variables:
#>  $ ID  : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ TIME: num  0 0 0.25 0.57 1.12 2.02 3.82 5.1 7.03 9.05 ...
#>  $ DV  : num  0 0.74 2.84 6.57 10.5 9.66 8.58 8.36 7.47 6.89 ...
#>  $ AMT : num  320 0 0 0 0 ...
#>  $ EVID: int  101 0 0 0 0 0 0 0 0 0 ...
#>  $ CMT : int  1 2 2 2 2 2 2 2 2 2 ...
#>  $ WT  : num  79.6 79.6 79.6 79.6 79.6 79.6 79.6 79.6 79.6 79.6 ...
```

We can try fitting a simple one-compartment PK model to this small
dataset. We write the model as follows:

``` r
one.cmt <- function() {
  ini({
    ## You may label each parameter with a comment
    tka <- 0.45 # Log Ka
    tcl <- log(c(0, 2.7, 100)) # Log Cl
    ## This works with interactive models
    ## You may also label the preceding line with label("label text")
    tv <- 3.45; label("log V")
    ## the label("Label name") works with all models
    eta.ka ~ 0.6
    eta.cl ~ 0.3
    eta.v ~ 0.1
    add.sd <- 0.7
  })
  model({
    ka <- exp(tka + eta.ka)
    cl <- exp(tcl + eta.cl)
    v <- exp(tv + eta.v)
    linCmt() ~ add(add.sd)
  })
}

f <- nlmixr(one.cmt)
```

We can now run the model…

``` r
fit <- nlmixr(one.cmt, theo_sd, est="focei",
              control=list(print=0))
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
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> done

print(fit)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>          OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 116.812 373.4118 393.5914      -179.7059        68.29718        9.353349
#> 
#> ── Time (sec $time): ──
#> 
#>           setup optimize covariance table compress    other
#> elapsed 0.00203 0.363796   0.363797 0.072    0.001 5.901377
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>        Parameter  Est.     SE %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka              0.461  0.195 42.4       1.59 (1.08, 2.32)     70.3      1.59% 
#> tcl               1.01 0.0751 7.42       2.75 (2.37, 3.19)     26.7      4.03% 
#> tv         log V  3.46 0.0436 1.26       31.8 (29.2, 34.6)     14.2      11.0% 
#> add.sd           0.692                               0.692                     
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
#> # A tibble: 132 × 22
#>   ID     TIME    DV  PRED    RES   WRES IPRED   IRES  IWRES CPRED   CRES  CWRES
#>   <fct> <dbl> <dbl> <dbl>  <dbl>  <dbl> <dbl>  <dbl>  <dbl> <dbl>  <dbl>  <dbl>
#> 1 1      0     0.74  0     0.74   1.07   0     0.74   1.07   0     0.74   1.07 
#> 2 1      0.25  2.84  3.26 -0.417 -0.502  3.84 -1.00  -1.45   3.50 -0.656 -0.746
#> 3 1      0.57  6.57  5.82  0.746  0.695  6.78 -0.215 -0.311  6.17  0.401  0.340
#> # ℹ 129 more rows
#> # ℹ 10 more variables: eta.ka <dbl>, eta.cl <dbl>, eta.v <dbl>, depot <dbl>,
#> #   central <dbl>, ka <dbl>, cl <dbl>, v <dbl>, tad <dbl>, dosenum <dbl>
```

We can alternatively express the same model by ordinary differential
equations (ODEs):

``` r
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

We can try the Stochastic Approximation EM (SAEM) method to this model:

``` r
fit2 <- nlmixr(one.compartment, theo_sd,  est="saem",
               control=list(print=0))
#> [====|====|====|====|====|====|====|====|====|====
#> ==|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
print(fit2)
#> ── nlmixr² SAEM OBJF by FOCEi approximation ──
#> 
#>  Gaussian/Laplacian Likelihoods: AIC() or $objf etc. 
#>  FOCEi CWRES & Likelihoods: addCwres() 
#> 
#> ── Time (sec $time): ──
#> 
#>            setup covariance  saem table compress    other
#> elapsed 0.002032   0.009012 4.918 0.092    0.001 1.944956
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>         Est.     SE %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka    0.464  0.195   42       1.59 (1.09, 2.33)     71.1   -0.0900% 
#> tcl     1.01  0.085 8.43       2.74 (2.32, 3.24)     27.4      4.80% 
#> tv      3.46 0.0447 1.29         31.7 (29, 34.6)     13.1      8.77% 
#> add.sd 0.696                               0.696                     
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
#> 1 1      0     0.74  0     0.74   0     0.74   1.06  0.0839 -0.477 -0.0849  0   
#> 2 1      0.25  2.84  3.28 -0.437  3.83 -0.991 -1.42  0.0839 -0.477 -0.0849  3.83
#> 3 1      0.57  6.57  5.86  0.715  6.76 -0.194 -0.278 0.0839 -0.477 -0.0849  6.76
#> # ℹ 129 more rows
#> # ℹ 7 more variables: depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>,
#> #   tad <dbl>, dosenum <dbl>
```

And if we wanted to, we could even apply the traditional R method nlme
method to this model:

``` r
fitN <- nlmixr(one.compartment, theo_sd, list(pnlsTol=0.5), est="nlme")
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> 
#> **Iteration 1
#> LME step: Loglik: -183.2083, nlminb iterations: 1
#> reStruct  parameters:
#>       ID1       ID2       ID3 
#> 0.2195819 0.9924330 1.6502972 
#>  Beginning PNLS step: ..  completed fit_nlme() step.
#> PNLS step: RSS =  64.59841 
#>  fixed effects: 0.4443024  1.038584  3.449959  
#>  iterations: 3 
#> Convergence crit. (must all become <= tolerance = 1e-05):
#>      fixed   reStruct 
#> 0.03715048 0.91006943 
#> 
#> **Iteration 2
#> LME step: Loglik: -182.0743, nlminb iterations: 1
#> reStruct  parameters:
#>       ID1       ID2       ID3 
#> 0.1149602 0.9686071 1.6508466 
#>  Beginning PNLS step: ..  completed fit_nlme() step.
#> PNLS step: RSS =  64.59843 
#>  fixed effects: 0.4443024  1.038584  3.449959  
#>  iterations: 1 
#> Convergence crit. (must all become <= tolerance = 1e-05):
#>        fixed     reStruct 
#> 0.000000e+00 5.047516e-06
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
print(fitN)
#> ── nlmixr² nlme by maximum likelihood ──
#> 
#>          OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> nlme 121.5489 378.1487 398.3283      -182.0743        18.17386               1
#> 
#> ── Time (sec $time): ──
#> 
#>            setup table    other
#> elapsed 0.001771 0.093 3.161229
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>          Est.      SE  %RSE Back-transformed(95%CI) BSV(CV%) Shrink(SD)%
#> tka    0.4443  0.1916 43.12     1.559 (1.071, 2.27)     68.7     -3.49% 
#> tcl     1.039 0.08335 8.026    2.825 (2.399, 3.327)     27.0      7.85% 
#> tv       3.45 0.04494 1.303      31.5 (28.84, 34.4)     13.5      7.29% 
#> add.sd 0.6979                                0.6979                     
#>  
#>   Covariance Type ($covMethod): nlme
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Censoring ($censInformation): No censoring
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 132 × 19
#>   ID     TIME    DV  PRED    RES IPRED   IRES  IWRES eta.ka eta.cl   eta.v    cp
#>   <fct> <dbl> <dbl> <dbl>  <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>   <dbl> <dbl>
#> 1 1      0     0.74  0     0.74   0     0.74   1.06  0.0756 -0.483 -0.0896  0   
#> 2 1      0.25  2.84  3.24 -0.401  3.78 -0.943 -1.35  0.0756 -0.483 -0.0896  3.78
#> 3 1      0.57  6.57  5.81  0.760  6.72 -0.146 -0.210 0.0756 -0.483 -0.0896  6.72
#> # ℹ 129 more rows
#> # ℹ 7 more variables: depot <dbl>, center <dbl>, ka <dbl>, cl <dbl>, v <dbl>,
#> #   tad <dbl>, dosenum <dbl>
```

This example delivers a complete model fit as the `fit` object,
including parameter history, a set of fixed effect estimates, and random
effects for all included subjects.

## The UI

The nlmixr modeling dialect, inspired by R and NONMEM, can be used to
fit models using all current and future estimation algorithms within
nlmixr. Using these widely-used tools as inspiration has the advantage
of delivering a model specification syntax that is instantly familiar to
the majority of analysts working in pharmacometrics and related fields.

### Overall model structure

Model specifications for nlmixr are written using functions containing
`ini` and `model` blocks. These functions can be called anything, but
often contain these two components. Let’s look at a very simple
one-compartment model with no covariates.

``` r
f <- function() {
  ini({   # Initial conditions/variables
    # are specified here
  })
  model({ # The model is specified
    # here
  })
}
```

#### The ini block

The `ini` block specifies initial conditions, including initial
estimates and boundaries for those algorithms which support them
(currently, the built-in `nlme` and `saem` methods do not). Nomenclature
is similar to that used in NONMEM, Monolix and other similar packages.
In the NONMEM world, the `ini` block is analogous to `$THETA`, `$OMEGA`
and `$SIGMA` blocks.

``` r
f <- function() { # Note that arguments to the function are currently
  # ignored by nlmixr
  ini({
    # Initial conditions for population parameters (sometimes
    # called THETA parameters) are defined by either '<-' or '='
    lCl <- 1.6      # log Cl (L/hr)
    
    # Note that simple expressions that evaluate to a number are
    # OK for defining initial conditions (like in R)
    lVc = log(90)  # log V (L)
    
    ## Also, note that a comment on a parameter is captured as a parameter label
    lKa <- 1       # log Ka (1/hr)
    
    # Bounds may be specified by c(lower, est, upper), like NONMEM:
    # Residuals errors are assumed to be population parameters
    prop.err <- c(0, 0.2, 1)
    
    # IIV terms will be discussed in the next example
  })
  
  # The model block will be discussed later
  model({})
}
```

As shown in the above example:

- Simple parameter values are specified using an R-compatible assignment
- Boundaries may be specified by `c(lower, est, upper)`.
- Like NONMEM, `c(lower,est)` is equivalent to `c(lower,est,Inf)`
- Also like NONMEM, `c(est)` does not specify a lower bound, and is
  equivalent to specifying the parameter without using R’s
  [`c()`](https://rdrr.io/r/base/c.html) function.

These parameters can be named using almost any R-compatible name. Please
note that:

- Residual error estimates should be coded as population estimates
  (i.e. using `=` or `<-`, not `~`).
- Variable names that start with `_` are not supported. Note that R does
  not allow variable starting with `_` to be assigned without quoting
  them.
- Naming variables that start with `rx` or `nlmixr` is not suggested,
  since `rxode2()` and nlmixr use these prefixes internally for certain
  estimation routines and for calculating residuals.
- Variable names are case-sensitive, just like they are in R. `CL` is
  not the same as `Cl`.

In mixture models, multivariate normal individual deviations from the
normal population and parameters are estimated (in NONMEM these are
called “ETA” parameters). Additionally, the variance/covariance matrix
of these deviations are is also estimated (in NONMEM this is the “OMEGA”
matrix). These also take initial estimates. In nlmixr, these are
specified by the `~` operator. This that is typically used in statistics
R for “modeled by”, and was chosen to distinguish these estimates from
the population and residual error parameters.

Continuing from the prior example, we can annotate the estimates for the
between-subject error distribution…

``` r
f <- function() {
  ini({
    lCl <- 1.6      ; label("log Cl (L/hr)")
    lVc = log(90)   ; label("log V (L)")
    lKa <- 1        ; label("log Ka (1/hr)")
    prop.err <- c(0, 0.2, 1)
    
    # Initial estimate for ka IIV variance
    # Labels work for single parameters
    eta.ka ~ 0.1    ## BSV Ka

    # For correlated parameters, you specify the names of each
    # correlated parameter separated by a addition operator `+`
    # and the left handed side specifies the lower triangular
    # matrix initial of the covariance matrix.
    eta.cl + eta.vc ~ c(0.1,
                        0.005, 0.1)
    
    # Note that labels do not currently work for correlated
    # parameters.  Also, do not put comments inside the lower
    # triangular matrix as this will currently break the model.
  })
  
  # The model block will be discussed later
  model({})
}
```

As shown in the above example:

- Simple variances are specified by the variable name and the estimate
  separated by `~`
- Correlated parameters are specified by the sum of the variable labels
  and then the lower triangular matrix of the covariance is specified on
  the left handed side of the equation. This is also separated by `~`.
- The initial estimates are specified on the variance scale, and in
  analogy with NONMEM, the square roots of the diagonal elements
  correspond to coefficients of variation when used in the exponential
  IIV implementation.

#### The model block

The `model` block specifies the model, and is analogous to the `$PK`,
`$PRED` and `$ERROR` blocks in NONMEM.

Once the initialization block has been defined, you can define a model
in terms of the variables defined in the `ini` block. You can also mix
`rxode2()` blocks into the model if needed.

The current method of defining a nlmixr model is to specify the
parameters, and then any required `rxode2()` lines. Continuing the
annotated example:

``` r
f <- function() {
  ini({
    lCl <- 1.6       # log Cl (L/hr)
    lVc <- log(90)   # log Vc (L)
    lKA <- 0.1       # log Ka (1/hr)
    prop.err <- c(0, 0.2, 1)
    
    eta.Cl ~ 0.1     # BSV Cl
    eta.Vc ~ 0.1     # BSV Vc
    eta.KA ~ 0.1     # BSV Ka
  })
  model({
    # Parameters are defined in terms of the previously-defined
    # parameter names:
    Cl <- exp(lCl + eta.Cl)
    Vc =  exp(lVc + eta.Vc)
    KA <- exp(lKA + eta.KA)
    
    # Next, the differential equations are defined:
    kel <- Cl / Vc;
    
    d/dt(depot)  = -KA*depot;
    d/dt(centr)  =  KA*depot-kel*centr;
    
    # And the concentration is then calculated
    cp = centr / Vc;
    # Finally, we specify that the plasma concentration follows
    # a proportional error distribution (estimated by the parameter 
    # prop.err)
    cp ~ prop(prop.err)
  })
}
```

A few points to note:

- Parameters are defined before the differential equations. Currently
  directly defining the differential equations in terms of the
  population parameters is not supported.
- The differential equations, parameters and error terms are in a single
  block, instead of multiple sections.
- Additionally state names, calculated variables, also cannot start with
  either `rx_` or `nlmixr_` since these are used internally in some
  estimation routines.
- Errors are specified using the tilde, `~`. Currently you can use
  either `add(parameter)` for additive error, `prop(parameter)` for
  proportional error or `add(parameter1) + prop(parameter2)` for
  combined additive and proportional error. You can also specify
  `norm(parameter)` for additive error, since it follows a normal
  distribution.
- Some routines, like `saem`, require parameters expressed in terms of
  `Pop.Parameter + Individual.Deviation.Parameter + Covariate*Covariate.Parameter`.
  The order of these parameters does not matter. This is similar to
  NONMEM’s mu-referencing, though not as restrictive. This means that
  for `saem`, a parameterization of the form `Cl <- Cl*exp(eta.Cl)` is
  not allowed.
- The type of parameter in the model is determined by the `ini` block;
  covariates used in the model are not included in the `ini` block.
  These variables need to be present in the modeling dataset for the
  model to run.

### Running models

Models can be fitted several ways, including via the \[magrittr\]
forward-pipe operator.

    fit <- nlmixr(one.compartment) %>% nlmixr(data = theo_sd, est = "saem")

    fit2 <- nlmixr(one.compartment, data = theo_sd, est = "saem")

    fit3 <- one.compartment %>% nlmixr(data = theo_sd, est = "saem")

Options to the estimation routines can be specified using nlmeControl
for nlme estimation:

    fit4 <- nlmixr(one.compartment, theo_sd, est = "nlme", control = nlmeControl(pnlsTol = .5))

where options are specified in the `nlme` documentation. Options for
saem can be specified using `saemControl`:

    fit5 <- nlmixr(one.compartment,theo_sd,est="saem",control=saemControl(n.burn=250,n.em=350,print=50))

this example specifies 250 burn-in iterations, 350 em iterations and a
print progress every 50 runs.

### Model Syntax for solved PK systems

Solved PK systems are also currently supported by nlmixr with the
‘linCmt()’ pseudo-function. An annotated example of a solved system is
below:

``` r
f <- function(){
  ini({
    lCl <- 1.6      ; label("log Cl (L/hr)")
    lVc <- log(90)  ; label("log Vc (L)")
    lKA <- 0.1      ; label("log Ka (1/hr)")
    prop.err <- c(0, 0.2, 1)
    eta.Cl ~ 0.1   # BSV Cl
    eta.Vc ~ 0.1   # BSV Vc
    eta.KA ~ 0.1   # BSV Ka
  })
  model({
    Cl <- exp(lCl + eta.Cl)
    Vc = exp(lVc + eta.Vc)
    KA <- exp(lKA + eta.KA)
    ## Instead of specifying the ODEs, you can use
    ## the linCmt() function to use the solved system.
    ##
    ## This function determines the type of PK solved system
    ## to use by the parameters that are defined.  In this case
    ## it knows that this is a one-compartment model with first-order
    ## absorption.
    linCmt() ~ prop(prop.err)
  })
}
```

A few things to keep in mind:

- The solved systems implemented are the one, two and three compartment
  models with or without first-order absorption. Each of the models
  support a lag time with a tlag parameter.
- In general the linear compartment model figures out the model by the
  parameter names. `nlmixr2` currently knows about numbered volumes,
  `Vc`/`Vp`, Clearances in terms of both `Cl` and `Q`/`CLD`.
  Additionally nlmixr knows about elimination micro-constants (ie
  `K12`). Mixing of these parameters for these models is currently not
  supported.

For the most up-to-date information about `linCmt()` models see the
[rxode2
documentation](https://nlmixr2.github.io/rxode2/articles/rxode2-model-types.html#solved-compartment-models).

### Checking model syntax

After specifying the model syntax you can check that nlmixr is
interpreting it correctly by using the nlmixr function on it. Using the
above function we can get:

``` r
nlmixr(f)
```

$$\begin{aligned}
{Cl} & {= \exp\left( {lCl} + {eta.Cl} \right)} \\
{Vc} & {= \exp\left( {lVc} + {eta.Vc} \right)} \\
{KA} & {= \exp\left( {lKA} + {eta.KA} \right)} \\
{linCmt{()}} & {\sim prop(prop.err)}
\end{aligned}$$

In general this gives you information about the model (what type of
solved system/`rxode2()`), initial estimates as well as the code for the
model block.
