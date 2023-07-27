# Generated from .genReexports()

#' @inherit nlmixr2plot::traceplot
#' @param ... Additional arguments passed to [nlmixr2plot::traceplot()].
#' @export
traceplot <- function(x, ...) { # nocov start
    nlmixr2plot::traceplot(x = x, ...)
} # nocov end

#' @inherit nlmixr2est::vpcSim
#' @param ... Additional arguments passed to [nlmixr2est::vpcSim()].
#' @export
vpcSim <- function(object, ..., keep = NULL, n = 300, pred = FALSE,
    seed = 1009, nretry = 50, normRelated = TRUE) { # nocov start
    nlmixr2est::vpcSim(object = object, ..., keep = keep, n = n,
        pred = pred, seed = seed, nretry = nretry, normRelated = normRelated)
} # nocov end

#' @inherit nlmixr2plot::vpcPlot
#' @param ... Additional arguments passed to [nlmixr2plot::vpcPlot()].
#' @export
vpcPlot <- function(fit, data = NULL, n = 300, bins = "jenks",
    n_bins = "auto", bin_mid = "mean", show = NULL, stratify = NULL,
    pred_corr = FALSE, pred_corr_lower_bnd = 0, pi = c(0.05,
        0.95), ci = c(0.05, 0.95), uloq = fit$dataUloq, lloq = fit$dataLloq,
    log_y = FALSE, log_y_min = 0.001, xlab = NULL, ylab = NULL,
    title = NULL, smooth = TRUE, vpc_theme = NULL, facet = "wrap",
    scales = "fixed", labeller = NULL, vpcdb = FALSE, verbose = FALSE,
    ..., seed = 1009, idv = "time", cens = FALSE) { # nocov start
    nlmixr2plot::vpcPlot(fit = fit, data = data, n = n, bins = bins,
        n_bins = n_bins, bin_mid = bin_mid, show = show, stratify = stratify,
        pred_corr = pred_corr, pred_corr_lower_bnd = pred_corr_lower_bnd,
        pi = pi, ci = ci, uloq = uloq, lloq = lloq, log_y = log_y,
        log_y_min = log_y_min, xlab = xlab, ylab = ylab, title = title,
        smooth = smooth, vpc_theme = vpc_theme, facet = facet,
        scales = scales, labeller = labeller, vpcdb = vpcdb,
        verbose = verbose, ..., seed = seed, idv = idv, cens = cens)
} # nocov end

#' @inherit nlmixr2plot::vpcPlotTad
#' @param ... Additional arguments passed to [nlmixr2plot::vpcPlotTad()].
#' @export
vpcPlotTad <- function(..., idv = "tad") { # nocov start
    nlmixr2plot::vpcPlotTad(..., idv = idv)
} # nocov end

#' @inherit nlmixr2plot::vpcCens
#' @param ... Additional arguments passed to [nlmixr2plot::vpcCens()].
#' @export
vpcCens <- function(..., cens = TRUE, idv = "time") { # nocov start
    nlmixr2plot::vpcCens(..., cens = cens, idv = idv)
} # nocov end

#' @inherit nlmixr2plot::vpcCensTad
#' @param ... Additional arguments passed to [nlmixr2plot::vpcCensTad()].
#' @export
vpcCensTad <- function(..., cens = TRUE, idv = "tad") { # nocov start
    nlmixr2plot::vpcCensTad(..., cens = cens, idv = idv)
} # nocov end

