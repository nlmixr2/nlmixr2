# Conflicts between the nlmixr2 and other packages

This function lists all the conflicts between packages in the nlmixr2
and other packages that you have loaded.

## Usage

``` r
nlmixr2conflicts()
```

## Details

If dplyr is one of the select packages, then the following four
conflicts are deliberately ignored: `intersect`, `union`, `setequal`,
and `setdiff` from dplyr. These functions make the base equivalents
generic, so shouldn't negatively affect any existing code.

## Examples

``` r
nlmixr2conflicts()
#> ── Conflicts ───────────────────────────────────────────── nlmixr2conflicts() ──
#> ✖ rxode2::boxCox()     masks nlmixr2est::boxCox()
#> ✖ rxode2::yeoJohnson() masks nlmixr2est::yeoJohnson()
```
