.isLatex <- function ()
{
  if (!("knitr" %in% loadedNamespaces())) {
    return(FALSE)
  }
  get("is_latex_output", asNamespace("knitr"))()
}

.useUtf <- function() {
  opt <- getOption("cli.unicode", NULL)
  if (!is.null(opt)) {
    isTRUE(opt)
  }
  else {
    l10n_info()$`UTF-8` && !.isLatex()
  }
}

#' Query the repositories for out of date packages
#'
#' This is a wrapper around [utils::old.packages()] that never signals an
#' error.  The repository query needs a working internet connection, and it
#' can also fail on its own when the source and binary indexes of a
#' repository disagree (`utils:::.available.both()` errors with "subscript
#' out of bounds").  Neither is a problem with the installation being
#' checked, so both degrade to "updates could not be checked".
#'
#' @return A list with `ok`, which is `TRUE` when the repositories could be
#'   queried, and `old`, the [utils::old.packages()] matrix (`NULL` when
#'   nothing is out of date or when `ok` is `FALSE`)
#' @noRd
.oldPackagesOrNull <- function() {
  failed <- list(ok = FALSE, old = NULL)
  available <- tryCatch(suppressWarnings(utils::available.packages()), error = function(e) NULL)
  # An unreachable repository warns and gives back a zero row matrix
  if (is.null(available) || nrow(available) == 0) {
    return(failed)
  }
  tryCatch(
    list(ok = TRUE, old = suppressWarnings(utils::old.packages(available = available))),
    error = function(e) failed
  )
}

#' Check your nlmixr2 installation for potential issues
#'
#' @return Nothing, called for the side effect of reporting on the
#'   installation
#' @examples
#' nlmixr2CheckInstall()
#' @export
nlmixr2CheckInstall <- function() {
  # Setup functions for reporting back to the user
  infoFun <- function(x) message(x, sep = "")
  successFun <- function(x) message(ifelse(.useUtf(), "\u2714", "v"), x,  sep = "")
  warningFun <- function(x) message("! ", x, sep = "")
  hasCli <- requireNamespace("cli", quietly = TRUE)
  if (hasCli) {
    # The messages below embed paths and command output, which cli would
    # otherwise treat as glue expressions to interpolate
    escapeCli <- function(x) gsub("}", "}}", gsub("{", "{{", x, fixed = TRUE), fixed = TRUE)
    infoFun <- function(x) cli::cli_alert_info(escapeCli(x))
    successFun <- function(x) cli::cli_alert_success(escapeCli(x))
    warningFun <- function(x) cli::cli_alert_danger(escapeCli(x))
  }
  sysInfo <- Sys.info()
  osInfo <- sprintf("Operating system: %s %s %s", sysInfo["sysname"], sysInfo["release"], sysInfo["version"])
  infoFun(osInfo)
  isWindows <- sysInfo["sysname"] == "Windows"
  hasDevtools <- requireNamespace("devtools", quietly = TRUE)
  if (isWindows & hasDevtools) {
    hasRtools <- isTRUE(tryCatch(devtools::find_rtools(debug = TRUE), error = function(e) FALSE))
    if (hasRtools) {
      successFun("Rtools appears to be installed successfully")
    } else {
      warningFun("Rtools needs to be (re)installed")
    }
  } else if (isWindows & !hasDevtools) {
    infoFun("devtools package is not installed, cannot test Rtools installation, run the following to allow this check:\ninstall.packages('devtools')")
  }
  makePath <- Sys.which("make")
  if (nchar(makePath) == 0) {
    warningFun("The 'make' command to compile models was not found.  You may need to install Rtools (Windows), build-essential (Debian or Ubuntu Linux), or the homebrew build tools (Mac)")
  } else {
    successFun(paste("The 'make' command was found: ", makePath))
    makeVer <- system2(makePath, args = "--version", stdout = TRUE, stderr = TRUE)
    infoFun(paste(makeVer, collapse = "\n"))
  }
  pkgNames <-
    list(
      rxode2 = c("rxode2", "rxode2ll", "lotri"),
      nlmixr2 = c("nlmixr2", "nlmixr2est", "nlmixr2data", "nlmixr2extra", "nlmixr2plot"),
      optional = .verse$optional
    )
  repos <- getOption("repos")
  if ("@CRAN@" %in% repos)  {
    warningFun("The CRAN repo needs to be selected to determine package information")
    return(invisible())
  }
  allPkgs <- utils::installed.packages()
  oldPkgsInfo <- .oldPackagesOrNull()
  oldPkgs <- oldPkgsInfo$old
  checkedUpdates <- oldPkgsInfo$ok
  if (!checkedUpdates) {
    warningFun("The repositories could not be queried, so the installed packages cannot be compared to the current versions")
  }
  missingPkgs <- character()
  for (pkgType in names(pkgNames)) {
    for (currentPkg in pkgNames[[pkgType]]) {
      notInstalledMsg <- sprintf("The package '%s' is not installed", currentPkg)
      if (currentPkg %in% rownames(oldPkgs)) {
        oldMsg <-
          sprintf(
            "The package '%s' is installed but is not the current version, installed version: %s, current version: %s",
            currentPkg,
            allPkgs[currentPkg, "Version"],
            oldPkgs[currentPkg, "ReposVer"]
          )
        warningFun(oldMsg)
      } else if (currentPkg %in% rownames(allPkgs)) {
        if (checkedUpdates) {
          installedMsg <- sprintf("The package '%s' is installed and seems to be up to date, version %s", currentPkg, allPkgs[currentPkg, "Version"])
        } else {
          installedMsg <- sprintf("The package '%s' is installed, version %s (could not check if it is up to date)", currentPkg, allPkgs[currentPkg, "Version"])
        }
        successFun(installedMsg)
      } else if (pkgType == "optional") {
        missingPkgs <- c(missingPkgs, currentPkg)
        notInstalledMsg <- sprintf("The package '%s' is not installed (it is optional for all rxode2/nlmixr2 work)", currentPkg)
        warningFun(notInstalledMsg)
      } else {
        missingPkgs <- c(missingPkgs, currentPkg)
        notInstalledMsg <- sprintf("The package '%s' is not installed", currentPkg)
        warningFun(notInstalledMsg)
      }
    }
  }
  if (length(missingPkgs) > 0) {
    if (length(missingPkgs) == 1) {
      installStr <- paste0("'", missingPkgs, "'")
    } else {
      installStr <-
        paste0(
          "c(",
          paste0("'", missingPkgs, "'", collapse = ", "),
          ")"
        )
    }
    installCmd <- sprintf("To install missing packages, run the following command:\ninstall.packages(%s)", installStr)
    infoFun(installCmd)
  }
  invisible()
}
