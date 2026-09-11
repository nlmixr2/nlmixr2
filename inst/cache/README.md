# Vignette fit cache

These `.zip` and `.rds` files are pre-computed nlmixr2 fits and simulations used
by the pkgdown articles. The articles locate them with
`system.file("cache", package = "nlmixr2")`.

This directory is listed in `.Rbuildignore` (`^inst/cache$`), so it is **excluded
from normal `R CMD build` / check / CRAN tarballs**. The pkgdown GitHub workflow
removes that `.Rbuildignore` line before it builds the package, so the cache is
present for `system.file()` during the website build.

The `vignettes/` directory is also `.Rbuildignore`d, so those articles build only
for the website (pkgdown), never during `R CMD check` / CRAN. Estimation (SAEM /
FOCEi on the larger models) dominated the build and was timing the pkgdown
runner out, so the fits are computed once, committed here, and loaded at build
time instead of being re-estimated.

- Each article caches its fits with the `:=` operator from the `nlmixr2save`
  package: a fit becomes a portable `.zip`, a simulation becomes an `.rds`, and
  each file is namespaced by the article's `nlmixr2save.prefix`.
- `vignettes/precompute.R` (re)populates this directory by rendering the
  articles with `pkgload::load_all()` (so `system.file()` points back here):

  ```sh
  cd vignettes && Rscript precompute.R          # fit only what is missing
  cd vignettes && Rscript precompute.R --clean   # refit everything
  ```

Refresh the cache when a cached model, its data, or a package that changes the
fit is updated.
