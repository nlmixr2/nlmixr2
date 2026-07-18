# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this package is

`nlmixr2` is a **meta-package** (like `tidyverse` is for the tidyverse). It contains almost no
modeling code of its own. Its job is to attach and manage the nlmixr2 ecosystem and to host the
project's website (pkgdown) articles. The real work lives in the *dependency* packages:

- `rxode2` — ODE solving / model parsing (the C engine)
- `nlmixr2est` — estimation routines (`nlmixr2()`, `saem`, `focei`, `nlm`, …)
- `nlmixr2extra` — bootstrap, VPC prep, extra tooling
- `nlmixr2plot` — goodness-of-fit plots (`plot(fit)`)
- `lotri`, `nlmixr2data` — matrix syntax and datasets

When a bug is in estimation, solving, or plotting, it is almost certainly in one of those repos,
not here. This repo is the right place only for: the attach/loading machinery, `nlmixr2CheckInstall`,
conflict reporting, and the vignettes/website.

## Source layout

- `R/verse.R` — the entire tidyverse-style attach system: `.onAttach` → `.nlmixr2attach()` builds
  the set of packages to load from `.verse$core` (required) + `.verse$optional` (loaded only if
  installed), prints the startup banner, and reports masked functions via `nlmixr2conflicts()`.
  Optional packages (`babelmixr2`, `xpose.nlmixr2`, `ggPMX`, …) are promoted into `core` at attach
  time by `.updatePackageCore()`. The `exclude=` arg exists so a package like `babelmixr2` can attach
  the stack without recursively loading itself.
- `R/nlmixr2CheckInstall.R` — user-facing installation sanity check.
- Exported API is small: `nlmixr2CheckInstall`, `nlmixr2conflicts`, `nlmixr2deps`,
  `nlmixr2packages`, `nlmixr2update`, `.nlmixr2attach`. The core `nlmixr2()`/`nlmixr()` fitting
  functions are re-exported from `nlmixr2est`, not defined here.

## Commands

Standard R package tooling (run from the repo root):

```r
devtools::load_all()      # load for interactive dev
devtools::document()      # regenerate man/ + NAMESPACE from roxygen (roxygen2 8.0.0)
devtools::test()          # run testthat suite
devtools::check()         # R CMD check
```

Run a single test file:

```r
testthat::test_file("tests/testthat/test-basic-nlmixr2.R")
```

The test suite is intentionally tiny (`test-basic-nlmixr2.R`, `test-ini-pipe.R`) — it only smoke-tests
that a model builds and that ini-piping works, because deep testing belongs to the dependency packages.

## Vignettes / website (the substance of this repo)

Articles under `vignettes/` are the main deliverable here, and they matter more than the R code:

- `vignettes/` is `.Rbuildignore`d — articles are built **only for the pkgdown website**, never during
  `R CMD check` or on CRAN. This is deliberate: it lets an article run a *real* SAEM/FOCEi/DDE fit.
- Because real fits are slow and the pkgdown runner times out, expensive fits are **cached** with the
  `:=` operator from the `nlmixr2save` package (imported here). `fit := nlmixr2(...)` writes a portable
  `cache/<prefix>-fit.zip` the first time and reloads it on every later build. See
  `vignettes/precompute-articles.Rmd` for the full contract (setup chunk uses
  `options(nlmixr2save.dir="cache", nlmixr2save.prefix="<article>-", nlmixr2save.check=FALSE)`).
- **Regenerate the cache** with `vignettes/precompute.R`:
  ```bash
  cd vignettes && Rscript precompute.R            # fit only what's missing
  cd vignettes && Rscript precompute.R --clean    # clear cache/ and refit everything
  ```
  It renders each cached article listed in the `vignettes` vector in its **own fresh R subprocess**
  (one long-lived session accumulates rxode2 model DLLs and eventually fails with "error building
  model"). When you add a new cached article, add its filename to that vector.
- `_pkgdown.yml` defines the navbar/article menu; the pkgdown GitHub workflow installs the GitHub
  version of `nlmixr2save` (it is a `Remotes:` dependency, not yet on CRAN).

## Conventions

- `README.md` is generated from `README.Rmd` — edit the `.Rmd`.
- Use the native `|>` pipe, not magrittr `%>%` (magrittr was dropped from this package).
- Startup/console output uses `cli` + `crayon` (colored banner, conflict messages); keep that style
  if you touch `verse.R`.
