# nlmixr2 2.0.7

* nlmixr2 now re-exports `logit` so that certain models will work with
  a simple `library(nlmixr2)` instead of
  `library(rxode2);library(nlmixr2)`

* `vpcSim()` now exports the new `nretry` option for more robust
  control of `vpcSim()`

* Update documentation to mention the package names that work with
  nlmixr2, like `xpose.nlmixr2` instead of `xpose.nlmixr`

* Manual hard re-export of `nlmixr2est::nlmixr2` to allow `pkgdown` to
  document this function.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
