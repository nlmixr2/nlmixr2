# xgxr and ggPMX integration with nlmixr2

This shows an example of integrated workflow between `xgxr` `nlmixr` and
`ggPmx`

``` r
library(rxode2)
library(nlmixr2)
library(xgxr)
library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggPMX)
library(broom)
library(broom.mixed)
```

## Load the data

``` r
pkpd_data <-
  case1_pkpd %>%
  arrange(DOSE) %>%
  select(-IPRED) %>%
  mutate(TRTACT_low2high = factor(TRTACT, levels = unique(TRTACT)),
         TRTACT_high2low = factor(TRTACT, levels = rev(unique(TRTACT))),
         DAY_label = paste("Day", PROFDAY),
         DAY_label = ifelse(DAY_label == "Day 0","Baseline",DAY_label))
 
pk_data <- pkpd_data %>%
  filter(CMT == 2)

pk_data_cycle1 <- pk_data %>%
  filter(CYCLE == 1)
```

## Exploratory analysis using ggplot and xgx helper functions

### Use xgxr for simplified concentration over time, colored by Dose, mean +/- 95% CI

Often in exploring data it is worthwhile to plot by dose by each nominal
time and add the 95% confidence interval. This typical plot can be
cumbersome and lack some nice features that `xgxr` can help with. Note
the following helper functions:

- [`xgx_theme_set()`](https://rdrr.io/pkg/xgxr/man/xgx_theme_set.html)
  this sets the theme to black and white color theme and other best
  practices in `xgxr`.

- [`xgx_geom_ci()`](https://rdrr.io/pkg/xgxr/man/xgx_geom_ci.html) which
  creates the Confidence Interval and mean plots in a simple interface.

- [`xgx_scale_y_log10()`](https://rdrr.io/pkg/xgxr/man/xgx_scale_y_log10.html)
  which creates a log-scale that includes the minor grids that
  immediately show the viewer that the plot is a semi-log plot without
  carefully examining the y axis.

- [`xgx_scale_x_time_units()`](https://rdrr.io/pkg/xgxr/man/xgx_scale_x_time_units.html)
  which creates an appropriate scale based on your times observed and
  the units you use. It also allows you to convert units easily for the
  right display.

- `xgx_annote_status()` which adds a `DRAFT` annotation which is often
  considered best practice when the data or plots are draft.

``` r
xgx_theme_set() # This uses black and white theme based on xgxr best
                # practices

# flag for labeling figures as draft
status <- "DRAFT"

time_units_dataset <- "hours"
time_units_plot    <- "days"
trtact_label       <- "Dose"
dose_label         <- "Dose (mg)"
conc_label         <- "Concentration (ng/ml)" 
auc_label          <- "AUCtau (h.(ng/ml))"
concnorm_label     <- "Normalized Concentration (ng/ml)/mg"
sex_label          <- "Sex"
w100_label         <- "WEIGHTB>100"
pd_label           <- "FEV1 (mL)"
cens_label         <- "Censored"


ggplot(data = pk_data_cycle1, aes(x     = NOMTIME,
                                  y     = LIDV,
                                  group = DOSE,
                                  color = TRTACT_high2low)) +
    xgx_geom_ci(conf_level = 0.95) + # Easy CI with xgxr
    xgx_scale_y_log10() + # semi-log plots with semi-log grid minor lines
    xgx_scale_x_time_units(units_dataset = time_units_dataset,
                           units_plot = time_units_plot) +
    # The last line creates an appropriate x scale based on time-units
    # and time unit scale
    labs(y = conc_label, color = trtact_label) +
    xgx_annotate_status(status) #  Adds draft status to plot
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-simple-conc-time-1.png)

With this plot you see the mean concentrations confidence intervals
stratified by dose

### Concentration over time, faceted by Dose, mean +/- 95% CI, overlaid on gray spaghetti plots

Not only is it useful to look at the mean concentrations, it is often
useful to look at the mean concentrations and their relationship between
actual individual profiles. Using `ggplot` coupled with the `xgxr`
helper functions used above, we can easily create these plots as well:

``` r
ggplot(data = pk_data_cycle1, aes(x = TIME, y = LIDV)) +
  geom_line(aes(group = ID), color = "grey50", linewidth = 1, alpha = 0.3) +
  geom_cens(aes(cens=CENS)) + 
  xgx_geom_ci(aes(x = NOMTIME, color = NULL, group = NULL, shape = NULL), conf_level = 0.95) +
  xgx_scale_y_log10() +
  xgx_scale_x_time_units(units_dataset = time_units_dataset, units_plot = time_units_plot) +
  labs(y = conc_label, color = trtact_label) +
  theme(legend.position = "none") +
  facet_grid(.~TRTACT_low2high) +
  xgx_annotate_status(status)
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-conc-time-facet-dose-1.png)

To me it appears the variability seems to be higher with higher doses
and higher with later times.

### Exploring the dose linearity

A common way to explore the dose linearity is to normalize by the dose.
If the confidence intervals overlap, often this is a dose linear
example.

``` r
ggplot(data = pk_data_cycle1,
       aes(x = NOMTIME,
           y = LIDV / as.numeric(as.character(DOSE)),
           group = DOSE,
           color = TRTACT_high2low)) +
  xgx_geom_ci(conf_level = 0.95, alpha = 0.5, position = position_dodge(1)) +
  xgx_scale_y_log10() +
  xgx_scale_x_time_units(units_dataset = time_units_dataset, units_plot = time_units_plot) +
  labs(y = concnorm_label, color = trtact_label) +
  xgx_annotate_status(status)
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-dose-linearity-1.png)

This example seems to be dose-linear, with the exception of the censored
data. This can be made even more clear by removing the censored data for
this plot:

``` r
ggplot(data = pk_data_cycle1 %>% filter(CENS == 0),
       aes(x = NOMTIME,
           y = LIDV / as.numeric(as.character(DOSE)),
           group = DOSE,
           color = TRTACT_high2low)) +
  xgx_geom_ci(conf_level = 0.95, alpha = 0.5, position = position_dodge(1)) +
  xgx_scale_y_log10() +
  xgx_scale_x_time_units(units_dataset = time_units_dataset, units_plot = time_units_plot) +
  labs(y = concnorm_label, color = trtact_label) +
  xgx_annotate_status(status)
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-dose-linearity-censored-1.png)

The lowest dose, with the most censoring, is the one that seems to be
the outlier. That is likely an artifact of censoring.

Other ways to explore the data include by looking at normalized Cmax and
AUC values (which we will skip in this vignette).

## Exploring Covariates in the dataset

Using the `xgx` helper functions to `ggplot` you can explore the effect
of high baseline weight. This particular plot is shown below:

``` r
ggplot(data = pk_data_cycle1, aes(x = NOMTIME,
                                  y = LIDV,
                                  group = WEIGHTB > 100,
                                  color = WEIGHTB > 100)) + 
    xgx_geom_ci(conf_level = 0.95) +
    xgx_scale_y_log10() +
    xgx_scale_x_time_units(units_dataset = time_units_dataset, units_plot = time_units_plot) +
    facet_grid(.~DOSE) +
    labs(y = conc_label, color = w100_label) +
    xgx_annotate_status(status)
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-covariates-1.png)

It seems that the weight effect is not extreme for either dose group

### Summary of exploratory analysis findings

From the exploratory analysis we see: - The doses seem proportional -
The PK seems to have a 2-compartment model - Censoring has a large
effect on the PK data.

## Fitting the data with nlmixr

First we need to subset to the PK only data and rename `LIDV` to `DV`

``` r
dat <-
  case1_pkpd %>%
  rename(DV=LIDV) %>%
  filter(CMT %in% 1:2) %>%
  filter(TRTACT != "Placebo")
```

Next, for the purpose of this demonstration we will subset to 7 patients
per dose group):

``` r
doses <- unique(dat$DOSE)
nid <- 20 # 7 ids per dose group
dat2 <-
  dat %>%
  group_by(DOSE) %>%
  filter(ID %in% sort(unique(ID))[1:nid]) %>%
  ungroup()
```

This approach is not only good for demonstration, but allows a variety
of structural models to be applied more quickly while developing a base
model. The full dataset can then be applied to the selected model to
make sure it makes sense with all the data.

Next create a 2 compartment model:

``` r
## Use 2 compartment model
cmt2 <- function() {
  ini({
    lka <- log(0.1); label("Ka")
    lv <- log(10); label("Vc")
    lcl <- log(4); label("Cl")
    lq <- log(10); label("Q")
    lvp <- log(20); label("Vp")

    eta.ka ~ 0.01
    eta.v ~ 0.1
    eta.cl ~ 0.1
    logn.sd = 10
  })
  model({
    ka <- exp(lka + eta.ka)
    cl <- exp(lcl + eta.cl)
    v <- exp(lv + eta.v)
    q <- exp(lq)
    vp <- exp(lvp)
    linCmt() ~ lnorm(logn.sd)
  })
}

## Check parsing
cmt2m <- nlmixr(cmt2)
print(cmt2m)
#>  ── rxode2-based solved PK 2-compartment model ────────────────────────────────── 
#>  ── Initalization: ──  
#> Fixed Effects ($theta): 
#>       lka        lv       lcl        lq       lvp   logn.sd 
#> -2.302585  2.302585  1.386294  2.302585  2.995732 10.000000 
#> 
#> Omega ($omega): 
#>        eta.ka eta.v eta.cl
#> eta.ka   0.01   0.0    0.0
#> eta.v    0.00   0.1    0.0
#> eta.cl   0.00   0.0    0.1
#> 
#> States ($state or $stateDf): 
#>   Compartment Number Compartment Name Rate   Off Internal #
#> 1                  1            depot TRUE FALSE          1
#> 2                  2          central TRUE FALSE          2
#>  ── μ-referencing ($muRefTable): ──  
#>   theta    eta level
#> 1   lka eta.ka    id
#> 2   lcl eta.cl    id
#> 3    lv  eta.v    id
#> 
#>  ── Model (Normalized Syntax): ── 
#> function() {
#>     ini({
#>         lka <- -2.30258509299405
#>         label("Ka")
#>         lv <- 2.30258509299405
#>         label("Vc")
#>         lcl <- 1.38629436111989
#>         label("Cl")
#>         lq <- 2.30258509299405
#>         label("Q")
#>         lvp <- 2.99573227355399
#>         label("Vp")
#>         logn.sd <- c(0, 10)
#>         eta.ka ~ 0.01
#>         eta.v ~ 0.1
#>         eta.cl ~ 0.1
#>     })
#>     model({
#>         ka <- exp(lka + eta.ka)
#>         cl <- exp(lcl + eta.cl)
#>         v <- exp(lv + eta.v)
#>         q <- exp(lq)
#>         vp <- exp(lvp)
#>         linCmt() ~ lnorm(logn.sd)
#>     })
#> }
```

Now that the parsing of the nlmixr model is complete start and compare a
few models:

``` r
## First try log-normal (since the variability seemed proportional to concentration)
cmt2fit.logn <-
  nlmixr(
    cmt2m, data = dat2,
    est = "saem",
    control=list(print=0), 
    table=tableControl(cwres=TRUE, npde=TRUE)
  )
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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:03
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

## Now try proportional
cmt2fit.prop <-
  cmt2fit.logn %>%
  update(linCmt() ~ prop(prop.sd)) %>%
  nlmixr(
    est="saem", control=list(print=0),
    table=tableControl(npde=TRUE, cwres=TRUE)
  )
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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:03
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

## now try add+prop
cmt2fit.add.prop <-
  cmt2fit.prop %>%
  update(linCmt() ~ prop(prop.sd) + add(add.sd)) %>%
  nlmixr(
    est="saem", control=list(print=0), 
    table=tableControl(npde=TRUE, cwres=TRUE)
  )
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
#> [====|====|====|====|====|====|====|====|====|====] 0:00:03
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
```

Now that we have run 3 different estimation methods, we can compare the
results side-by-side

``` r
library(huxtable)

huxreg(
  "lognormal"=cmt2fit.logn,
  "proportional"=cmt2fit.prop,
  "add+prop"=cmt2fit.add.prop,
  statistics=c(N="nobs", "logLik", "AIC"),
  stars = NULL
)
```

|              | lognormal | proportional |    add+prop |
|--------------|----------:|-------------:|------------:|
| lka          |   -2.285  |      -2.391  |     -2.445  |
|              |   (0.085) |      (0.058) |     (0.065) |
| lv           |    2.164  |      -8.180  |     -8.290  |
|              |   (0.139) |      (0.426) |     (0.452) |
| lcl          |    1.847  |     -16.869  |    -15.636  |
|              |   (0.075) |      (1.865) |     (1.778) |
| lq           |    2.172  |       2.148  |      2.200  |
|              |   (0.294) |    (295.204) |   (441.230) |
| lvp          |    3.044  |      -9.138  |     -9.130  |
|              |   (0.243) |      (0.113) |     (0.142) |
| sd\_\_eta.ka |    0.107  |       0.330  |      0.378  |
|              | (NA)      |    (NA)      |   (NA)      |
| sd\_\_eta.v  |    0.340  |       3.477  |      3.526  |
|              | (NA)      |    (NA)      |   (NA)      |
| sd\_\_eta.cl |    0.710  |      11.391  |     12.172  |
|              | (NA)      |    (NA)      |   (NA)      |
| logn.sd      |    1.045  |              |             |
|              | (NA)      |              |             |
| prop.sd      |           |       0.957  |      0.973  |
|              |           |    (NA)      |   (NA)      |
| add.sd       |           |              |      0.075  |
|              |           |              |   (NA)      |
| N            | 2600      |    2600      |   2600      |
| logLik       | -223.596  |  -17116.552  | -17030.792  |
| AIC          |  465.193  |   34251.105  |  34081.584  |

Note that the additive and proportional model has the additive component
approach zero. When comparing the objective functions of log-normal and
proportional models, the proportional model has the lowest objective
function value. (Since we modeled log-normal without data transformation
it is appropriate to compare the AIC/Objective function values)

## Model Diagnostics with ggPMX

``` r
## The controller then can be piped into a specific plot
ctr <- pmx_nlmixr(cmt2fit.logn, conts = "WEIGHTB", cats="TRTACT", vpc=TRUE)
#> [====|====|====|====|====|====|====|====|====|====] 0:00:03
```

``` r
ctr %>% pmx_plot_npde_pred()
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-npde-pred-1.png)

``` r
## Modify graphical options and remove DRAFT label:
ctr %>%
  pmx_plot_npde_time(
    smooth = list(color="blue"), point = list(shape=4), is.draft=FALSE, 
    labels = list(x = "Time after first dose (days)", y = "Normalized PDE")
  )
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-npde-pred-nodraft-1.png)

``` r
ctr %>% pmx_plot_dv_ipred(scale_x_log10=TRUE, scale_y_log10=TRUE, filter=IPRED>0.001)
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-dv-ipred-1.png)

