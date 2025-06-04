.verse <- new.env(parent=emptyenv())
.verse$core <- c(
  "lotri",
  "nlmixr2data",
  "nlmixr2est",
  "nlmixr2extra",
  "nlmixr2plot",
  "rxode2"
)
.verse$optional <- c(
  "babelmixr2",
  "ggPMX",
  "monolix2rx",
  "nlmixr2lib",
  "nonmem2rx",
  "shinymixr2",
  "xpose.nlmixr2"
)

core_loaded <- function() {
  search <- paste0("package:", .verse$core)
  .verse$core[search %in% search()]
}
core_unloaded <- function() {
  search <- paste0("package:", .verse$core)
  .verse$core[!search %in% search()]
}


nlmixr2_attach <- function() {
  to_load <- core_unloaded()
  if (length(to_load) == 0)
    return(invisible())

  msg(
    cli::rule(
      left = crayon::bold("Attaching packages"),
      right = paste0("nlmixr2 ", package_version("nlmixr2"))
    ),
    startup = TRUE
  )

  versions <- vapply(to_load, package_version, character(1))
  packages <- paste0(
    crayon::green(cli::symbol$tick), " ", crayon::blue(format(to_load)), " ",
    crayon::col_align(versions, max(crayon::col_nchar(versions)))
  )

  if (length(packages) %% 2 == 1) {
    packages <- append(packages, "")
  }
  col1 <- seq_len(length(packages) / 2)
  info <- paste0(packages[col1], "     ", packages[-col1])

  msg(paste(info, collapse = "\n"), startup = TRUE)

  msg(
    cli::rule(
      left = crayon::bold("Optional Packages Loaded/Ignored"),
      right = paste0("nlmixr2 ", package_version("nlmixr2"))
    ),
    startup = TRUE
  )
  msg(.verse$extra, startup=TRUE)

  suppressPackageStartupMessages(
    lapply(to_load, library, character.only = TRUE, warn.conflicts = FALSE)
  )

  invisible()
}

package_version <- function(x) {
  version <- as.character(unclass(utils::packageVersion(x))[[1]])

  if (length(version) > 3) {
    version[4:length(version)] <- crayon::red(as.character(version[4:length(version)]))
  }
  paste0(version, collapse = ".")
}

#' Conflicts between the nlmixr2 and other packages
#'
#' This function lists all the conflicts between packages in the nlmixr2
#' and other packages that you have loaded.
#'
#' If dplyr is one of the select packages, then the following four conflicts
#' are deliberately ignored: \code{intersect}, \code{union}, \code{setequal},
#' and \code{setdiff} from dplyr. These functions make the base equivalents
#' generic, so shouldn't negatively affect any existing code.
#'
#' @export
#' @examples
#' nlmixr2conflicts()
nlmixr2conflicts <- function() {
  envs <- purrr::set_names(search())
  objs <- invert(lapply(envs, ls_env))

  conflicts <- purrr::keep(objs, ~ length(.x) > 1)

  pkg_names <- paste0("package:", nlmixr2packages())
  conflicts <- purrr::keep(conflicts, ~ any(.x %in% pkg_names))

  conflict_funs <- purrr::imap(conflicts, confirm_conflict)
  conflict_funs <- purrr::compact(conflict_funs)

  structure(conflict_funs, class = "nlmixr2_conflicts")
}

nlmixr2_conflict_message <- function(x) {
  if (length(x) == 0) return("")

  header <- cli::rule(
    left = crayon::bold("Conflicts"),
    right = "nlmixr2conflicts()"
  )

  pkgs <- x %>% purrr::map(~ gsub("^package:", "", .))
  others <- pkgs %>% purrr::map(`[`, -1)
  other_calls <- purrr::map2_chr(
    others, names(others),
    ~ paste0(crayon::blue(.x), "::", .y, "()", collapse = ", ")
  )

  winner <- pkgs %>% purrr::map_chr(1)
  funs <- format(paste0(crayon::blue(winner), "::", crayon::green(paste0(names(x), "()"))))
  bullets <- paste0(
    crayon::red(cli::symbol$cross), " ", funs,
    " masks ", other_calls,
    collapse = "\n"
  )

  paste0(header, "\n", bullets)
}

#' @export
print.nlmixr2_conflicts <- function(x, ..., startup = FALSE) {
  cli::cat_line(nlmixr2_conflict_message(x))
}

#' @importFrom magrittr %>%
confirm_conflict <- function(packages, name) {
  # Only look at functions
  objs <- packages %>%
    purrr::map(~ get(name, pos = .)) %>%
    purrr::keep(is.function)

  if (length(objs) <= 1)
    return()

  # Remove identical functions
  objs <- objs[!duplicated(objs)]
  packages <- packages[!duplicated(packages)]
  if (length(objs) == 1)
    return()

  packages
}

ls_env <- function(env) {
  x <- ls(pos = env)
  if (identical(env, "package:dplyr")) {
    x <- setdiff(x, c("intersect", "setdiff", "setequal", "union"))
  }
  x
}

