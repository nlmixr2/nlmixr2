#' @import nlmixr2data
#' @import nlmixr2plot
#' @importFrom stats predict logLik na.fail pchisq approxfun cov cov2cor dlnorm median na.omit qchisq qnorm
#' @noRd
.genHardReExport <- function(fun) { # nocov start
  message("Writing hard reexport: ", fun)
  .args <- deparse(eval(str2lang(paste0("args(", fun, ")"))))
  if (fun == "nlmixr2est::nlmixr2") {
    .args <- gsub("data *=*[^,]*,", "data = NULL,", .args)
   }
  .args <- .args[-length(.args)]
  .formalArgs <- as.character(eval(str2lang(paste0("formalArgs(", fun, ")"))))
  .w <- which(.formalArgs == "...")
  .formalArgs <- paste0(.formalArgs, "=", .formalArgs)
  .has3 <- FALSE
  if (length(.w) > 0) {
    .formalArgs[.w] <- "..."
    .has3 <- TRUE
  }
  .formalArgs <- paste(.formalArgs, collapse=", ")
  .newFun <- strsplit(fun, "::")[[1]][2]
  .has3text <- NULL
  if (.has3) {
    .has3text <- paste0("#' @param ... Additional arguments passed to [", fun, "()].")
  }
  ret <-
    paste(
      c(paste("#' @inherit", fun),
        .has3text,
        "#' @export",
        trimws(
          deparse(str2lang(paste0(
            c(paste0(.newFun, " <- ", paste0(.args, collapse="\n"), " {"),
              paste0(fun, "(", .formalArgs, ")"),
              "}"
            ),
            collapse="\n"
          ))),
          which = "right"
        )
      ),
      collapse="\n"
    )
  ret <- gsub(x = ret, pattern = "{", replacement = "{ # nocov start", fixed = TRUE)
  ret <- gsub(x = ret, pattern = "}", replacement = "} # nocov end", fixed = TRUE)
  ret
} # nocov end

.genSoftReExport <- function(fun, alias=NULL) { # nocov start
  message("Writing soft reexport: ", fun)
  .newFun <- strsplit(fun, "::")[[1]]
  .pkg <- .newFun[1]
  .fun <- .newFun[2]
  if (is.na(.fun)) return("")
  .aliasText <- NULL
  if (!is.null(alias)) {
    .aliasText <- paste0("#' @rdname ", .fun)
  }
  paste(
    c(paste("#' @importFrom", .pkg, .fun),
      .aliasText,
      "#' @export",
      fun
    ),
    collapse="\n"
  )
} # nocov end