#' @inherit nlmixr2est::saemControl
#' @param ... Additional arguments passed to [nlmixr2est::saemControl()].
#' @export
saemControl <- function(seed = 99, nBurn = 200, nEm = 300, nmc = 3,
    nu = c(2, 2, 2), print = 1, trace = 0, covMethod = c("linFim",
        "fim", "r,s", "r", "s", ""), calcTables = TRUE, logLik = FALSE,
    nnodesGq = 3, nsdGq = 1.6, optExpression = TRUE, adjObf = TRUE,
    sumProd = FALSE, addProp = c("combined2", "combined1"), tol = 1e-06,
    itmax = 30, type = c("nelder-mead", "newuoa"), powRange = 10,
    lambdaRange = 3, odeRecalcFactor = 10^(0.5), maxOdeRecalc = 5L,
    perSa = 0.75, perNoCor = 0.75, perFixOmega = 0.1, perFixResid = 0.1,
    compress = TRUE, rxControl = NULL, sigdig = NULL, sigdigTable = NULL,
    ci = 0.95, muRefCov = TRUE, ...) { # nocov start
    nlmixr2est::saemControl(seed = seed, nBurn = nBurn, nEm = nEm,
        nmc = nmc, nu = nu, print = print, trace = trace, covMethod = covMethod,
        calcTables = calcTables, logLik = logLik, nnodesGq = nnodesGq,
        nsdGq = nsdGq, optExpression = optExpression, adjObf = adjObf,
        sumProd = sumProd, addProp = addProp, tol = tol, itmax = itmax,
        type = type, powRange = powRange, lambdaRange = lambdaRange,
        odeRecalcFactor = odeRecalcFactor, maxOdeRecalc = maxOdeRecalc,
        perSa = perSa, perNoCor = perNoCor, perFixOmega = perFixOmega,
        perFixResid = perFixResid, compress = compress, rxControl = rxControl,
        sigdig = sigdig, sigdigTable = sigdigTable, ci = ci,
        muRefCov = muRefCov, ...)
} # nocov end

