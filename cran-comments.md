# nlmixr2 6.0.0

## Submission notes

- This release updates the `nlmixr2` meta-package (which attaches the
  nlmixr2 ecosystem, similar to `tidyverse`):

  - More ecosystem packages are attached when they happen to be
    installed; packages that are optional are now shown with an open
    circle in the startup banner while required packages keep the star.

  - Duplicated entries were removed from the optional package list so
    `nlmixr2CheckInstall()` no longer reports the same package twice.

- `nlmixr2save` (used for the website's cached example fits) is now on
  CRAN, so the `Remotes:` field has been removed from DESCRIPTION.

- No exported functions were added or removed relative to the version
  currently on CRAN (5.0.0), so no reverse dependency is affected by
  this update.

## R CMD check results

`R CMD check --as-cran` on R 4.6.1 (Ubuntu 24.04, x86_64): 0 errors, 0
warnings, 1 note.

The note is local to the check machine only:

```
* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found.
```
