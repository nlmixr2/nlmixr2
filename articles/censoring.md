# Censoring in nlmixr

``` r

library(nlmixr2)
#> ── Attaching packages ───────────────────────────────────────── nlmixr2 7.0.1 ──
#> ★ lotri           1.0.5           ◯ nlmixr2auto     1.0.0      
#> ★ nlmixr2data     2.0.10          ◯ nlmixr2autoinit 1.0.1      
#> ★ nlmixr2save     0.2.0           ◯ nlmixr2lib      0.3.2      
#> ★ nlmixr2est      7.1.0           ◯ nlmixr2rpt      0.2.2      
#> ★ nlmixr2extra    5.2.0           ◯ nlmixr2targets  0.1.0      
#> ★ nlmixr2plot     5.1.0.9000      ◯ nonmem2rx       0.1.9      
#> ★ rxode2          5.1.8           ◯ pmxNODE         0.1.0      
#> ◯ admixr2         0.4.1           ◯ PopED           0.7.0      
#> ◯ babelmixr2      0.1.11.9000     ◯ posologyr       1.2.8      
#> ◯ FME             1.3.6.4         ◯ shinyMixR       0.5.3      
#> ◯ ggPMX           1.3.2           ◯ xpose.nlmixr2   0.4.2      
#> ◯ monolix2rx      0.0.6
#> ── Conflicts ───────────────────────────────────────────── nlmixr2conflicts() ──
#> ✖ rxode2::boxCox()     masks nlmixr2est::boxCox()
#> ✖ coda::traceplot()    masks babelmixr2::traceplot(), nlmixr2plot::traceplot()
#> ✖ rxode2::yeoJohnson() masks nlmixr2est::yeoJohnson()
```

## Censoring support in nlmixr

In general, censoring is when there is an observation that cannot be
measured but the researcher knows something about if it is below or
above a certain number. In 2001, Beal introduced censoring to the
pharmacometric community and described common ways to deal with missing
data. The methods below, and the data structure used in nlmixr to
support them are below:

[TABLE]

These data columns `LIMIT` and `CENS`, are based on the Monolix method
of handling of censored data.

## Data output for censored data in nlmixr

For censored data output, it is often useful to see how the predictions
perform in the censored area. To accomplish this, a simulated value is
used to show the prediction and noise. This is then used to calculate
the standard residual values in nlmixr. By default, this value is
simulated from a truncated normal distribution under the model
assumptions and the censoring information specified in the data (though
you can use the CDF method used in the npde package instead if you are
calculating npdes as well). This simulated value replaces the original
DV and then used to calculate all the residuals requested. The original
limit information will be output in `lowerLim` and `upperLim`.