.genReexports <- function(soft=c("rxode2::rxode2",
                                 "rxode2::rxode",
                                 "rxode2::RxODE",
                                 "rxode2::rxDerived",
                                 "magrittr::`%>%`",
                                 "rxode2::ini",
                                 "rxode2::model",
                                 "rxode2::lotri",
                                 "rxode2::expit",
                                 "rxode2::probit",
                                 "rxode2::probitInv",
                                 "rxode2::logit",
                                 "rxode2::rxSolve",
                                 "rxode2::rxClean",
                                 "rxode2::rxCat",
                                 "rxode2::rxSetPipingAuto",
                                 "rxode2::eventTable",
                                 "rxode2::add.dosing",
                                 "rxode2::add.sampling",
                                 "rxode2::rxFun",
                                 "nlmixr2est::nlmixr2AllEst",
                                 "nlmixr2est::pdDiag",
                                 "nlmixr2est::pdSymm",
                                 "nlmixr2est::pdLogChol",
                                 "nlmixr2est::pdIdent",
                                 "nlmixr2est::pdCompSymm",
                                 "nlmixr2est::pdBlocked",
                                 "nlmixr2est::pdNatural",
                                 "nlmixr2est::pdConstruct",
                                 "nlmixr2est::pdFactor",
                                 "nlmixr2est::pdMat",
                                 "nlmixr2est::pdMatrix",
                                 "nlmixr2est::reStruct",
                                 "nlmixr2est::varWeights",
                                 "nlmixr2est::varPower",
                                 "nlmixr2est::varFixed",
                                 "nlmixr2est::varFunc",
                                 "nlmixr2est::varExp",
                                 "nlmixr2est::varConstPower",
                                 "nlmixr2est::varIdent",
                                 "nlmixr2est::varComb",
                                 "nlmixr2est::groupedData",
                                 "nlmixr2est::getData",
                                 "rxode2::`model<-`",
                                 "rxode2::`ini<-`",
                                 "rxode2::etExpand",
                                 "rxode2::et",
                                 "rxode2::rxParams",
                                 "rxode2::rxParam",
                                 "rxode2::geom_cens",
                                 "rxode2::geom_amt",
                                 "rxode2::stat_cens",
                                 "rxode2::stat_amt",
                                 "rxode2::rxControl",
                                 "nlmixr2est::nlme",
                                 "nlmixr2est::ACF",
                                 "nlmixr2est::VarCorr",
                                 "nlmixr2est::getVarCov",
                                 "nlmixr2est::augPred",
                                 "nlmixr2est::fixef",
                                 "nlmixr2est::fixed.effects",
                                 "nlmixr2est::ranef",
                                 "nlmixr2est::random.effects",
                                 "nlmixr2est::.nlmixrNlmeFun",
                                 "nlmixr2est::nlmixr2NlmeControl",
                                 "nlmixr2est::nlmixr",
                                 "lotri::lotri"
                                 ),
                          hard=c("nlmixr2plot::traceplot",
                                 "nlmixr2est::vpcSim",
                                 "nlmixr2plot::vpcPlot",
                                 "nlmixr2plot::vpcPlotTad",
                                 "nlmixr2plot::vpcCens",
                                 "nlmixr2plot::vpcCensTad",
                                 "nlmixr2est::saemControl",
                                 "nlmixr2est::foceiControl",
                                 "nlmixr2est::nlmeControl",
                                 "nlmixr2est::tableControl",
                                 "nlmixr2est::addCwres",
                                 "nlmixr2est::addNpde",
                                 "nlmixr2est::addTable",
                                 "nlmixr2est::setOfv",
                                 "nlmixr2extra::preconditionFit",
                                 "nlmixr2extra::bootstrapFit",
                                 "nlmixr2extra::covarSearchAuto",
                                 "nlmixr2extra::bootplot")
                          ) { # nocov start
  writeLines(c("# Generated from .genReexports()\n",
               paste(vapply(soft, .genSoftReExport, character(1), USE.NAMES=FALSE),
                     collapse="\n\n")),
             devtools::package_file("R/reexports.R"))
  writeLines(c("# Generated from .genReexports()\n",
               paste(vapply(hard, .genHardReExport, character(1), USE.NAMES=FALSE),
                     collapse="\n\n")),
             devtools::package_file("R/hardReexports.R"))
  ""
} # nocov end

#' @inherit nlmixr2est::nlmixr2
#' @param ... Additional arguments passed to [nlmixr2est::nlmixr2()].
#' @eval .genReexports()
#' @export
nlmixr2 <- function(object, data, est = NULL, control = list(),
                    table = tableControl(), ..., save = NULL, envir = parent.frame()) {
  .hasColor <- crayon::has_color()
  .objectName <- try(as.character(substitute(object)), silent=TRUE)
  if (inherits(.objectName, "try-error")) .objectName <- "x"
  nlmixr2est::.nlmixr2objectNameAssign(.objectName)
  if (missing(data)) {
    nlmixr2est::nlmixr2(object = object)
  } else {
    nlmixr2est::nlmixr2(object = object, data = data, est = est,
        control = control, table = table, ..., save = save, envir = envir)
  }
}