#' @inherit nlmixr2est::foceiControl
#' @param ... Additional arguments passed to [nlmixr2est::foceiControl()].
#' @export
foceiControl <- function(sigdig = 3, ..., epsilon = NULL, maxInnerIterations = 1000,
    maxOuterIterations = 5000, n1qn1nsim = NULL, print = 1L,
    printNcol = floor((getOption("width") - 23)/12), scaleTo = 1,
    scaleObjective = 0, normType = c("rescale2", "mean", "rescale",
        "std", "len", "constant"), scaleType = c("nlmixr2", "norm",
        "mult", "multAdd"), scaleCmax = 1e+05, scaleCmin = 1e-05,
    scaleC = NULL, scaleC0 = 1e+05, derivEps = rep(20 * sqrt(.Machine$double.eps),
        2), derivMethod = c("switch", "forward", "central"),
    derivSwitchTol = NULL, covDerivMethod = c("central", "forward"),
    covMethod = c("r,s", "r", "s", ""), hessEps = (.Machine$double.eps)^(1/3),
    hessEpsLlik = (.Machine$double.eps)^(1/3), optimHessType = c("central",
        "forward"), optimHessCovType = c("central", "forward"),
    eventType = c("central", "forward"), centralDerivEps = rep(20 *
        sqrt(.Machine$double.eps), 2), lbfgsLmm = 7L, lbfgsPgtol = 0,
    lbfgsFactr = NULL, eigen = TRUE, addPosthoc = TRUE, diagXform = c("sqrt",
        "log", "identity"), sumProd = FALSE, optExpression = TRUE,
    ci = 0.95, useColor = crayon::has_color(), boundTol = NULL,
    calcTables = TRUE, noAbort = TRUE, interaction = TRUE, cholSEtol = (.Machine$double.eps)^(1/3),
    cholAccept = 0.001, resetEtaP = 0.15, resetThetaP = 0.05,
    resetThetaFinalP = 0.15, diagOmegaBoundUpper = 5, diagOmegaBoundLower = 100,
    cholSEOpt = FALSE, cholSECov = FALSE, fo = FALSE, covTryHarder = FALSE,
    outerOpt = c("nlminb", "bobyqa", "lbfgsb3c", "L-BFGS-B",
        "mma", "lbfgsbLG", "slsqp", "Rvmmin"), innerOpt = c("n1qn1",
        "BFGS"), rhobeg = 0.2, rhoend = NULL, npt = NULL, rel.tol = NULL,
    x.tol = NULL, eval.max = 4000, iter.max = 2000, abstol = NULL,
    reltol = NULL, resetHessianAndEta = FALSE, stateTrim = Inf,
    shi21maxOuter = 0L, shi21maxInner = 20L, shi21maxInnerCov = 20L,
    shi21maxFD = 20L, gillK = 10L, gillStep = 4, gillFtol = 0,
    gillRtol = sqrt(.Machine$double.eps), gillKcov = 10L, gillKcovLlik = 10L,
    gillStepCovLlik = 4.5, gillStepCov = 2, gillFtolCov = 0,
    gillFtolCovLlik = 0, rmatNorm = TRUE, rmatNormLlik = TRUE,
    smatNorm = TRUE, smatNormLlik = TRUE, covGillF = TRUE, optGillF = TRUE,
    covSmall = 1e-05, adjLik = TRUE, gradTrim = Inf, maxOdeRecalc = 5,
    odeRecalcFactor = 10^(0.5), gradCalcCentralSmall = 1e-04,
    gradCalcCentralLarge = 10000, etaNudge = qnorm(1 - 0.05/2)/sqrt(3),
    etaNudge2 = qnorm(1 - 0.05/2) * sqrt(3/5), nRetries = 3,
    seed = 42, resetThetaCheckPer = 0.1, etaMat = NULL, repeatGillMax = 1,
    stickyRecalcN = 4, gradProgressOfvTime = 10, addProp = c("combined2",
        "combined1"), badSolveObjfAdj = 100, compress = TRUE,
    rxControl = NULL, sigdigTable = NULL, fallbackFD = FALSE,
    smatPer = 0.6) { # nocov start
    nlmixr2est::foceiControl(sigdig = sigdig, ..., epsilon = epsilon,
        maxInnerIterations = maxInnerIterations, maxOuterIterations = maxOuterIterations,
        n1qn1nsim = n1qn1nsim, print = print, printNcol = printNcol,
        scaleTo = scaleTo, scaleObjective = scaleObjective, normType = normType,
        scaleType = scaleType, scaleCmax = scaleCmax, scaleCmin = scaleCmin,
        scaleC = scaleC, scaleC0 = scaleC0, derivEps = derivEps,
        derivMethod = derivMethod, derivSwitchTol = derivSwitchTol,
        covDerivMethod = covDerivMethod, covMethod = covMethod,
        hessEps = hessEps, hessEpsLlik = hessEpsLlik, optimHessType = optimHessType,
        optimHessCovType = optimHessCovType, eventType = eventType,
        centralDerivEps = centralDerivEps, lbfgsLmm = lbfgsLmm,
        lbfgsPgtol = lbfgsPgtol, lbfgsFactr = lbfgsFactr, eigen = eigen,
        addPosthoc = addPosthoc, diagXform = diagXform, sumProd = sumProd,
        optExpression = optExpression, ci = ci, useColor = useColor,
        boundTol = boundTol, calcTables = calcTables, noAbort = noAbort,
        interaction = interaction, cholSEtol = cholSEtol, cholAccept = cholAccept,
        resetEtaP = resetEtaP, resetThetaP = resetThetaP, resetThetaFinalP = resetThetaFinalP,
        diagOmegaBoundUpper = diagOmegaBoundUpper, diagOmegaBoundLower = diagOmegaBoundLower,
        cholSEOpt = cholSEOpt, cholSECov = cholSECov, fo = fo,
        covTryHarder = covTryHarder, outerOpt = outerOpt, innerOpt = innerOpt,
        rhobeg = rhobeg, rhoend = rhoend, npt = npt, rel.tol = rel.tol,
        x.tol = x.tol, eval.max = eval.max, iter.max = iter.max,
        abstol = abstol, reltol = reltol, resetHessianAndEta = resetHessianAndEta,
        stateTrim = stateTrim, shi21maxOuter = shi21maxOuter,
        shi21maxInner = shi21maxInner, shi21maxInnerCov = shi21maxInnerCov,
        shi21maxFD = shi21maxFD, gillK = gillK, gillStep = gillStep,
        gillFtol = gillFtol, gillRtol = gillRtol, gillKcov = gillKcov,
        gillKcovLlik = gillKcovLlik, gillStepCovLlik = gillStepCovLlik,
        gillStepCov = gillStepCov, gillFtolCov = gillFtolCov,
        gillFtolCovLlik = gillFtolCovLlik, rmatNorm = rmatNorm,
        rmatNormLlik = rmatNormLlik, smatNorm = smatNorm, smatNormLlik = smatNormLlik,
        covGillF = covGillF, optGillF = optGillF, covSmall = covSmall,
        adjLik = adjLik, gradTrim = gradTrim, maxOdeRecalc = maxOdeRecalc,
        odeRecalcFactor = odeRecalcFactor, gradCalcCentralSmall = gradCalcCentralSmall,
        gradCalcCentralLarge = gradCalcCentralLarge, etaNudge = etaNudge,
        etaNudge2 = etaNudge2, nRetries = nRetries, seed = seed,
        resetThetaCheckPer = resetThetaCheckPer, etaMat = etaMat,
        repeatGillMax = repeatGillMax, stickyRecalcN = stickyRecalcN,
        gradProgressOfvTime = gradProgressOfvTime, addProp = addProp,
        badSolveObjfAdj = badSolveObjfAdj, compress = compress,
        rxControl = rxControl, sigdigTable = sigdigTable, fallbackFD = fallbackFD,
        smatPer = smatPer)
} # nocov end

