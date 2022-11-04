#' Check your nlmixr2 installation for potential issues
#'
#' @examples
#' nlmixr2CheckInstall()
#' @export
nlmixr2CheckInstall <- function() {
  # Setup functions for reporting back to the user
  infoFun <- function(x) cat(x, "\n", sep = "")
  successFun <- function(x) cat("√ ", x, "\n", sep = "")
  warningFun <- function(x) cat("! ", x, "\n", sep = "")
  hasCli <- requireNamespace("cli")
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
      rxode2 = c("rxode2", "rxode2et", "rxode2parse", "rxode2ll", "rxode2random"),
      nlmixr2 = c("nlmixr2", "nlmixr2est", "nlmixr2data"),
      optional = c("nlmixr2lib", "nlmixr2extra", "nlmixr2lib", "babelmixr2")
    )
  allPkgs <- utils::installed.packages()
  missingPkgs <- character()
  for (pkgType in names(pkgNames)) {
    for (currentPkg in pkgNames[[pkgType]]) {
      notInstalledMsg <- sprintf("The package '%s' is not installed", currentPkg)
      if (currentPkg %in% rownames(allPkgs)) {
        installedMsg <- sprintf("The package '%s' is installed, version %s", currentPkg, allPkgs[currentPkg, "Version"])
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