``` r
ctr %>% pmx_plot_dv_pred(scale_x_log10=TRUE, scale_y_log10=TRUE, filter=IPRED>0.001)
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-dv-pred-1.png)

``` r
ctr %>% pmx_plot_abs_iwres_ipred()
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-iwres-ipred-1.png)

``` r
ctr %>%
  pmx_plot_individual(
    1,
    filter= TIME > 0 & TIME < 48,
    facets = list(nrow = 2, ncol = 2)
  )
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-individual-1.png)

``` r
ctr %>% pmx_plot_iwres_dens()
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-iwres-dens-1.png)

``` r
ctr %>% pmx_plot_eta_qq()
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-eta-qq-1.png)

This creates two reports with default settings, both a
[pdf](https://github.com/nlmixr2/nlmixr2/raw/master/vignettes/nlmixr_report.pdf)
and
[word](https://github.com/nlmixr2/nlmixr2/raw/master/vignettes/nlmixr_report.docx)
document. The report can be customized by editing the default template
to include project specificities (change labels, stratifications,
filtering, etc.).

``` r
ctr %>% pmx_plot_eta_box()
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-eta-box-1.png)

``` r
ctr %>% pmx_plot_eta_hist()
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fit-eta-hist-1.png)

``` r
ctr %>% pmx_plot_eta_matrix()
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-eta-matrix-1.png)

