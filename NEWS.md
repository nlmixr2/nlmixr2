# nlmixr2 7.0.1

* `nlmixr2CheckInstall()` no longer fails when the repositories cannot be
  queried for package updates.  Both an unreachable repository and an
  error from `utils::old.packages()` itself (seen on Windows, where
  `pkgType` is `"both"` and R's internal `.available.both()` can fail with
  "subscript out of bounds" when the source and binary indexes disagree)
  are now reported as "updates could not be checked" instead of stopping
  the check.

* `nlmixr2CheckInstall()` messages are escaped before they are handed to
  `cli`, so paths or command output containing `{` or `}` are shown
  literally rather than being interpreted as `glue` expressions.

# nlmixr2 7.0.0

* Optionally import more packages to support nlmixr2 ecosystem

* Match nlmixr2est

* Do not show the packages that were optionally included in the secondary list of packages, instead show them being imported with an open circle. Required packages are shown with a star.

* Removed duplicated entries from the optional package list so that
  `nlmixr2CheckInstall()` and the startup banner no longer report
  `pmxNODE`, `nlmixr2auto` and `nlmixr2autoinit` twice.

* `nlmixr2` now requires R 4.1.0 or later (the native `|>` pipe is used
  internally); `magrittr` is no longer imported.  The `%>%` pipe was
  never exported by `nlmixr2` itself, so this does not change the
  package's user-visible API.

# nlmixr2 5.0.0

* Import everything with the nlmixr2 5.0 file format

# nlmixr2 4.0.1

* Added `posologyr` to the optional packages

# nlmixr2 4.0

* Change to a `verse` style package.

# nlmixr2 3.0.2

* Change saemControl() and other options to reflect the `nlmixr2est`
  default options

* Update authors to reflect current team.

* Export `rxSetSeed()`

# nlmixr2 3.0.1

* Remove `backwardSearch`, `covarSearchAuto` and `forwardSearch`
  re-exports since they no longer exist in `nlmixr2extra`

* Remove `rxode2parse` suggested dependency

# nlmixr2 3.0.0

* Re-export the new profiling from `nlmixr2extra`

# nlmixr2 2.1.2

* Re-export the population only estimation control methods.

# nlmixr2 2.1.1

* Work with systems (like intel c++) where linCmt() linear
  compartmental models do not have gradients.

# nlmixr2 2.1.0

* Reexports `etExpand()`, `model()<-` and `ini()<-`

# nlmixr2 2.0.9

* The new function `nlmixr2CheckInstall()` helps to check if your installation
  is setup correctly with the required compilers and packages.

* This version adds `crayon` as an imported dependency

# nlmixr2 2.0.8

* This release has a bug fix that captures the model name correctly
  when called directly from `nlmixr::nlmixr2` instead
  `nlmixr2est::nlmixr2`

* This also exports the new vpc functions, ie `vpcTad()` etc

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

# nlmixr2 2.0.6

* nlmixr2 is an umbrella package to include the lower level packages
  `rxode2`, `nlmixr2est`, `nlmixr2extra`, and `nlmixr2plot`

* Added a `NEWS.md` file to track changes to the package.
