#!/usr/bin/env Rscript
## Populate inst/cache/ with the expensive nlmixr2 fits used by the pkgdown
## articles, so the website build (pkgdown) stays fast and does not time out.
## Run this from the vignettes/ directory whenever a cached model or its data
## changes:
##
##   cd vignettes && Rscript precompute.R           # fit only what is missing
##   cd vignettes && Rscript precompute.R --clean    # refit everything
##
## The cache files live in inst/cache/ (NOT vignettes/cache/) so they ship with
## the installed package.  The articles locate them with
##
##   system.file("cache", package = "nlmixr2")
##
## To make that resolve to the *source* tree while we populate the cache, each
## article is rendered in a fresh R subprocess that first calls
## pkgload::load_all() on this repository.  load_all() registers inst/ so that
## system.file() points at <repo>/inst/cache, and the nlmixr2save `:=` calls
## inside the vignettes write/refresh the fits right there.
##
## Rendering runs the real vignette code, so the .Rmd remains the single source
## of truth and the cache cannot drift from it.  Each vignette is rendered in
## its OWN fresh R subprocess: building many rxode2 models in one long-lived
## session accumulates loaded model DLLs and eventually fails with "error
## building model", so isolating each render keeps the precompute reliable.

if (!requireNamespace("rmarkdown", quietly = TRUE)) {
  stop("precompute.R needs the 'rmarkdown' package")
}
if (!requireNamespace("pkgload", quietly = TRUE)) {
  stop("precompute.R needs the 'pkgload' package (to load the source package so that system.file() resolves to inst/cache/)")
}

rscript <- file.path(R.home("bin"), "Rscript")

## Locate the repo root and cache directory relative to THIS script, so the
## precompute works no matter which directory it is invoked from.
scriptArgs <- commandArgs(trailingOnly = FALSE)
scriptArg <- scriptArgs[startsWith(scriptArgs, "--file=")]
scriptPath <- if (length(scriptArg)) sub("^--file=", "", scriptArg[1]) else "precompute.R"
vignettesDir <- normalizePath(dirname(scriptPath), mustWork = TRUE)
repoRoot <- normalizePath(file.path(vignettesDir, ".."), mustWork = TRUE)
cacheDir <- file.path(repoRoot, "inst", "cache")

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
  "xgxr-nlmixr-ggpmx.Rmd",
  "articles/babelmixr2-external-engines.Rmd",
  "articles/imp-impmap-qrpem.Rmd",
  "articles/linearized-quadrature-ladder.Rmd",
  "articles/mixture-models.Rmd",
  "articles/nlm-family-optimizers.Rmd",
  "articles/nonparametric-npag-npb.Rmd",
  "articles/phase-residual-error.Rmd",
  "articles/priors-focei.Rmd",
  "articles/saem.Rmd",
  "articles/vaeNeonatal.Rmd",
  "articles/variational-inference.Rmd"
)

args <- commandArgs(trailingOnly = TRUE)
if ("--clean" %in% args) {
  ## Clear every cached fit/simulation so the next render refits.  The articles
  ## cache with nlmixr2save's `:=` operator as .zip (fits) and .rds (simulations);
  ## leave README.md in place.
  unlink(list.files(cacheDir, pattern = "\\.(zip|rds)$", full.names = TRUE))
  message("precompute.R: cleared ", cacheDir)
}

outDir <- tempfile("nlmixr2-precompute-")
dir.create(outDir)

## Build the R expression run by each subprocess: move into vignettes/ (so the
## articles' relative data/asset references resolve), load_all() the source
## package (so system.file("cache", ...) resolves to inst/cache/), then render.
renderScript <- function(v) {
  paste0(
    "setwd(", encodeString(vignettesDir, quote = "\""), "); ",
    "pkgload::load_all(", encodeString(repoRoot, quote = "\""), ", quiet=TRUE); ",
    "rmarkdown::render(", encodeString(v, quote = "\""),
    ", output_dir=", encodeString(outDir, quote = "\""),
    ", quiet=TRUE, envir=new.env(parent=globalenv()))")
}

failed <- character(0)
for (v in vignettes) {
  if (!file.exists(file.path(vignettesDir, v))) {
    warning("precompute.R: skipping missing vignette ", v)
    next
  }
  message("precompute.R: rendering ", v, " to populate ", cacheDir, " ...")
  status <- system2(rscript, c("-e", shQuote(renderScript(v))))
  if (!identical(status, 0L)) {
    message("precompute.R: FAILED on ", v, " (exit ", status, ")")
    failed <- c(failed, v)
  }
}

message("precompute.R: done. Cached fits:")
print(list.files(cacheDir, pattern = "\\.(zip|rds)$"))
if (length(failed)) {
  message("precompute.R: vignettes that did NOT render cleanly: ",
          paste(failed, collapse = ", "))
}
