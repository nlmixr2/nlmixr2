# Working with multiple endpoints

![nlmixr](logo.png)

nlmixr

## Multiple endpoints

Joint PK/PD models, or PK/PD models where you fix certain components are
common in pharmacometrics. A classic example, (provided by Tomoo Funaki
and Nick Holford) is Warfarin.

``` r
library(nlmixr2)
library(ggplot2)
```

In this example, we have a transit-compartment (from depot to gut to
central volume) PK model and an effect compartment for the PCA
measurement.

Below is an illustrated example of a model that can be applied to the
data:

``` r
pk.turnover.emax <- function() {
  ini({
    tktr <- log(1)
    tka <- log(1)
    tcl <- log(0.1)
    tv <- log(10)
    ##
    eta.ktr ~ 1
    eta.ka ~ 1
    eta.cl ~ 2
    eta.v ~ 1
    prop.err <- 0.1
    pkadd.err <- 0.1
    ##
    temax <- logit(0.8)
    #temax <- 7.5
    tec50 <- log(0.5)
    tkout <- log(0.05)
    te0 <- log(100)
    ##
    eta.emax ~ .5
    eta.ec50  ~ .5
    eta.kout ~ .5
    eta.e0 ~ .5
    ##
    pdadd.err <- 10
  })
  model({
    ktr <- exp(tktr + eta.ktr)
    ka <- exp(tka + eta.ka)
    cl <- exp(tcl + eta.cl)
    v <- exp(tv + eta.v)
    ##
    #poplogit = log(temax/(1-temax))
    emax=expit(temax+eta.emax)
    #logit=temax+eta.emax
    ec50 =  exp(tec50 + eta.ec50)
    kout = exp(tkout + eta.kout)
    e0 = exp(te0 + eta.e0)
    ##
    DCP = center/v
    PD=1-emax*DCP/(ec50+DCP)
    ##
    effect(0) = e0
    kin = e0*kout
    ##
    d/dt(depot) = -ktr * depot
    d/dt(gut) =  ktr * depot -ka * gut
    d/dt(center) =  ka * gut - cl / v * center
    d/dt(effect) = kin*PD -kout*effect
    ##
    cp = center / v
    cp ~ prop(prop.err) + add(pkadd.err)
    effect ~ add(pdadd.err)
  })
}
```

Notice there are two endpoints in the model `cp` and `effect`. Both are
modeled in nlmixr using the `~` “modeled by” specification.

To see more about how nlmixr will handle the multiple compartment model,
it is quite informative to parse the model and print the information
about that model. In this case an initial parsing would give:

``` r
ui <- nlmixr(pk.turnover.emax)
ui
```

$$\begin{aligned}
{ktr} & {= \exp\left( {tktr} + {eta.ktr} \right)} \\
{ka} & {= \exp\left( {tka} + {eta.ka} \right)} \\
{cl} & {= \exp\left( {tcl} + {eta.cl} \right)} \\
v & {= \exp\left( {tv} + {eta.v} \right)} \\
{emax} & {= expit\left( {temax} + {eta.emax},0,1 \right)} \\
{ec50} & {= \exp\left( {tec50} + {eta.ec50} \right)} \\
{kout} & {= \exp\left( {tkout} + {eta.kout} \right)} \\
{e0} & {= \exp\left( {te0} + {eta.e0} \right)} \\
{DCP} & {= \frac{center}{v}} \\
{PD} & {= 1 - \frac{{emax} \times {DCP}}{\left( {ec50} + {DCP} \right)}} \\
{effect(0)} & {= {e0}} \\
{kin} & {= {e0} \times {kout}} \\
\frac{d\ depot}{dt} & {= - {ktr} \times {depot}} \\
\frac{d\ gut}{dt} & {= {ktr} \times {depot} - {ka} \times {gut}} \\
\frac{d\ center}{dt} & {= {ka} \times {gut} - \frac{cl}{v} \times {center}} \\
\frac{d\ effect}{dt} & {= {kin} \times {PD} - {kout} \times {effect}} \\
{cp} & {= \frac{center}{v}} \\
{cp} & {\sim prop(prop.err) + add(pkadd.err)} \\
{effect} & {\sim add(pdadd.err)}
\end{aligned}$$

