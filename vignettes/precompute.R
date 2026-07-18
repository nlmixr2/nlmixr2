#!/usr/bin/env Rscript
## Populate vignettes/cache/ with the expensive nlmixr2 fits used by the
## pkgdown articles, so the website build (pkgdown) stays fast and does not
## time out. Run this from the vignettes/ directory whenever a cached model or
## its data changes:
##
##   cd vignettes && Rscript precompute.R           # fit only what is missing
##   cd vignettes && Rscript precompute.R --clean    # refit everything
##
## It renders each article to a throwaway location; the nlmixr2save `:=` calls
## inside the vignettes do the actual fitting and save the fits/simulations into
## cache/ (see the "Contributing a long-running example" article). Because
## rendering runs the real vignette code there is a single source of truth (the
## .Rmd) and no risk of the cache drifting from it.
##
## Each vignette is rendered in its OWN fresh R subprocess: building many
## rxode2 models in one long-lived session accumulates loaded model DLLs and
## eventually fails with "error building model", so isolating each render keeps
## the precompute reliable.

if (!requireNamespace("rmarkdown", quietly = TRUE)) {
  stop("precompute.R needs the 'rmarkdown' package")
}

rscript <- file.path(R.home("bin"), "Rscript")

## Articles whose fits we cache. Add a vignette here once its estimation calls
## use the nlmixr2save `:=` operator.
vignettes <- c(
  "addingCovariances.Rmd",
  "broom.Rmd",
  "delays.Rmd",
  "mavoglurant.Rmd",
  "modelPiping.Rmd",
  "multiple-endpoints.Rmd",
  "nimo.Rmd",
  "wbc.Rmd",
  "xgxr-nlmixr-ggpmx.Rmd"
)

args <- commandArgs(trailingOnly = TRUE)
if ("--clean" %in% args) {
  ## Clear every cached fit/simulation so the next render refits.  The articles
  ## cache with nlmixr2save's `:=` operator under cache/ ; nlmixr2saveInvalidate()
  ## clears the entries for the active prefix, so clear all article prefixes.
  if (requireNamespace("nlmixr2save", quietly = TRUE)) {
    unlink(list.files("cache", full.names = TRUE))
  } else {
    unlink(list.files("cache", pattern = "\\.(rds|zip)$", full.names = TRUE))
  }
  message("precompute.R: cleared cache/")
}

outDir <- tempfile("nlmixr2-precompute-")
dir.create(outDir)

failed <- character(0)
for (v in vignettes) {
  if (!file.exists(v)) {
    warning("precompute.R: skipping missing vignette ", v)
    next
  }
  message("precompute.R: rendering ", v, " to populate the cache ...")
  cmd <- sprintf(
    'rmarkdown::render("%s", output_dir="%s", quiet=TRUE, envir=new.env(parent=globalenv()))',
    v, outDir)
  status <- system2(rscript, c("-e", shQuote(cmd)))
  if (!identical(status, 0L)) {
    message("precompute.R: FAILED on ", v, " (exit ", status, ")")
    failed <- c(failed, v)
  }
}

message("precompute.R: done. Cached fits:")
print(list.files("cache", pattern = "\\.(zip|rds)$"))
if (length(failed)) {
  message("precompute.R: vignettes that did NOT render cleanly: ",
          paste(failed, collapse = ", "))
}