#' Update nlmixr2 packages
#'
#' This will check to see if all nlmixr2 packages (and optionally, their
#' dependencies) are up-to-date, and will install after an interactive
#' confirmation.
#'
#' @param recursive If \code{TRUE}, will also check all dependencies of
#'   nlmixr2 packages.
#' @export
#' @examples
#' \dontrun{
#' nlmixr2update()
#' }
nlmixr2update <- function(recursive = FALSE) {

  deps <- nlmixr2deps(recursive)
  behind <- dplyr::filter(deps, behind)

  if (nrow(behind) == 0) {
    cli::cat_line("All nlmixr2 packages up-to-date")
    return(invisible())
  }

  cli::cat_line("The following packages are out of date:")
  cli::cat_line()
  cli::cat_bullet(
    format(behind$package), " (", behind$local, " -> ", behind$cran, ")")

  cli::cat_line()
  cli::cat_line("Start a clean R session then run:")

  pkg_str <- paste0(deparse(behind$package), collapse = "\n")
  cli::cat_line("install.packages(", pkg_str, ")")

  invisible()
}

#' List all nlmixr2 dependencies
#'
#' @param recursive If \code{TRUE}, will also list all dependencies of
#'   nlmixr2 packages.
#' @export
nlmixr2deps <- function(recursive = FALSE) {
  pkgs <- utils::available.packages()
  deps <- tools::package_dependencies("nlmixr2", pkgs, recursive = recursive)

  pkg_deps <- unique(sort(unlist(deps)))

  base_pkgs <- c(
    "base", "compiler", "datasets", "graphics", "grDevices", "grid",
    "methods", "parallel", "splines", "stats", "stats4", "tools", "tcltk",
    "utils"
  )
  pkg_deps <- setdiff(pkg_deps, base_pkgs)

  cran_version <- lapply(pkgs[pkg_deps, "Version"], base::package_version)
  local_version <- lapply(pkg_deps, utils::packageVersion)

  behind <- purrr::map2_lgl(cran_version, local_version, `>`)

  tibble::tibble(
    package = pkg_deps,
    cran = cran_version %>% purrr::map_chr(as.character),
    local = local_version %>% purrr::map_chr(as.character),
    behind = behind
  )
}

msg <- function(..., startup = FALSE) {
  packageStartupMessage(text_col(...))
}

text_col <- function(x) {
  # If RStudio not available, messages already printed in black
  if (!rstudioapi::isAvailable()) {
    return(x)
  }

  if (!rstudioapi::hasFun("getThemeInfo")) {
    return(x)
  }

  theme <- rstudioapi::getThemeInfo()

  if (isTRUE(theme$dark)) crayon::white(x) else crayon::black(x)

}

#' List all packages in the nlmixr2
#'
#' @param include_self Include nlmixr2 in the list?
#' @export
#' @examples
#' nlmixr2packages()
nlmixr2packages <- function(include_self = TRUE) {
  raw <- utils::packageDescription("nlmixr2")$Imports
  imports <- strsplit(raw, ",")[[1]]
  parsed <- gsub("^\\s+|\\s+$", "", imports)
  names <- vapply(strsplit(parsed, "\\s+"), "[[", 1, FUN.VALUE = character(1))

  if (include_self) {
    names <- c(names, "nlmixr2")
  }

  names
}

invert <- function(x) {
  if (length(x) == 0) return()
  stacked <- utils::stack(x)
  tapply(as.character(stacked$ind), stacked$values, list)
}


style_grey <- function(level, ...) {
  crayon::style(
    paste0(...),
    crayon::make_style(grDevices::grey(level), grey = TRUE)
  )
}
#' This updates the "required" packages by adding available optional packages
#'
#' This also updates `.verse$extra` with the loaded optional packages
#'
#' @return  nothing called for side effects
#' @noRd
#' @author Matthew L. Fidler
.updatePackageCore <- function() {
  .extra <- vapply(.verse$optional,
                   function(p) {
                     requireNamespace(p, quietly = TRUE)
                   }, logical(1))
  added <- .verse$optional[.extra]
  ignored <- .verse$optional[!.extra]
  .verse$core <- c(.verse$core, added)
  packages <- NULL
  if (length(added) > 0) {
    packages <- paste0(
      crayon::green(cli::symbol$tick), " ", crayon::blue(format(added)))
  }
  if (length(ignored) > 0) {
    packages <- c(packages,
                  paste0(crayon::red(cli::symbol$cross), " ", crayon::red(ignored)))
  }



  if (length(packages) %% 2 == 1) {
    packages <- append(packages, "")
  }
  col1 <- seq_len(length(packages) / 2)
  info <- paste0(packages[col1], "     ", packages[-col1])

  .verse$extra <- paste(info, collapse = "\n")
}

.onAttach <- function(...) {
  .updatePackageCore()
  needed <- .verse$core[!is_attached(.verse$core)]
  if (length(needed) == 0)
    return()

  crayon::num_colors(TRUE)
  nlmixr2_attach()

  if (!"package:conflicted" %in% search()) {
    x <- nlmixr2conflicts()
    msg(nlmixr2_conflict_message(x), startup = TRUE)
  }

}

is_attached <- function(x) {
  paste0("package:", x) %in% search()
}

dummy <- function()  {
  lotri::lotri()
  rxode2::rxModelVars("a=b")
  try(nlmixr2est::nlmixr2())
  try(nlmixr2extra::bootplot())
  try(nlmixr2plot::vpcPlot())
}
