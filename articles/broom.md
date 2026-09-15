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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00

fit.f <- nlmixr(pheno, pheno_sd, "focei",
                control=list(print=0),
                table=list(cwres=TRUE, npde=TRUE))
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> done
#> [====|====|====|====|====|====|====|====|====|====] 0:00:04 
#> 
#> [lsoda -- internal t + h = t (h too small for machine precision)]: 146 warning(s) for subject(s): 3 (sim 23), 25 (sim 87), 20 (sim 197), 39 (sim 247)
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
#> 1  689.  986. 1004.  -487.              20.6              19.5
#> 2  691.  987. 1006.  -488.              20.6              19.5
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
#> 1  689.  986. 1004.  -487.              20.6              19.5
#> 2  691.  987. 1006.  -488.              20.6              19.5
#> 3  691.  987. 1006.  -488.              20.6              19.5
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
#> 1  689.  986. 1004.  -487.              20.6              19.5
#> 2  691.  987. 1006.  -488.              20.6              19.5
#> 3  691.  987. 1006.  -488.              20.6              19.5
```

For convenience, you can do this while you `glance` at the objects:

``` r

glance(fit.s, type="FOCEi")
#> # A tibble: 3 × 6
#>    OBJF   AIC   BIC logLik `Condition#(Cov)` `Condition#(Cor)`
#>   <dbl> <dbl> <dbl>  <dbl>             <dbl>             <dbl>
#> 1  689.  986. 1004.  -487.              20.6              19.5
#> 2  691.  987. 1006.  -488.              20.6              19.5
#> 3  691.  987. 1006.  -488.              20.6              19.5
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
#>   effect   group         term             estimate std.error statistic   p.value
#>   <chr>    <chr>         <chr>               <dbl>     <dbl>     <dbl>     <dbl>
#> 1 fixed    NA            tcl                -5.00     0.0663    -75.4   1   e+ 0
#> 2 fixed    NA            tv                  0.347    0.0530      6.54  4.66e-10
#> 3 ran_pars ID            sd__eta.cl          0.488   NA          NA    NA       
#> 4 ran_pars ID            sd__eta.v           0.399   NA          NA    NA       
#> 5 ran_pars ID            cor__eta.v.eta.…    0.962   NA          NA    NA       
#> 6 ran_pars Residual(add) add.err             2.78     0.240      11.6   7.58e-23
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
#> 1 fixed    NA            tcl               0.00671  0.000445      15.1  4.40e-32
#> 2 fixed    NA            tv                1.41     0.0750        18.9  1.27e-41
#> 3 ran_pars ID            sd__eta.cl        0.488   NA             NA   NA       
#> 4 ran_pars ID            sd__eta.v         0.399   NA             NA   NA       
#> 5 ran_pars ID            cor__eta.v.eta.…  0.962   NA             NA   NA       
#> 6 ran_pars Residual(add) add.err           2.78     0.240         11.6  7.58e-23
```

**Note:**, in accordance with the rest of the broom package, when the
parameters with the exponentiated, the standard errors are transformed
to an approximate standard error by the formula: $`\textrm{se}(\exp(x))
\approx \exp(\textrm{model estimate}_x)\times \textrm{se}_x`$. This can
be confusing because the confidence intervals (described later) are
using the actual standard error and back-transforming to the
exponentiated scale. This is the reason why the default for nlmixr’s
`broom` interface is `exponentiate=FALSE`, that is:

``` r