#' @inherit nlmixr2est::nlmeControl
#' @param ... Additional arguments passed to [nlmixr2est::nlmeControl()].
#' @export
nlmeControl <- function(maxIter = 100, pnlsMaxIter = 100, msMaxIter = 100,
    minScale = 0.001, tolerance = 1e-05, niterEM = 25, pnlsTol = 0.001,
    msTol = 1e-06, returnObject = FALSE, msVerbose = FALSE, msWarnNoConv = TRUE,
    gradHess = TRUE, apVar = TRUE, .relStep = .Machine$double.eps^(1/3),
    minAbsParApVar = 0.05, opt = c("nlminb", "nlm"), natural = TRUE,
    sigma = NULL, optExpression = TRUE, sumProd = FALSE, rxControl = NULL,
    method = c("ML", "REML"), random = NULL, fixed = NULL, weights = NULL,
    verbose = TRUE, returnNlme = FALSE, addProp = c("combined2",
        "combined1"), calcTables = TRUE, compress = TRUE, adjObf = TRUE,
    ci = 0.95, sigdig = 4, sigdigTable = NULL, ...) { # nocov start
    nlmixr2est::nlmeControl(maxIter = maxIter, pnlsMaxIter = pnlsMaxIter,
        msMaxIter = msMaxIter, minScale = minScale, tolerance = tolerance,
        niterEM = niterEM, pnlsTol = pnlsTol, msTol = msTol,
        returnObject = returnObject, msVerbose = msVerbose, msWarnNoConv = msWarnNoConv,
        gradHess = gradHess, apVar = apVar, .relStep = .relStep,
        minAbsParApVar = minAbsParApVar, opt = opt, natural = natural,
        sigma = sigma, optExpression = optExpression, sumProd = sumProd,
        rxControl = rxControl, method = method, random = random,
        fixed = fixed, weights = weights, verbose = verbose,
        returnNlme = returnNlme, addProp = addProp, calcTables = calcTables,
        compress = compress, adjObf = adjObf, ci = ci, sigdig = sigdig,
        sigdigTable = sigdigTable, ...)
} # nocov end