This creates two reports with default settings, both a
[pdf](https://github.com/nlmixr2/nlmixr2/raw/master/vignettes/nlmixr_report.pdf)
and
[word](https://github.com/nlmixr2/nlmixr2/raw/master/vignettes/nlmixr_report.docx)
document. The report can be customized by editing the default template
to include project specifics (change labels, stratification, filtering,
etc.).

## Simulation of a new scenario with `rxode2`

By creating events you can simply simulate a new scenario. Perhaps your
drug development team wants to explore the 100 mg dose 3 times a day
dosing to see what happens with the PK. You can simply simulate from the
nlmixr model using a [new event
table](https://nlmixr2.github.io/rxode2/articles/rxode2-event-table.html)
created from
[`rxode2()`](https://nlmixr2.github.io/rxode2/reference/rxode2.html).

In this case we wish to simulate with some variability and see what
happens at steady state:

``` r
# Start a new simulation
ev <- et(amt=100, ii=8, ss=1)
```

``` r
ev$add.sampling(seq(0, 8, length.out=50))
print(ev)
#> ── EventTable with 51 records ──
#> 1 dosing records (see $get.dosing(); add with add.dosing or et)
#> 50 observation times (see $get.sampling(); add with add.sampling or et)
#> ── First part of : ──
#> # A tibble: 51 × 5
#>     time   amt    ii evid             ss
#>    <dbl> <dbl> <dbl> <evid>        <int>
#>  1 0        NA    NA 0:Observation    NA
#>  2 0       100     8 1:Dose (Add)      1
#>  3 0.163    NA    NA 0:Observation    NA
#>  4 0.327    NA    NA 0:Observation    NA
#>  5 0.490    NA    NA 0:Observation    NA
#>  6 0.653    NA    NA 0:Observation    NA
#>  7 0.816    NA    NA 0:Observation    NA
#>  8 0.980    NA    NA 0:Observation    NA
#>  9 1.14     NA    NA 0:Observation    NA
#> 10 1.31     NA    NA 0:Observation    NA
#> # ℹ 41 more rows
```

An nlmixr model already includes information about the parameter
estimates and can simulate without uncertainty in the population
parameters or covariances, like what is done for a VPC.

If you wish to simulate `100` patients repeated by `100` different
theoretical studies where you simulate from the uncertainty in the fixed
parameter estimates and covariances you can very easily with
nlmixr2/rxode2:

``` r
set.seed(100)
sim1 <- rxSolve(cmt2fit.logn, ev, nSub=100, nStud=100)
#> [====|====|====|====|====|====|====|====|====|====
print(sim1)
#> ── Solved rxode2 object ──
#> ── Parameters ($params): ──
#> # A tibble: 10,000 × 10
#>    sim.id   lka    lv   lcl    lq   lvp logn.sd  eta.ka   eta.v   eta.cl
#>     <int> <dbl> <dbl> <dbl> <dbl> <dbl>   <dbl>   <dbl>   <dbl>    <dbl>
#>  1      1 -2.26  2.25  1.90  2.10  3.11    1.04  0.0114 -0.0174 -0.752  
#>  2      2 -2.26  2.25  1.90  2.10  3.11    1.04  0.193  -0.167  -0.716  
#>  3      3 -2.26  2.25  1.90  2.10  3.11    1.04  0.155   0.377  -0.00240
#>  4      4 -2.26  2.25  1.90  2.10  3.11    1.04 -0.0459  0.0259  0.373  
#>  5      5 -2.26  2.25  1.90  2.10  3.11    1.04  0.250  -0.416  -0.0179 
#>  6      6 -2.26  2.25  1.90  2.10  3.11    1.04  0.164   0.216  -0.328  
#>  7      7 -2.26  2.25  1.90  2.10  3.11    1.04 -0.0476 -0.109  -0.936  
#>  8      8 -2.26  2.25  1.90  2.10  3.11    1.04 -0.0652 -0.911  -0.228  
#>  9      9 -2.26  2.25  1.90  2.10  3.11    1.04 -0.0116  0.335   0.281  
#> 10     10 -2.26  2.25  1.90  2.10  3.11    1.04  0.167  -0.195  -0.0404 
#> # ℹ 9,990 more rows
#> ── Initial Conditions ($inits): ──
#>       depot     central peripheral1 
#>           0           0           0 
#> 
#> Simulation with uncertainty in:
#> • parameters ($thetaMat for changes)
#> • omega matrix ($omegaList)
#> • sigma matrix ($sigmaList)
#> 
#> ── First part of data (object): ──
#> # A tibble: 500,000 × 12
#>   sim.id  time    ka    cl     v     q    vp ipredSim   sim depot central
#>    <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>    <dbl> <dbl> <dbl>   <dbl>
#> 1      1 0     0.106  3.14  9.36  8.21  22.4     3.60  5.49  175.    33.8
#> 2      1 0.163 0.106  3.14  9.36  8.21  22.4     3.75  1.77  172.    35.1
#> 3      1 0.327 0.106  3.14  9.36  8.21  22.4     3.86 12.5   169.    36.2
#> 4      1 0.490 0.106  3.14  9.36  8.21  22.4     3.95 32.7   166.    37.0
#> 5      1 0.653 0.106  3.14  9.36  8.21  22.4     4.02  1.13  163.    37.6
#> 6      1 0.816 0.106  3.14  9.36  8.21  22.4     4.07  2.21  160.    38.1
#> # ℹ 499,994 more rows
#> # ℹ 1 more variable: peripheral1 <dbl>
```

You may examine the simulated study information easily, as show in the
[`rxode2()`](https://nlmixr2.github.io/rxode2/reference/rxode2.html)
printout:

``` r
head(sim1$thetaMat)
#>              lka           lv         lcl          lq         lvp
#> [1,]  0.02947905  0.089896667  0.04984078 -0.06706706  0.06520861
#> [2,]  0.06197460 -0.170342222 -0.05373612  0.68716441  0.09226292
#> [3,] -0.06697635 -0.217177252 -0.10981408 -0.20229225 -0.14341128
#> [4,] -0.06332902 -0.184020593  0.16697188  0.30978833 -0.03255698
#> [5,] -0.17713830 -0.148149267  0.07439355 -0.69996458 -0.51233627
#> [6,] -0.05815461  0.008916266 -0.05256217 -0.23281914 -0.24435683
```

You can also see the covariance matricies that are simulated (note they
come from an inverse Wishart distribution):

``` r
head(sim1$omegaList)
#> [[1]]
#>              eta.ka        eta.v       eta.cl
#> eta.ka  0.012623191 -0.004464206 -0.003035283
#> eta.v  -0.004464206  0.150338686  0.016213674
#> eta.cl -0.003035283  0.016213674  0.511307406
#> 
#> [[2]]
#>              eta.ka        eta.v       eta.cl
#> eta.ka  0.010590789 -0.002237411 -0.005009739
#> eta.v  -0.002237411  0.134165266  0.023422769
#> eta.cl -0.005009739  0.023422769  0.480798833
#> 
#> [[3]]
#>              eta.ka         eta.v       eta.cl
#> eta.ka 0.0099509533  0.0008136218  0.005543711
#> eta.v  0.0008136218  0.1349640454 -0.056394136
#> eta.cl 0.0055437113 -0.0563941356  0.483792201
#> 
#> [[4]]
#>              eta.ka        eta.v      eta.cl
#> eta.ka 0.0123884759 0.0002081887 0.003492112
#> eta.v  0.0002081887 0.1040441775 0.016897162
#> eta.cl 0.0034921121 0.0168971618 0.440930357
#> 
#> [[5]]
#>              eta.ka       eta.v       eta.cl
#> eta.ka  0.012777103 0.003651706 -0.003321946
#> eta.v   0.003651706 0.140182692  0.009462842
#> eta.cl -0.003321946 0.009462842  0.492853429
#> 
#> [[6]]
#>              eta.ka        eta.v       eta.cl
#> eta.ka  0.012372109 -0.007659249 -0.007657738
#> eta.v  -0.007659249  0.123751802  0.032497415
#> eta.cl -0.007657738  0.032497415  0.496990248
```

``` r
head(sim1$sigmaList)
#> [[1]]
#>                rxerr.rxLinCmt
#> rxerr.rxLinCmt      0.9911237
#> 
#> [[2]]
#>                rxerr.rxLinCmt
#> rxerr.rxLinCmt       1.028955
#> 
#> [[3]]
#>                rxerr.rxLinCmt
#> rxerr.rxLinCmt       1.016967
#> 
#> [[4]]
#>                rxerr.rxLinCmt
#> rxerr.rxLinCmt       1.024366
#> 
#> [[5]]
#>                rxerr.rxLinCmt
#> rxerr.rxLinCmt      0.9737614
#> 
#> [[6]]
#>                rxerr.rxLinCmt
#> rxerr.rxLinCmt       1.025798
```

It is also easy enough to create a plot to see what is going on with the
simulation:

``` r
conf <- confint(sim1, "sim")

p1 <- plot(conf) ## This returns a ggplot2 object

## you can tweak the plot by the standard ggplot commands
p1 +
  xlab("Time (hr)") + 
  ylab("Simulated Concentrations of TID steady state")
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-simulate-1.png)

``` r

# And put the same plot on a semi-log plot
p1 +
  xlab("Time (hr)") + 
  ylab("Simulated Concentrations of TID steady state") +
  xgx_scale_y_log10()
```

![](xgxr-nlmixr-ggpmx_files/figure-html/fig-simulate-2.png)

For more complex simulations with variability you can also [simulate
dosing windows and sampling
windows](https://nlmixr2.github.io/rxode2/articles/rxode2-event-table.html#add-doses-and-samples-within-a-sampling-window)
and use any tool you want to summarize it in the way you wish.