In the middle of the printout, it shows how the data must be formatted
(using the `cmt` and `dvid` data items) to allow nlmixr to model the
multiple endpoint appropriately.

Of course, if you are interested you can directly access the information
in `ui$multipleEndpoint`.

``` r
ui$multipleEndpoint
#>     variable                   cmt                   dvid*
#> 1     cp ~ …     cmt='cp' or cmt=5     dvid='cp' or dvid=1
#> 2 effect ~ … cmt='effect' or cmt=4 dvid='effect' or dvid=2
```

Notice that the `cmt` and `dvid` items can use the named variables
directly as either the `cmt` or `dvid` specification. This flexible
notation makes it so you do not have to rename your compartments to run
nlmixr model functions.

The other thing to note is that the `cp` is specified by an ODE
compartment above the number of compartments defined in the `rxode2`
part of the `nlmixr` model. This is because `cp` is not a defined
compartment, but a related variable `cp`.

The last thing to notice that the `cmt` items are numbered `cmt=5` for
`cp` or `cmt=4` for `effect` even though they were specified in the
model first by `cp` and `cmt`. This ordering is because `effect` is a
compartment in the `rxode2` system. Of course `cp` is related to the
compartment `center`, and it may make more sense to pair `cp` with the
`center` compartment.

If this is something you want to have you can specify the compartment to
relate the effect to by the `|` operator. In this case you would change

    cp ~ prop(prop.err) + add(pkadd.err)

to

    cp ~ prop(prop.err) + add(pkadd.err) | center

With this change, the model could be updated to:

``` r
pk.turnover.emax2 <- function() {
  ini({
    tktr <- log(1)
    tka <- log(1)
    tcl <- log(0.1)
    tv <- log(10)
    ##
    eta.ktr ~ 1
    eta.ka ~ 1
    eta.cl ~ 2
    eta.v ~ 1
    prop.err <- 0.1
    pkadd.err <- 0.1
    ##
    temax <- logit(0.8)
    tec50 <- log(0.5)
    tkout <- log(0.05)
    te0 <- log(100)
    ##
    eta.emax ~ .5
    eta.ec50  ~ .5
    eta.kout ~ .5
    eta.e0 ~ .5
    ##
    pdadd.err <- 10
  })
  model({
    ktr <- exp(tktr + eta.ktr)
    ka <- exp(tka + eta.ka)
    cl <- exp(tcl + eta.cl)
    v <- exp(tv + eta.v)
    ##
    emax=expit(temax+eta.emax)
    ec50 =  exp(tec50 + eta.ec50)
    kout = exp(tkout + eta.kout)
    e0 = exp(te0 + eta.e0)
    ##
    DCP = center/v
    PD=1-emax*DCP/(ec50+DCP)
    ##
    effect(0) = e0
    kin = e0*kout
    ##
    d/dt(depot) = -ktr * depot
    d/dt(gut) =  ktr * depot -ka * gut
    d/dt(center) =  ka * gut - cl / v * center
    d/dt(effect) = kin*PD -kout*effect
    ##
    cp = center / v
    cp ~ prop(prop.err) + add(pkadd.err) | center
    effect ~ add(pdadd.err)
  })
}
ui2 <- nlmixr(pk.turnover.emax2)
ui2$multipleEndpoint
#>     variable                   cmt                   dvid*
#> 1     cp ~ … cmt='center' or cmt=3 dvid='center' or dvid=1
#> 2 effect ~ … cmt='effect' or cmt=4 dvid='effect' or dvid=2
```

Notice in this case the `cmt` variables are numbered sequentially and
the `cp` variable matches the `center` compartment.

### DVID vs CMT, which one is used

When `dvid` and `cmt` are combined in the same dataset, the `cmt` data
item is always used on the event information and the `dvid` is used on
the observations. `nlmixr` expects the `cmt` data item to match the
`dvid` item for observations OR to be either zero or one for the `dvid`
to replace the `cmt` information.

