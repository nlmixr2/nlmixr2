# Using broom with nlmixr2

![nlmixr](logo.png)

nlmixr

### The broom and broom.mixed packages

`broom` and `broom.mixed` are packages that attempt to put standard
model outputs into data frames. nlmixr supports the `tidy` and `glance`
methods but does not support `augment` at this time.

Using a model with a covariance term, the [Phenobarbital
model](https://nlmixr2.github.io/nlmixr2/articles/addingCovariances.md),
we can explore the different types of output that is used in the tidy
functions.

To explore this, first we run the model:

``` r
library(nlmixr2)
library(broom.mixed)

pheno <- function() {
  # Pheno with covariance
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

## We will run it two ways to allow comparisons
fit.s <- nlmixr(pheno, pheno_sd, "saem", control=list(logLik=TRUE, print=0),
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

fit.f <- nlmixr(pheno, pheno_sd, "focei",
                control=list(print=0),
                table=list(cwres=TRUE, npde=TRUE))
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> done
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
```

## Glancing at the goodness of fit metrics

Often in fitting data, you would want to `glance` at the fit to see how
well it fits. In `broom`, `glance` will give a summary of the fit
metrics of goodness of fit:

``` r
glance(fit.s)
#> # A tibble: 2 × 6
#>    OBJF   AIC   BIC logLik `Condition#(Cov)` `Condition#(Cor)`
#>   <dbl> <dbl> <dbl>  <dbl>             <dbl>             <dbl>
#> 1  689.  986. 1004.  -487.              6.03              5.25
#> 2  698.  995. 1013.  -492.              6.03              5.25
```

Note in nlmixr it is possible to have more than one fit metric (based on
different quadratures, FOCEi approximation etc). However, the `glance`
only returns the fit metrics that are current.

If you wish you can set the objective function to the focei objective
function (which was already calculated with CWRES).

``` r
setOfv(fit.s,"gauss3_1.6")
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
```

Now the glance gives the `gauss3_1.6` values.

``` r
glance(fit.s)
#> # A tibble: 3 × 6
#>    OBJF   AIC   BIC logLik `Condition#(Cov)` `Condition#(Cor)`
#>   <dbl> <dbl> <dbl>  <dbl>             <dbl>             <dbl>
#> 1  689.  986. 1004.  -487.              6.03              5.25
#> 2  698.  995. 1013.  -492.              6.03              5.25
#> 3  698.  995. 1013.  -492.              6.03              5.25
```

Of course you can always change the type of objective function that
nlmixr uses:

``` r
setOfv(fit.s,"FOCEi") # Setting objective function to focei
```

By setting it back to the SAEM default objective function of `FOCEi`,
the `glance(fit.s)` has the same values again:

``` r
glance(fit.s)
#> # A tibble: 3 × 6
#>    OBJF   AIC   BIC logLik `Condition#(Cov)` `Condition#(Cor)`
#>   <dbl> <dbl> <dbl>  <dbl>             <dbl>             <dbl>
#> 1  689.  986. 1004.  -487.              6.03              5.25
#> 2  698.  995. 1013.  -492.              6.03              5.25
#> 3  698.  995. 1013.  -492.              6.03              5.25
```

For convenience, you can do this while you `glance` at the objects:

``` r
glance(fit.s, type="FOCEi")
#> # A tibble: 3 × 6
#>    OBJF   AIC   BIC logLik `Condition#(Cov)` `Condition#(Cor)`
#>   <dbl> <dbl> <dbl>  <dbl>             <dbl>             <dbl>
#> 1  689.  986. 1004.  -487.              6.03              5.25
#> 2  698.  995. 1013.  -492.              6.03              5.25
#> 3  698.  995. 1013.  -492.              6.03              5.25
```

## Tidying the model parameters

### Tidying of overall fit parameters

You can also tidy the model estimates into a data frame with broom for
processing. This can be useful when integrating into 3rd parting
modeling packages. With a consistent parameter format, tasks for
multiple types of models can be automated and applied.

The default function for this is `tidy`, which when applied to the `fit`
object provides the overall parameter information in a tidy dataset:

``` r
tidy(fit.s)
#> # A tibble: 6 × 7
#>   effect   group         term              estimate std.error statistic  p.value
#>   <chr>    <chr>         <chr>                <dbl>     <dbl>     <dbl>    <dbl>
#> 1 fixed    NA            tcl                 -5.02     0.0750    -66.9   1   e+0
#> 2 fixed    NA            tv                   0.350    0.0548      6.37  1.09e-9
#> 3 ran_pars ID            sd__eta.cl           0.488   NA          NA    NA      
#> 4 ran_pars ID            sd__eta.v            0.402   NA          NA    NA      
#> 5 ran_pars ID            cor__eta.v.eta.cl    0.946   NA          NA    NA      
#> 6 ran_pars Residual(add) add.err              2.76    NA          NA    NA    
```

Note by default these are the parameters that are *actually* estimated
in nlmixr, not the back-transformed values in the table from the
printout. Of course, with mu-referenced models, you may want to
exponentiate some of the terms. The broom package allows you to apply
exponentiation on *all* the parameters, that is:

``` r
## Transformation applied on every parameter
tidy(fit.s, exponentiate=TRUE)
#> # A tibble: 6 × 7
#>   effect   group         term             estimate std.error statistic   p.value
#>   <chr>    <chr>         <chr>               <dbl>     <dbl>     <dbl>     <dbl>
#> 1 fixed    NA            tcl               0.00663  0.000498      13.3  1.75e-27
#> 2 fixed    NA            tv                1.42     0.0778        18.2  4.27e-40
#> 3 ran_pars ID            sd__eta.cl        0.488   NA             NA   NA       
#> 4 ran_pars ID            sd__eta.v         0.402   NA             NA   NA       
#> 5 ran_pars ID            cor__eta.v.eta.…  0.946   NA             NA   NA       
#> 6 ran_pars Residual(add) add.err           2.76    NA             NA   NA    
```

**Note:**, in accordance with the rest of the broom package, when the
parameters with the exponentiated, the standard errors are transformed
to an approximate standard error by the formula:
$\text{se}\left( \exp(x) \right) \approx \exp\left( \text{model estimate}_{x} \right) \times \text{se}_{x}$.
This can be confusing because the confidence intervals (described later)
are using the actual standard error and back-transforming to the
exponentiated scale. This is the reason why the default for nlmixr’s
`broom` interface is `exponentiate=FALSE`, that is:

``` r
tidy(fit.s, exponentiate=FALSE) ## No transformation applied
#> # A tibble: 6 × 7
#>   effect   group         term              estimate std.error statistic  p.value
#>   <chr>    <chr>         <chr>                <dbl>     <dbl>     <dbl>    <dbl>
#> 1 fixed    NA            tcl                 -5.02     0.0750    -66.9   1   e+0
#> 2 fixed    NA            tv                   0.350    0.0548      6.37  1.09e-9
#> 3 ran_pars ID            sd__eta.cl           0.488   NA          NA    NA      
#> 4 ran_pars ID            sd__eta.v            0.402   NA          NA    NA      
#> 5 ran_pars ID            cor__eta.v.eta.cl    0.946   NA          NA    NA      
#> 6 ran_pars Residual(add) add.err              2.76    NA          NA    NA    
```

If you want, you can also use the parsed back-transformation that is
used in nlmixr tables (ie `fit$parFixedDf`). **Please note that this
uses the approximate back-transformation for standard errors on the
log-scaled back-transformed values**.

This is done by:

``` r
## Transformation applied to log-scaled population parameters
tidy(fit.s, exponentiate=NA)
#> # A tibble: 6 × 7
#>   effect   group         term             estimate std.error statistic   p.value
#>   <chr>    <chr>         <chr>               <dbl>     <dbl>     <dbl>     <dbl>
#> 1 fixed    NA            tcl               0.00663  0.000498      13.3  1.75e-27
#> 2 fixed    NA            tv                1.42     0.0778        18.2  4.27e-40
#> 3 ran_pars ID            sd__eta.cl        0.488   NA             NA   NA       
#> 4 ran_pars ID            sd__eta.v         0.402   NA             NA   NA       
#> 5 ran_pars ID            cor__eta.v.eta.…  0.946   NA             NA   NA       
#> 6 ran_pars Residual(add) add.err           2.76    NA             NA   NA    
```

Also note, at the time of this writing the default separator between
variables is `.`, which doesn’t work well with this model giving
`cor__eta.v.eta.cl`. You can easily change this by:

``` r
options(broom.mixed.sep2="..")
tidy(fit.s)
#> # A tibble: 6 × 7
#>   effect   group         term              estimate std.error statistic  p.value
#>   <chr>    <chr>         <chr>                <dbl>     <dbl>     <dbl>    <dbl>
#> 1 fixed    NA            tcl                 -5.02     0.0750    -66.9   1   e+0
#> 2 fixed    NA            tv                   0.350    0.0548      6.37  1.09e-9
#> 3 ran_pars ID            sd__eta.cl           0.488   NA          NA    NA      
#> 4 ran_pars ID            sd__eta.v            0.402   NA          NA    NA      
#> 5 ran_pars ID            cor__eta.v..eta.…    0.946   NA          NA    NA      
#> 6 ran_pars Residual(add) add.err              2.76    NA          NA    NA    
```

This gives an easier way to parse value: `cor__eta.v..eta.cl`

### Adding a confidence interval to the parameters

The default R method `confint` works with nlmixr fit objects:

``` r
confint(fit.s)
#>          model.est   estimate      2.5 %     97.5 %
#> tcl     -5.0154795 0.00663445 -5.1625159 -4.8684431
#> tv       0.3495036 1.41836329  0.2420439  0.4569632
#> add.err  2.7649251 2.76492510         NA         NA
```

This transforms the variables as described above. You can still use the
`exponentiate` parameter to control the display of the confidence
interval:

``` r
confint(fit.s, exponentiate=FALSE)
#>          model.est   estimate      2.5 %     97.5 %
#> tcl     -5.0154795 0.00663445 -5.1625159 -4.8684431
#> tv       0.3495036 1.41836329  0.2420439  0.4569632
#> add.err  2.7649251 2.76492510         NA         NA
```

However, broom has also implemented it own way to make these data a tidy
dataset. The easiest way to get these values in a nlmixr dataset is to
use:

``` r
tidy(fit.s, conf.level=0.9)
#> # A tibble: 6 × 9
#>   effect   group  term  estimate std.error statistic  p.value conf.low conf.high
#>   <chr>    <chr>  <chr>    <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>
#> 1 fixed    NA     tcl     -5.02     0.0750    -66.9   1   e+0   -5.14     -4.89 
#> 2 fixed    NA     tv       0.350    0.0548      6.37  1.09e-9    0.259     0.440
#> 3 ran_pars ID     sd__…    0.488   NA          NA    NA         NA        NA    
#> 4 ran_pars ID     sd__…    0.402   NA          NA    NA         NA        NA    
#> 5 ran_pars ID     cor_…    0.946   NA          NA    NA         NA        NA    
#> 6 ran_pars Resid… add.…    2.76    NA          NA    NA         NA        NA
```

The confidence interval is on the scale specified by `exponentiate`, by
default the estimated scale.

If you want to have the confidence on the adaptive back-transformed
scale, you would simply use the following:

``` r
tidy(fit.s, conf.level=0.9, exponentiate=NA)
#> # A tibble: 6 × 9
#>   effect   group term  estimate std.error statistic   p.value conf.low conf.high
#>   <chr>    <chr> <chr>    <dbl>     <dbl>     <dbl>     <dbl>    <dbl>     <dbl>
#> 1 fixed    NA    tcl    0.00663  0.000498      13.3  1.75e-27  0.00586   0.00751
#> 2 fixed    NA    tv     1.42     0.0778        18.2  4.27e-40  1.30      1.55   
#> 3 ran_pars ID    sd__…  0.488   NA             NA   NA        NA        NA      
#> 4 ran_pars ID    sd__…  0.402   NA             NA   NA        NA        NA      
#> 5 ran_pars ID    cor_…  0.946   NA             NA   NA        NA        NA      
#> 6 ran_pars Resi… add.…  2.76    NA             NA   NA        NA        NA
```

## Extracting other model information with `tidy`

The type of information that is extracted can be controlled by the
`effects` argument.

### Extracting only fixed effect parameters

The fixed effect parameters can be extracted by `effects="fixed"`

``` r
tidy(fit.s, effects="fixed")
#> # A tibble: 2 × 6
#>   effect term  estimate std.error statistic       p.value
#>   <chr>  <chr>    <dbl>     <dbl>     <dbl>         <dbl>
#> 1 fixed  tcl     -5.02     0.0750    -66.9  1            
#> 2 fixed  tv       0.350    0.0548      6.37 0.00000000109
```

### Extracting only random parameters

The random standard deviations can be extracted by `effects="ran_pars"`:

``` r
tidy(fit.s, effects="ran_pars")
#> # A tibble: 4 × 4
#>   effect   group         term               estimate
#>   <chr>    <chr>         <chr>                 <dbl>
#> 1 ran_pars ID            sd__eta.cl            0.488
#> 2 ran_pars ID            sd__eta.v             0.402
#> 3 ran_pars ID            cor__eta.v..eta.cl    0.946
#> 4 ran_pars Residual(add) add.err               2.76
```

### Extracting random values (also called ETAs)

The random values, or in NONMEM the ETAs, can be extracted by
`effects="ran_vals"` or `effects="random"`

``` r
head(tidy(fit.s, effects="ran_vals"))
#> # A tibble: 6 × 5
#>   effect   group level term   estimate
#>   <chr>    <chr> <fct> <fct>     <dbl>
#> 1 ran_vals ID    1     eta.cl  -0.0854
#> 2 ran_vals ID    2     eta.cl  -0.232 
#> 3 ran_vals ID    3     eta.cl   0.257 
#> 4 ran_vals ID    4     eta.cl  -0.522 
#> 5 ran_vals ID    5     eta.cl   0.316 
#> 6 ran_vals ID    6     eta.cl  -0.163
```

This duplicate method of running `effects` is because the `broom`
package supports `effects="random"` while the `broom.mixed` package
supports `effects="ran_vals"`.

### Extracting random coefficients

Random coefficients are the population fixed effect parameter + the
random effect parameter, possibly transformed to the correct scale.

In this case we can extract this information from a nlmixr fit object
by:

``` r
head(tidy(fit.s, effects="ran_coef"))
#> # A tibble: 6 × 5
#>   effect   group level term  estimate
#>   <chr>    <chr> <fct> <fct>    <dbl>
#> 1 ran_coef ID    1     tcl      -5.10
#> 2 ran_coef ID    2     tcl      -5.25
#> 3 ran_coef ID    3     tcl      -4.76
#> 4 ran_coef ID    4     tcl      -5.54
#> 5 ran_coef ID    5     tcl      -4.70
#> 6 ran_coef ID    6     tcl      -5.18
```

This can also be changed by the `exponentiate` argument:

``` r
head(tidy(fit.s, effects="ran_coef", exponentiate=NA))
#> # A tibble: 6 × 5
#>   effect   group level term  estimate
#>   <chr>    <chr> <fct> <fct>    <dbl>
#> 1 ran_coef ID    1     tcl    0.00609
#> 2 ran_coef ID    2     tcl    0.00526
#> 3 ran_coef ID    3     tcl    0.00858
#> 4 ran_coef ID    4     tcl    0.00393
#> 5 ran_coef ID    5     tcl    0.00910
#> 6 ran_coef ID    6     tcl    0.00564
head(tidy(fit.s, effects="ran_coef", exponentiate=TRUE))
#> # A tibble: 6 × 5
#>   effect   group level term  estimate
#>   <chr>    <chr> <fct> <fct>    <dbl>
#> 1 ran_coef ID    1     tcl    0.00609
#> 2 ran_coef ID    2     tcl    0.00526
#> 3 ran_coef ID    3     tcl    0.00858
#> 4 ran_coef ID    4     tcl    0.00393
#> 5 ran_coef ID    5     tcl    0.00910
#> 6 ran_coef ID    6     tcl    0.00564
```
