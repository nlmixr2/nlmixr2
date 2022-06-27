# nlmixr2 2.0.7

* nlmixr2 now re-exports `logit` so that certain models will work with
  a simple `library(nlmixr2)` instead of
  `library(rxode2);library(nlmixr2)`

* `vpcSim()` now exports the new `nretry` option for more robust
  control of `vpcSim()`

* Update documentation to mention the package names that work with
  nlmixr2, like `xpose.nlmixr2` instead of `xpose.nlmixr`

* Added `n1qn1` as a suggested package to try to fix the following
  issue on the CRAN:

```
Version: 2.0.6
Check: Rd cross-references
Result: NOTE
    Undeclared package ‘n1qn1’ in Rd xrefs
Flavor: r-devel-linux-x86_64-fedora-clang
```

* Manual hard re-export of `nlmixr2est::nlmixr2` to allow `pkgdown` to
  document this function.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