If you do not wish to use `dvid` items to define multiple endpoints in
nlmixr, you can set the following option:

``` r
options(rxode2.combine.dvid=FALSE)
ui2$multipleEndpoint
#>     variable                   cmt
#> 1     cp ~ … cmt='center' or cmt=3
#> 2 effect ~ … cmt='effect' or cmt=4
```

Then only `cmt` items are used for the multiple endpoint models. Of
course you can turn it on or off for different models if you wish:

``` r
options(rxode2.combine.dvid=TRUE)
ui2$multipleEndpoint
#>     variable                   cmt                   dvid*
#> 1     cp ~ … cmt='center' or cmt=3 dvid='center' or dvid=1
#> 2 effect ~ … cmt='effect' or cmt=4 dvid='effect' or dvid=2
```

### Running a multiple endpoint model

With this information, we can use the built-in warfarin dataset in
`nlmixr2`:

``` r
summary(warfarin)
#>        id             time             amt                dv          dvid    
#>  Min.   : 1.00   Min.   :  0.00   Min.   :  0.000   Min.   :  0.00   cp :283  
#>  1st Qu.: 8.00   1st Qu.: 24.00   1st Qu.:  0.000   1st Qu.:  4.50   pca:232  
#>  Median :15.00   Median : 48.00   Median :  0.000   Median : 11.40            
#>  Mean   :16.08   Mean   : 52.08   Mean   :  6.524   Mean   : 20.02            
#>  3rd Qu.:24.00   3rd Qu.: 96.00   3rd Qu.:  0.000   3rd Qu.: 26.00            
#>  Max.   :33.00   Max.   :144.00   Max.   :153.000   Max.   :100.00            
#>       evid               wt              age            sex     
#>  Min.   :0.00000   Min.   : 40.00   Min.   :21.00   female:101  
#>  1st Qu.:0.00000   1st Qu.: 60.00   1st Qu.:23.00   male  :414  
#>  Median :0.00000   Median : 70.00   Median :28.00               
#>  Mean   :0.06214   Mean   : 69.27   Mean   :31.85               
#>  3rd Qu.:0.00000   3rd Qu.: 78.00   3rd Qu.:36.00               
#>  Max.   :1.00000   Max.   :102.00   Max.   :63.00
```

Since dvid specifies `pca` as the effect endpoint, you can update the
model to be more explicit making one last change:

    cp ~ prop(prop.err) + add(pkadd.err)
    effect ~ add(pdadd.err) 

to

    cp ~ prop(prop.err) + add(pkadd.err)
    effect ~ add(pdadd.err)  | pca

``` r
pk.turnover.emax3 <- function() {
  ini({
    tktr <- log(1)
    tka <- log(1)
    tcl <- log(0.1)
    tv <- log(10)
    ##
    eta.ktr ~ 1
    eta.ka ~ 1
    eta.cl ~ 2
    eta.v ~ 1
    prop.err <- 0.1
    pkadd.err <- 0.1
    ##
    temax <- logit(0.8)
    tec50 <- log(0.5)
    tkout <- log(0.05)
    te0 <- log(100)
    ##
    eta.emax ~ .5
    eta.ec50  ~ .5
    eta.kout ~ .5
    eta.e0 ~ .5
    ##
    pdadd.err <- 10
  })
  model({
    ktr <- exp(tktr + eta.ktr)
    ka <- exp(tka + eta.ka)
    cl <- exp(tcl + eta.cl)
    v <- exp(tv + eta.v)
    emax = expit(temax+eta.emax)
    ec50 =  exp(tec50 + eta.ec50)
    kout = exp(tkout + eta.kout)
    e0 = exp(te0 + eta.e0)
    ##
    DCP = center/v
    PD=1-emax*DCP/(ec50+DCP)
    ##
    effect(0) = e0
    kin = e0*kout
    ##
    d/dt(depot) = -ktr * depot
    d/dt(gut) =  ktr * depot -ka * gut
    d/dt(center) =  ka * gut - cl / v * center
    d/dt(effect) = kin*PD -kout*effect
    ##
    cp = center / v
    cp ~ prop(prop.err) + add(pkadd.err)
    effect ~ add(pdadd.err) | pca
  })
}
```

