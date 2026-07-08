## Fit cache for the pkgdown articles.
##
## The vignettes/ directory is .Rbuildignore'd, so these articles are built
## only for the website (pkgdown), never during R CMD check / CRAN. The
## estimation calls (SAEM / FOCEi on the larger models) dominate the build and
## were timing the pkgdown runner out. cacheFit() runs each fit once, stores it
## under vignettes/cache/, and on every later build loads the stored fit instead
## of re-estimating. Populate/refresh the cache with vignettes/precompute.R.

.nlmixrCacheDir <- Sys.getenv("NLMIXR_VIGNETTE_CACHE", "cache")

## cacheFit(name, expr): return the cached fit `name` if present, otherwise
## evaluate `expr` (a fit), store it, and return it. `expr` is a normal (lazy)
## argument, so on a cache hit the estimation is never run.
cacheFit <- function(name, expr) {
  .f <- file.path(.nlmixrCacheDir, paste0(name, ".rds"))
  if (file.exists(.f)) {
    message("cacheFit: loading '", name, "' from ", .f)
    .cacheTrace("hit", name, .f)
    return(readRDS(.f))
  }
  message("cacheFit: computing '", name, "' (no cache at ", .f, ")")
  .cacheTrace("miss", name, .f)
  .val <- expr
  dir.create(.nlmixrCacheDir, showWarnings = FALSE, recursive = TRUE)
  saveRDS(.val, .f, compress = "xz") # xz ~halves the committed cache size
  .val
}

## Optional trace, useful for confirming (e.g. under pkgdown, which renders
## quietly) that a build loaded fits from cache instead of refitting. Set
## NLMIXR_VIGNETTE_CACHE_TRACE to a file path to record one line per cacheFit
## call; unset (the default) it does nothing.
.cacheTrace <- function(kind, name, path) {
  .tf <- Sys.getenv("NLMIXR_VIGNETTE_CACHE_TRACE", "")
  if (nzchar(.tf)) {
    cat(sprintf("%s\t%s\t%s\t%s\n", kind, name, normalizePath(path, mustWork = FALSE),
                getwd()),
        file = .tf, append = TRUE)
  }
  invisible(NULL)
}

## cacheClean(): drop the whole cache so the next build/precompute refits.
cacheClean <- function() {
  if (dir.exists(.nlmixrCacheDir)) {
    unlink(list.files(.nlmixrCacheDir, pattern = "\\.rds$", full.names = TRUE))
  }
  invisible(NULL)
}
