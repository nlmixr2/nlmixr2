# nlmixr2 7.0.1

## Resubmission

This is a resubmission of 7.0.0, which failed the incoming pre-test on
r-devel-windows with an ERROR while running the example of
`nlmixr2CheckInstall()`:

```
Error in av.src[pkg.bin, "Version"] : subscript out of bounds
Calls: nlmixr2CheckInstall -> <Anonymous> -> .available.both
```

`nlmixr2CheckInstall()` reports whether the installed nlmixr2 packages
are current, which it did by calling `utils::old.packages()`.  On Windows
`getOption("pkgType")` is `"both"`, so that call goes through R's internal
`utils:::.available.both()`, which errors when the source and binary
indexes of the repository disagree about a package.

`nlmixr2CheckInstall()` now treats a failure to query the repositories --
whether from that error or from having no internet connection at all --
as "the installed versions could not be compared to the current versions"
and continues with the rest of the installation check, so the example can
no longer fail.  The example was verified against the unreachable
repository case and against a simulated `.available.both()` error.

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

- The dependency on `magrittr` was dropped in favor of the native `|>`
  pipe, which raises the minimum R version to 4.1.0.  `%>%` was only
  imported, never exported by `nlmixr2`, so this does not change the
  package's user-visible API.

- No exported functions were added or removed relative to the version
  currently on CRAN (5.0.0), so no reverse dependency is affected by
  this update.

## R CMD check results

`R CMD check --as-cran` on R 4.6.1 (Ubuntu 24.04, x86_64), with all
suggested packages installed: 0 errors, 0 warnings, 1 note.

The note is local to the check machine only:

```
* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found.
```