### Run the models with SAEM

``` r
fit.TOS <- nlmixr(pk.turnover.emax3, warfarin, "saem", control=list(print=0),
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
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00 
#> 
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00
#> [====|====|====|====|====|====|====|====|====|====] 0:00:00

print(fit.TOS)
#> ── nlmixr² SAEM OBJF by FOCEi approximation ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 1384.332 2310.026 2389.447      -1136.013        3858.333        21.90437
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance   saem  table compress
#> elapsed 0.003044    8e-06   0.048015 116.43 15.664        0
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>              Est.     SE  %RSE Back-transformed(95%CI) BSV(CV% or SD)
#> tktr        0.439  0.557   127      1.55 (0.521, 4.62)           110.
#> tka        -0.262  0.279   107      0.77 (0.445, 1.33)           13.4
#> tcl         -1.97 0.0515  2.62     0.14 (0.126, 0.155)           26.8
#> tv           2.01 0.0483  2.41       7.43 (6.76, 8.17)           21.7
#> prop.err     0.12                                 0.12               
#> pkadd.err   0.805                                0.805               
#> temax        3.44  0.694  20.2    0.969 (0.889, 0.992)          0.251
#> tec50     -0.0938  0.146   155      0.91 (0.684, 1.21)           45.9
#> tkout       -2.94 0.0384  1.31 0.0531 (0.0492, 0.0572)           5.97
#> te0          4.57 0.0116 0.253       96.6 (94.4, 98.8)           5.29
#> pdadd.err     3.6                                  3.6               
#>           Shrink(SD)%
#> tktr           44.2% 
#> tka            81.7% 
#> tcl            6.72% 
#> tv             15.9% 
#> prop.err             
#> pkadd.err            
#> temax          81.3% 
#> tec50          9.87% 
#> tkout          45.6% 
#> te0            17.1% 
#> pdadd.err            
#>  
#>   Covariance Type ($covMethod): linFim
#>   No correlations in between subject variability (BSV) matrix
#>   Full BSV covariance ($omega) or correlation ($omegaR; diagonals=SDs) 
#>   Distribution stats (mean/skewness/kurtosis/p-value) available in $shrink 
#>   Censoring ($censInformation): No censoring
#> 
#> ── Fit Data (object is a modified tibble): ──
#> # A tibble: 483 × 44
#>   ID     TIME CMT      DV EPRED  ERES  NPDE    NPD    PDE     PD  PRED   RES
#>   <fct> <dbl> <fct> <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>
#> 1 1       0.5 cp      0    1.76 -1.76 -1.79 -1.50  0.0367 0.0667  1.38 -1.38
#> 2 1       1   cp      1.9  4.06 -2.16  1.75 -0.954 0.96   0.17    3.87 -1.97
#> 3 1       2   cp      3.3  7.93 -4.63 -1.99 -1.71  0.0233 0.0433  8.18 -4.88
#> # ℹ 480 more rows
#> # ℹ 32 more variables: WRES <dbl>, IPRED <dbl>, IRES <dbl>, IWRES <dbl>,
#> #   CPRED <dbl>, CRES <dbl>, CWRES <dbl>, eta.ktr <dbl>, eta.ka <dbl>,
#> #   eta.cl <dbl>, eta.v <dbl>, eta.emax <dbl>, eta.ec50 <dbl>, eta.kout <dbl>,
#> #   eta.e0 <dbl>, depot <dbl>, gut <dbl>, center <dbl>, effect <dbl>,
#> #   ktr <dbl>, ka <dbl>, cl <dbl>, v <dbl>, emax <dbl>, ec50 <dbl>, kout <dbl>,
#> #   e0 <dbl>, DCP <dbl>, PD.1 <dbl>, kin <dbl>, tad <dbl>, dosenum <dbl>
```

#### SAEM Diagnostic plots

``` r
plot(fit.TOS)
```

