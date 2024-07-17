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

#' Check your nlmixr2 installation for potential issues
#'
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
    infoFun <- cli::cli_alert_info
    successFun <- cli::cli_alert_success
    warningFun <- cli::cli_alert_danger
  }
  sysInfo <- Sys.info()
  osInfo <- sprintf("Operating system: %s %s %s", sysInfo["sysname"], sysInfo["release"], sysInfo["version"])
  infoFun(osInfo)
  isWindows <- sysInfo["sysname"] == "Windows"
  hasDevtools <- requireNamespace("devtools")
  if (isWindows & hasDevtools) {
    hasRtools <- devtools::find_rtools(debug = TRUE)
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
      optional = c("nlmixr2lib", "nonmem2rx", "babelmixr2")
    )
  repos <- getOption("repos")
  if ("@CRAN@" %in% repos)  {
    warningFun("The CRAN repo needs to be selected to determine package information")
    return(invisible())
  }
  allPkgs <- utils::installed.packages()
  oldPkgs <- utils::old.packages()
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
        installedMsg <- sprintf("The package '%s' is installed and seems to be up to date, version %s", currentPkg, allPkgs[currentPkg, "Version"])
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
}