tidy(fit.s, exponentiate=FALSE) ## No transformation applied
#> # A tibble: 6 × 7
#>   effect   group         term             estimate std.error statistic   p.value
#>   <chr>    <chr>         <chr>               <dbl>     <dbl>     <dbl>     <dbl>
#> 1 fixed    NA            tcl                -5.00     0.0663    -75.4   1   e+ 0
#> 2 fixed    NA            tv                  0.347    0.0530      6.54  4.66e-10
#> 3 ran_pars ID            sd__eta.cl          0.488   NA          NA    NA       
#> 4 ran_pars ID            sd__eta.v           0.399   NA          NA    NA       
#> 5 ran_pars ID            cor__eta.v.eta.…    0.962   NA          NA    NA       
#> 6 ran_pars Residual(add) add.err             2.78     0.240      11.6   7.58e-23
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
#> 1 fixed    NA            tcl               0.00671  0.000445      15.1  4.40e-32
#> 2 fixed    NA            tv                1.41     0.0750        18.9  1.27e-41
#> 3 ran_pars ID            sd__eta.cl        0.488   NA             NA   NA       
#> 4 ran_pars ID            sd__eta.v         0.399   NA             NA   NA       
#> 5 ran_pars ID            cor__eta.v.eta.…  0.962   NA             NA   NA       
#> 6 ran_pars Residual(add) add.err           2.78     0.240         11.6  7.58e-23
```

Also note, at the time of this writing the default separator between
variables is `.`, which doesn’t work well with this model giving
`cor__eta.v.eta.cl`. You can easily change this by:

``` r

options(broom.mixed.sep2="..")
tidy(fit.s)
#> # A tibble: 6 × 7
#>   effect   group         term             estimate std.error statistic   p.value
#>   <chr>    <chr>         <chr>               <dbl>     <dbl>     <dbl>     <dbl>
#> 1 fixed    NA            tcl                -5.00     0.0663    -75.4   1   e+ 0
#> 2 fixed    NA            tv                  0.347    0.0530      6.54  4.66e-10
#> 3 ran_pars ID            sd__eta.cl          0.488   NA          NA    NA       
#> 4 ran_pars ID            sd__eta.v           0.399   NA          NA    NA       
#> 5 ran_pars ID            cor__eta.v..eta…    0.962   NA          NA    NA       
#> 6 ran_pars Residual(add) add.err             2.78     0.240      11.6   7.58e-23
```

This gives an easier way to parse value: `cor__eta.v..eta.cl`

### Adding a confidence interval to the parameters

The default R method `confint` works with nlmixr fit objects:

``` r

confint(fit.s)
#>          model.est    estimate      2.5 %    97.5 %
#> tcl     -5.0038694 0.006711926 -5.1338600 -4.873879
#> tv       0.3465891 1.414235512  0.2426922  0.450486
#> add.err  2.7811642 2.781164168  2.3108388  3.251490
```

This transforms the variables as described above. You can still use the
`exponentiate` parameter to control the display of the confidence
interval:

``` r

confint(fit.s, exponentiate=FALSE)
#>          model.est    estimate      2.5 %    97.5 %
#> tcl     -5.0038694 0.006711926 -5.1338600 -4.873879
#> tv       0.3465891 1.414235512  0.2426922  0.450486
#> add.err  2.7811642 2.781164168  2.3108388  3.251490
```

However, broom has also implemented it own way to make these data a tidy
dataset. The easiest way to get these values in a nlmixr dataset is to
use:

``` r

tidy(fit.s, conf.level=0.9)
#> # A tibble: 6 × 9
#>   effect   group term  estimate std.error statistic   p.value conf.low conf.high
#>   <chr>    <chr> <chr>    <dbl>     <dbl>     <dbl>     <dbl>    <dbl>     <dbl>
#> 1 fixed    NA    tcl     -5.00     0.0663    -75.4   1   e+ 0   -5.11     -4.89 
#> 2 fixed    NA    tv       0.347    0.0530      6.54  4.66e-10    0.259     0.434
#> 3 ran_pars ID    sd__…    0.488   NA          NA    NA          NA        NA    
#> 4 ran_pars ID    sd__…    0.399   NA          NA    NA          NA        NA    
#> 5 ran_pars ID    cor_…    0.962   NA          NA    NA          NA        NA    
#> 6 ran_pars Resi… add.…    2.78     0.240      11.6   7.58e-23   NA        NA
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
#> 1 fixed    NA    tcl    0.00671  0.000445      15.1  4.40e-32  0.00602   0.00749
#> 2 fixed    NA    tv     1.41     0.0750        18.9  1.27e-41  1.30      1.54   
#> 3 ran_pars ID    sd__…  0.488   NA             NA   NA        NA        NA      
#> 4 ran_pars ID    sd__…  0.399   NA             NA   NA        NA        NA      
#> 5 ran_pars ID    cor_…  0.962   NA             NA   NA        NA        NA      
#> 6 ran_pars Resi… add.…  2.78     0.240         11.6  7.58e-23 NA        NA
```

## Extracting other model information with `tidy`

The type of information that is extracted can be controlled by the
`effects` argument.

### Extracting only fixed effect parameters

The fixed effect parameters can be extracted by `effects="fixed"`

``` r