![](multiple-endpoints_files/figure-html/unnamed-chunk-12-1.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-2.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-3.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-4.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-5.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-6.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-7.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-8.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-9.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-10.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-11.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-12.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-13.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-14.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-15.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-16.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-17.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-18.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-19.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-20.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-21.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-22.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-23.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-24.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-25.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-26.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-27.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-28.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-29.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-30.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-31.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-32.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-33.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-34.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-35.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-36.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-37.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-38.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-39.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-40.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-41.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-42.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-43.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-44.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-45.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-46.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-47.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-48.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-49.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-50.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-51.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-52.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-53.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-54.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-55.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-56.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-57.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-58.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-59.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-60.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-61.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-62.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-63.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-64.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-65.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-66.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-67.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-68.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-69.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-70.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-71.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-72.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-73.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-74.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-75.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-76.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-77.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-78.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-79.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-80.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-81.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-82.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-83.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-84.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-85.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-86.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-87.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-88.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-89.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-90.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-91.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-92.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-93.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-94.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-95.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-96.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-97.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-98.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-99.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-100.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-101.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-102.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-103.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-104.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-105.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-106.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-107.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-108.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-109.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-110.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-111.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-112.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-113.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-114.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-115.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-116.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-117.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-118.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-119.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-120.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-121.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-122.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-123.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-124.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-125.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-126.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-127.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-128.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-129.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-130.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-131.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-132.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-133.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-134.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-135.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-136.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-12-137.png)

``` r


v1s <- vpcPlot(fit.TOS, show=list(obs_dv=TRUE), scales="free_y") +
  ylab("Warfarin Cp [mg/L] or PCA") +
  xlab("Time [h]")

v2s <- vpcPlot(fit.TOS, show=list(obs_dv=TRUE), pred_corr = TRUE) +
  ylab("Prediction Corrected Warfarin Cp [mg/L] or PCA") +
  xlab("Time [h]")

v1s
```

![](multiple-endpoints_files/figure-html/unnamed-chunk-12-138.png)

``` r
v2s
```

![](multiple-endpoints_files/figure-html/unnamed-chunk-12-139.png)

### FOCEi fits

``` r
## FOCEi fit/vpcs
fit.TOF <- nlmixr(pk.turnover.emax3, warfarin, "focei", control=list(print=0),
                  table=list(cwres=TRUE, npde=TRUE))
#> calculating covariance matrix
#> [====|====|====|====|====|====|====|====|====|====] 0:01:22 
#> done
```

#### FOCEi Diagnostic Plots

