# Changelog

## nlmixr2 5.0.0

CRAN release: 2025-11-30

- Import everything with the nlmixr2 5.0 file format

## nlmixr2 4.0.1

CRAN release: 2025-08-29

- Added `posologyr` to the optional packages

## nlmixr2 4.0

- Change to a `verse` style package.

## nlmixr2 3.0.2

CRAN release: 2025-02-20

- Change saemControl() and other options to reflect the `nlmixr2est`
  default options

- Update authors to reflect current team.

- Export
  [`rxSetSeed()`](https://nlmixr2.github.io/rxode2/reference/rxSetSeed.html)

## nlmixr2 3.0.1

CRAN release: 2024-10-28

- Remove `backwardSearch`, `covarSearchAuto` and `forwardSearch`
  re-exports since they no longer exist in `nlmixr2extra`

- Remove `rxode2parse` suggested dependency

## nlmixr2 3.0.0

CRAN release: 2024-09-18

- Re-export the new profiling from `nlmixr2extra`

## nlmixr2 2.1.2

CRAN release: 2024-05-30

- Re-export the population only estimation control methods.

## nlmixr2 2.1.1

CRAN release: 2024-02-01

- Work with systems (like intel c++) where linCmt() linear compartmental
  models do not have gradients.

## nlmixr2 2.1.0

CRAN release: 2024-01-09

- Reexports
  [`etExpand()`](https://nlmixr2.github.io/rxode2/reference/etExpand.html),
  `model()<-` and `ini()<-`

## nlmixr2 2.0.9

CRAN release: 2023-02-21

- The new function
  [`nlmixr2CheckInstall()`](https://nlmixr2.github.io/nlmixr2/reference/nlmixr2CheckInstall.md)
  helps to check if your installation is setup correctly with the
  required compilers and packages.

- This version adds `crayon` as an imported dependency

## nlmixr2 2.0.8

CRAN release: 2022-10-23

- This release has a bug fix that captures the model name correctly when
  called directly from `nlmixr::nlmixr2` instead
  [`nlmixr2est::nlmixr2`](https://nlmixr2.github.io/nlmixr2est/reference/nlmixr2.html)

- This also exports the new vpc functions, ie `vpcTad()` etc

## nlmixr2 2.0.7

CRAN release: 2022-06-27

- nlmixr2 now re-exports `logit` so that certain models will work with a
  simple [`library(nlmixr2)`](https://nlmixr2.org/) instead of
  [`library(rxode2);library(nlmixr2)`](https://nlmixr2.github.io/rxode2/)

- `vpcSim()` now exports the new `nretry` option for more robust control
  of `vpcSim()`

- Update documentation to mention the package names that work with
  nlmixr2, like `xpose.nlmixr2` instead of `xpose.nlmixr`

- Manual hard re-export of
  [`nlmixr2est::nlmixr2`](https://nlmixr2.github.io/nlmixr2est/reference/nlmixr2.html)
  to allow `pkgdown` to document this function.

## nlmixr2 2.0.6

CRAN release: 2022-05-24

- nlmixr2 is an umbrella package to include the lower level packages
  `rxode2`, `nlmixr2est`, `nlmixr2extra`, and `nlmixr2plot`

- Added a `NEWS.md` file to track changes to the package.
