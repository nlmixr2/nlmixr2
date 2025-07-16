- As requested by CRAN, I am updating the `nlmixr2` package.

- This release changes the nlmixr2 package to a importing only package
  instead of a re-exporting package (similar to `tidyverse`)

- Because of this change, it breaks the following packages, which I
  have informed over a month ago and provided pull requests to fix them

  - `ruminate` (https://github.com/john-harrold/ruminate/pull/35)
  - `shinyMixR` (https://github.com/RichardHooijmaijers/shinyMixR/pull/46)

I provided fixes to other packages which have now been submitted to CRAN