``` r
print(fit.TOF)
#> ── nlmixr² FOCEi (outer: nlminb) ──
#> 
#>           OBJF      AIC      BIC Log-likelihood Condition#(Cov) Condition#(Cor)
#> FOCEi 1409.421 2335.116 2414.536      -1148.558        32318.05        93.02754
#> 
#> ── Time (sec $time): ──
#> 
#>            setup optimize covariance table    other
#> elapsed 0.002505 82.15361   82.15361 1.788 40.01228
#> 
#> ── Population Parameters ($parFixed or $parFixedDf): ──
#> 
#>            Est.     SE     %RSE Back-transformed(95%CI) BSV(CV% or SD)
#> tktr      0.104    2.2 2.11e+03      1.11 (0.015, 82.2)           101.
#> tka       0.302   2.18      723       1.35 (0.0188, 97)           120.
#> tcl       -2.04  0.109     5.36     0.13 (0.105, 0.162)           27.3
#> tv         2.06 0.0916     4.44       7.87 (6.57, 9.42)           22.4
#> prop.err  0.148                                   0.148               
#> pkadd.err 0.172                                   0.172               
#> temax      4.75    6.2      130     0.991 (0.000614, 1)          0.590
#> tec50     0.157  0.229      146      1.17 (0.747, 1.83)           47.7
#> tkout     -2.93  0.128     4.36 0.0534 (0.0416, 0.0686)           15.4
#> te0        4.57 0.0399    0.874          96.3 (89, 104)           10.3
#> pdadd.err  3.76                                    3.76               
#>           Shrink(SD)%
#> tktr           62.3% 
#> tka            60.6% 
#> tcl         -0.0757% 
#> tv             10.3% 
#> prop.err             
#> pkadd.err            
#> temax          95.1% 
#> tec50          5.19% 
#> tkout          32.3% 
#> te0            39.6% 
#> pdadd.err            
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
#> # A tibble: 483 × 44
#>   ID     TIME CMT      DV EPRED  ERES  NPDE    NPD    PDE    PD  PRED   RES
#>   <fct> <dbl> <fct> <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl> <dbl> <dbl> <dbl>
#> 1 1       0.5 cp      0    2.22 -2.22 -1.48 -2.33  0.07   0.01   1.59 -1.59
#> 2 1       1   cp      1.9  4.67 -2.77  1.88 -0.795 0.97   0.213  4.36 -2.46
#> 3 1       2   cp      3.3  7.92 -4.62 -2.13 -1.19  0.0167 0.117  8.76 -5.46
#> # ℹ 480 more rows
#> # ℹ 32 more variables: WRES <dbl>, IPRED <dbl>, IRES <dbl>, IWRES <dbl>,
#> #   CPRED <dbl>, CRES <dbl>, CWRES <dbl>, eta.ktr <dbl>, eta.ka <dbl>,
#> #   eta.cl <dbl>, eta.v <dbl>, eta.emax <dbl>, eta.ec50 <dbl>, eta.kout <dbl>,
#> #   eta.e0 <dbl>, depot <dbl>, gut <dbl>, center <dbl>, effect <dbl>,
#> #   ktr <dbl>, ka <dbl>, cl <dbl>, v <dbl>, emax <dbl>, ec50 <dbl>, kout <dbl>,
#> #   e0 <dbl>, DCP <dbl>, PD.1 <dbl>, kin <dbl>, tad <dbl>, dosenum <dbl>
plot(fit.TOF)
```

![](multiple-endpoints_files/figure-html/unnamed-chunk-14-1.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-2.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-3.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-4.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-5.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-6.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-7.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-8.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-9.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-10.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-11.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-12.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-13.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-14.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-15.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-16.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-17.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-18.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-19.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-20.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-21.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-22.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-23.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-24.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-25.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-26.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-27.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-28.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-29.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-30.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-31.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-32.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-33.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-34.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-35.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-36.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-37.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-38.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-39.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-40.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-41.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-42.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-43.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-44.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-45.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-46.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-47.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-48.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-49.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-50.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-51.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-52.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-53.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-54.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-55.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-56.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-57.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-58.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-59.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-60.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-61.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-62.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-63.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-64.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-65.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-66.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-67.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-68.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-69.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-70.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-71.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-72.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-73.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-74.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-75.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-76.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-77.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-78.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-79.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-80.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-81.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-82.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-83.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-84.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-85.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-86.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-87.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-88.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-89.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-90.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-91.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-92.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-93.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-94.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-95.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-96.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-97.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-98.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-99.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-100.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-101.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-102.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-103.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-104.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-105.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-106.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-107.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-108.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-109.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-110.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-111.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-112.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-113.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-114.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-115.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-116.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-117.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-118.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-119.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-120.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-121.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-122.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-123.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-124.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-125.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-126.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-127.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-128.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-129.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-130.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-131.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-132.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-133.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-134.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-135.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-136.png)![](multiple-endpoints_files/figure-html/unnamed-chunk-14-137.png)

``` r

v1f <- vpcPlot(fit.TOF, show=list(obs_dv=TRUE), scales="free_y") +
  ylab("Warfarin Cp [mg/L] or PCA") +
  xlab("Time [h]")

v2f <- vpcPlot(fit.TOF, show=list(obs_dv=TRUE), pred_corr = TRUE) +
  ylab("Prediction Corrected Warfarin Cp [mg/L] or PCA") +
  xlab("Time [h]")

v1f
```

![](multiple-endpoints_files/figure-html/unnamed-chunk-14-138.png)

``` r
v2f
```

![](multiple-endpoints_files/figure-html/unnamed-chunk-14-139.png)