tidy(fit.s, effects="fixed")
#> # A tibble: 2 × 6
#>   effect term  estimate std.error statistic  p.value
#>   <chr>  <chr>    <dbl>     <dbl>     <dbl>    <dbl>
#> 1 fixed  tcl     -5.00     0.0663    -75.4  1   e+ 0
#> 2 fixed  tv       0.347    0.0530      6.54 4.66e-10
```

### Extracting only random parameters

The random standard deviations can be extracted by `effects="ran_pars"`:

``` r

tidy(fit.s, effects="ran_pars")
#> # A tibble: 4 × 7
#>   effect   group         term             estimate std.error statistic   p.value
#>   <chr>    <chr>         <chr>               <dbl>     <dbl>     <dbl>     <dbl>
#> 1 ran_pars ID            sd__eta.cl          0.488    NA          NA   NA       
#> 2 ran_pars ID            sd__eta.v           0.399    NA          NA   NA       
#> 3 ran_pars ID            cor__eta.v..eta…    0.962    NA          NA   NA       
#> 4 ran_pars Residual(add) add.err             2.78      0.240      11.6  7.58e-23
```

### Extracting random values (also called ETAs)

The random values, or in NONMEM the ETAs, can be extracted by
`effects="ran_vals"` or `effects="random"`

``` r

head(tidy(fit.s, effects="ran_vals"))
#> # A tibble: 6 × 5
#>   effect   group level term   estimate
#>   <chr>    <chr> <fct> <fct>     <dbl>
#> 1 ran_vals ID    1     eta.cl  -0.0790
#> 2 ran_vals ID    2     eta.cl  -0.220 
#> 3 ran_vals ID    3     eta.cl   0.265 
#> 4 ran_vals ID    4     eta.cl  -0.524 
#> 5 ran_vals ID    5     eta.cl   0.323 
#> 6 ran_vals ID    6     eta.cl  -0.152
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
#> 1 ran_coef ID    1     tcl      -5.08
#> 2 ran_coef ID    2     tcl      -5.22
#> 3 ran_coef ID    3     tcl      -4.74
#> 4 ran_coef ID    4     tcl      -5.53
#> 5 ran_coef ID    5     tcl      -4.68
#> 6 ran_coef ID    6     tcl      -5.16
```

This can also be changed by the `exponentiate` argument:

``` r

head(tidy(fit.s, effects="ran_coef", exponentiate=NA))
#> # A tibble: 6 × 5
#>   effect   group level term  estimate
#>   <chr>    <chr> <fct> <fct>    <dbl>
#> 1 ran_coef ID    1     tcl    0.00620
#> 2 ran_coef ID    2     tcl    0.00539
#> 3 ran_coef ID    3     tcl    0.00875
#> 4 ran_coef ID    4     tcl    0.00398
#> 5 ran_coef ID    5     tcl    0.00927
#> 6 ran_coef ID    6     tcl    0.00577
head(tidy(fit.s, effects="ran_coef", exponentiate=TRUE))
#> # A tibble: 6 × 5
#>   effect   group level term  estimate
#>   <chr>    <chr> <fct> <fct>    <dbl>
#> 1 ran_coef ID    1     tcl    0.00620
#> 2 ran_coef ID    2     tcl    0.00539
#> 3 ran_coef ID    3     tcl    0.00875
#> 4 ran_coef ID    4     tcl    0.00398
#> 5 ran_coef ID    5     tcl    0.00927
#> 6 ran_coef ID    6     tcl    0.00577
```
