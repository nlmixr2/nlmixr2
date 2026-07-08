# Vignette fit cache

These `.rds` files are pre-computed nlmixr2 fits used by the pkgdown articles.
The `vignettes/` directory is `.Rbuildignore`d, so these articles build only for
the website (pkgdown), never during `R CMD check` / CRAN. Estimation (SAEM /
FOCEi on the larger models) dominated the build and was timing the pkgdown
runner out, so the fits are computed once, committed here, and loaded at build
time instead of being re-estimated.

- `cacheFit()` in `../cache.R` loads a fit from here if present, otherwise runs
  the fit and saves it (used inside the article `.Rmd` files).
- `../precompute.R` (re)populates this directory by rendering the articles:

  ```sh
  cd vignettes && Rscript precompute.R          # fit only what is missing
  cd vignettes && Rscript precompute.R --clean   # refit everything
  ```

Refresh the cache when a cached model, its data, or a package that changes the
fit is updated.