#' @inherit nlmixr2est::tableControl
#' @export
tableControl <- function(npde = NULL, cwres = NULL, nsim = 300,
    ties = TRUE, censMethod = c("truncated-normal", "cdf", "ipred",
        "pred", "epred", "omit"), seed = 1009, cholSEtol = (.Machine$double.eps)^(1/3),
    state = TRUE, lhs = TRUE, eta = TRUE, covariates = TRUE,
    addDosing = FALSE, subsetNonmem = TRUE, cores = NULL, keep = NULL,
    drop = NULL) { # nocov start
    nlmixr2est::tableControl(npde = npde, cwres = cwres, nsim = nsim,
        ties = ties, censMethod = censMethod, seed = seed, cholSEtol = cholSEtol,
        state = state, lhs = lhs, eta = eta, covariates = covariates,
        addDosing = addDosing, subsetNonmem = subsetNonmem, cores = cores,
        keep = keep, drop = drop)
} # nocov end

#' @inherit nlmixr2est::addCwres
#' @export
addCwres <- function(fit, focei = TRUE, updateObject = TRUE,
    envir = parent.frame(1)) { # nocov start
    nlmixr2est::addCwres(fit = fit, focei = focei, updateObject = updateObject,
        envir = envir)
} # nocov end

#' @inherit nlmixr2est::addNpde
#' @param ... Additional arguments passed to [nlmixr2est::addNpde()].
#' @export
addNpde <- function(object, updateObject = TRUE, table = tableControl(),
    ..., envir = parent.frame(1)) { # nocov start
    nlmixr2est::addNpde(object = object, updateObject = updateObject,
        table = table, ..., envir = envir)
} # nocov end

#' @inherit nlmixr2est::addTable
#' @export
addTable <- function(object, updateObject = FALSE, data = object$dataSav,
    thetaEtaParameters = object$foceiThetaEtaParameters, table = tableControl(),
    keep = NULL, drop = NULL, envir = parent.frame(1)) { # nocov start
    nlmixr2est::addTable(object = object, updateObject = updateObject,
        data = data, thetaEtaParameters = thetaEtaParameters,
        table = table, keep = keep, drop = drop, envir = envir)
} # nocov end

#' @inherit nlmixr2est::setOfv
#' @export
setOfv <- function(x, type) { # nocov start
    nlmixr2est::setOfv(x = x, type = type)
} # nocov end

#' @inherit nlmixr2extra::preconditionFit
#' @export
preconditionFit <- function(fit, estType = c("full", "posthoc",
    "none"), ntry = 10L) { # nocov start
    nlmixr2extra::preconditionFit(fit = fit, estType = estType,
        ntry = ntry)
} # nocov end

#' @inherit nlmixr2extra::bootstrapFit
#' @export
bootstrapFit <- function(fit, nboot = 200, nSampIndiv, stratVar,
    stdErrType = c("perc", "se"), ci = 0.95, pvalues = NULL,
    restart = FALSE, plotHist = FALSE, fitName = as.character(substitute(fit))) { # nocov start
    nlmixr2extra::bootstrapFit(fit = fit, nboot = nboot, nSampIndiv = nSampIndiv,
        stratVar = stratVar, stdErrType = stdErrType, ci = ci,
        pvalues = pvalues, restart = restart, plotHist = plotHist,
        fitName = fitName)
} # nocov end

#' @inherit nlmixr2extra::covarSearchAuto
#' @export
covarSearchAuto <- function(fit, varsVec, covarsVec, pVal = list(fwd = 0.05,
    bck = 0.01), catvarsVec = NULL, searchType = c("scm", "forward",
    "backward"), restart = FALSE) { # nocov start
    nlmixr2extra::covarSearchAuto(fit = fit, varsVec = varsVec,
        covarsVec = covarsVec, pVal = pVal, catvarsVec = catvarsVec,
        searchType = searchType, restart = restart)
} # nocov end

#' @inherit nlmixr2extra::bootplot
#' @param ... Additional arguments passed to [nlmixr2extra::bootplot()].
#' @export
bootplot <- function(x, ...) { # nocov start
    nlmixr2extra::bootplot(x = x, ...)
} # nocov end
