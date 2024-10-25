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
    seed = 1009, nretry = 50, minN = 10, normRelated = TRUE) { # nocov start
    nlmixr2est::vpcSim(object = object, ..., keep = keep, n = n,
        pred = pred, seed = seed, nretry = nretry, minN = minN,
        normRelated = normRelated)
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
    nnodesGq = 3, nsdGq = 1.6, optExpression = TRUE, literalFix = TRUE,
    adjObf = TRUE, sumProd = FALSE, addProp = c("combined2",
        "combined1"), tol = 1e-06, itmax = 30, type = c("nelder-mead",
        "newuoa"), powRange = 10, lambdaRange = 3, odeRecalcFactor = 10^(0.5),
    maxOdeRecalc = 5L, perSa = 0.75, perNoCor = 0.75, perFixOmega = 0.1,
    perFixResid = 0.1, compress = TRUE, rxControl = NULL, sigdig = NULL,
    sigdigTable = NULL, ci = 0.95, muRefCov = TRUE, muRefCovAlg = TRUE,
    handleUninformativeEtas = TRUE, ...) { # nocov start
    nlmixr2est::saemControl(seed = seed, nBurn = nBurn, nEm = nEm,
        nmc = nmc, nu = nu, print = print, trace = trace, covMethod = covMethod,
        calcTables = calcTables, logLik = logLik, nnodesGq = nnodesGq,
        nsdGq = nsdGq, optExpression = optExpression, literalFix = literalFix,
        adjObf = adjObf, sumProd = sumProd, addProp = addProp,
        tol = tol, itmax = itmax, type = type, powRange = powRange,
        lambdaRange = lambdaRange, odeRecalcFactor = odeRecalcFactor,
        maxOdeRecalc = maxOdeRecalc, perSa = perSa, perNoCor = perNoCor,
        perFixOmega = perFixOmega, perFixResid = perFixResid,
        compress = compress, rxControl = rxControl, sigdig = sigdig,
        sigdigTable = sigdigTable, ci = ci, muRefCov = muRefCov,
        muRefCovAlg = muRefCovAlg, handleUninformativeEtas = handleUninformativeEtas,
        ...)
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
    literalFix = TRUE, ci = 0.95, useColor = crayon::has_color(),
    boundTol = NULL, calcTables = TRUE, noAbort = TRUE, interaction = TRUE,
    cholSEtol = (.Machine$double.eps)^(1/3), cholAccept = 0.001,
    resetEtaP = 0.15, resetThetaP = 0.05, resetThetaFinalP = 0.15,
    diagOmegaBoundUpper = 5, diagOmegaBoundLower = 100, cholSEOpt = FALSE,
    cholSECov = FALSE, fo = FALSE, covTryHarder = FALSE, outerOpt = c("nlminb",
        "bobyqa", "lbfgsb3c", "L-BFGS-B", "mma", "lbfgsbLG",
        "slsqp", "Rvmmin"), innerOpt = c("n1qn1", "BFGS"), rhobeg = 0.2,
    rhoend = NULL, npt = NULL, rel.tol = NULL, x.tol = NULL,
    eval.max = 4000, iter.max = 2000, abstol = NULL, reltol = NULL,
    resetHessianAndEta = FALSE, stateTrim = Inf, shi21maxOuter = 0L,
    shi21maxInner = 20L, shi21maxInnerCov = 20L, shi21maxFD = 20L,
    gillK = 10L, gillStep = 4, gillFtol = 0, gillRtol = sqrt(.Machine$double.eps),
    gillKcov = 10L, gillKcovLlik = 10L, gillStepCovLlik = 4.5,
    gillStepCov = 2, gillFtolCov = 0, gillFtolCovLlik = 0, rmatNorm = TRUE,
    rmatNormLlik = TRUE, smatNorm = TRUE, smatNormLlik = TRUE,
    covGillF = TRUE, optGillF = TRUE, covSmall = 1e-05, adjLik = TRUE,
    gradTrim = Inf, maxOdeRecalc = 5, odeRecalcFactor = 10^(0.5),
    gradCalcCentralSmall = 1e-04, gradCalcCentralLarge = 10000,
    etaNudge = qnorm(1 - 0.05/2)/sqrt(3), etaNudge2 = qnorm(1 -
        0.05/2) * sqrt(3/5), nRetries = 3, seed = 42, resetThetaCheckPer = 0.1,
    etaMat = NULL, repeatGillMax = 1, stickyRecalcN = 4, gradProgressOfvTime = 10,
    addProp = c("combined2", "combined1"), badSolveObjfAdj = 100,
    compress = TRUE, rxControl = NULL, sigdigTable = NULL, fallbackFD = FALSE,
    smatPer = 0.6, sdLowerFact = 0.001, zeroGradFirstReset = TRUE,
    zeroGradRunReset = TRUE, zeroGradBobyqa = TRUE) { # nocov start
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
        optExpression = optExpression, literalFix = literalFix,
        ci = ci, useColor = useColor, boundTol = boundTol, calcTables = calcTables,
        noAbort = noAbort, interaction = interaction, cholSEtol = cholSEtol,
        cholAccept = cholAccept, resetEtaP = resetEtaP, resetThetaP = resetThetaP,
        resetThetaFinalP = resetThetaFinalP, diagOmegaBoundUpper = diagOmegaBoundUpper,
        diagOmegaBoundLower = diagOmegaBoundLower, cholSEOpt = cholSEOpt,
        cholSECov = cholSECov, fo = fo, covTryHarder = covTryHarder,
        outerOpt = outerOpt, innerOpt = innerOpt, rhobeg = rhobeg,
        rhoend = rhoend, npt = npt, rel.tol = rel.tol, x.tol = x.tol,
        eval.max = eval.max, iter.max = iter.max, abstol = abstol,
        reltol = reltol, resetHessianAndEta = resetHessianAndEta,
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
        smatPer = smatPer, sdLowerFact = sdLowerFact, zeroGradFirstReset = zeroGradFirstReset,
        zeroGradRunReset = zeroGradRunReset, zeroGradBobyqa = zeroGradBobyqa)
} # nocov end

#' @inherit nlmixr2est::nlmeControl
#' @param ... Additional arguments passed to [nlmixr2est::nlmeControl()].
#' @export
nlmeControl <- function(maxIter = 100, pnlsMaxIter = 100, msMaxIter = 100,
    minScale = 0.001, tolerance = 1e-05, niterEM = 25, pnlsTol = 0.001,
    msTol = 1e-06, returnObject = FALSE, msVerbose = FALSE, msWarnNoConv = TRUE,
    gradHess = TRUE, apVar = TRUE, .relStep = .Machine$double.eps^(1/3),
    minAbsParApVar = 0.05, opt = c("nlminb", "nlm"), natural = TRUE,
    sigma = NULL, optExpression = TRUE, literalFix = TRUE, sumProd = FALSE,
    rxControl = NULL, method = c("ML", "REML"), random = NULL,
    fixed = NULL, weights = NULL, verbose = TRUE, returnNlme = FALSE,
    addProp = c("combined2", "combined1"), calcTables = TRUE,
    compress = TRUE, adjObf = TRUE, ci = 0.95, sigdig = 4, sigdigTable = NULL,
    muRefCovAlg = TRUE, ...) { # nocov start
    nlmixr2est::nlmeControl(maxIter = maxIter, pnlsMaxIter = pnlsMaxIter,
        msMaxIter = msMaxIter, minScale = minScale, tolerance = tolerance,
        niterEM = niterEM, pnlsTol = pnlsTol, msTol = msTol,
        returnObject = returnObject, msVerbose = msVerbose, msWarnNoConv = msWarnNoConv,
        gradHess = gradHess, apVar = apVar, .relStep = .relStep,
        minAbsParApVar = minAbsParApVar, opt = opt, natural = natural,
        sigma = sigma, optExpression = optExpression, literalFix = literalFix,
        sumProd = sumProd, rxControl = rxControl, method = method,
        random = random, fixed = fixed, weights = weights, verbose = verbose,
        returnNlme = returnNlme, addProp = addProp, calcTables = calcTables,
        compress = compress, adjObf = adjObf, ci = ci, sigdig = sigdig,
        sigdigTable = sigdigTable, muRefCovAlg = muRefCovAlg,
        ...)
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

#' @inherit nlmixr2est::bobyqaControl
#' @param ... Additional arguments passed to [nlmixr2est::bobyqaControl()].
#' @export
bobyqaControl <- function(npt = NULL, rhobeg = NULL, rhoend = NULL,
    iprint = 0L, maxfun = 100000L, returnBobyqa = FALSE, stickyRecalcN = 4,
    maxOdeRecalc = 5, odeRecalcFactor = 10^(0.5), useColor = crayon::has_color(),
    printNcol = floor((getOption("width") - 23)/12), print = 1L,
    normType = c("rescale2", "mean", "rescale", "std", "len",
        "constant"), scaleType = c("nlmixr2", "norm", "mult",
        "multAdd"), scaleCmax = 1e+05, scaleCmin = 1e-05, scaleC = NULL,
    scaleTo = 1, rxControl = NULL, optExpression = TRUE, sumProd = FALSE,
    literalFix = TRUE, addProp = c("combined2", "combined1"),
    calcTables = TRUE, compress = TRUE, covMethod = c("r", ""),
    adjObf = TRUE, ci = 0.95, sigdig = 4, sigdigTable = NULL,
    ...) { # nocov start
    nlmixr2est::bobyqaControl(npt = npt, rhobeg = rhobeg, rhoend = rhoend,
        iprint = iprint, maxfun = maxfun, returnBobyqa = returnBobyqa,
        stickyRecalcN = stickyRecalcN, maxOdeRecalc = maxOdeRecalc,
        odeRecalcFactor = odeRecalcFactor, useColor = useColor,
        printNcol = printNcol, print = print, normType = normType,
        scaleType = scaleType, scaleCmax = scaleCmax, scaleCmin = scaleCmin,
        scaleC = scaleC, scaleTo = scaleTo, rxControl = rxControl,
        optExpression = optExpression, sumProd = sumProd, literalFix = literalFix,
        addProp = addProp, calcTables = calcTables, compress = compress,
        covMethod = covMethod, adjObf = adjObf, ci = ci, sigdig = sigdig,
        sigdigTable = sigdigTable, ...)
} # nocov end

#' @inherit nlmixr2est::lbfgsb3cControl
#' @param ... Additional arguments passed to [nlmixr2est::lbfgsb3cControl()].
#' @export
lbfgsb3cControl <- function(trace = 0, factr = 1e+07, pgtol = 0,
    abstol = 0, reltol = 0, lmm = 5L, maxit = 10000L, returnLbfgsb3c = FALSE,
    stickyRecalcN = 4, maxOdeRecalc = 5, odeRecalcFactor = 10^(0.5),
    useColor = crayon::has_color(), printNcol = floor((getOption("width") -
        23)/12), print = 1L, normType = c("rescale2", "mean",
        "rescale", "std", "len", "constant"), scaleType = c("nlmixr2",
        "norm", "mult", "multAdd"), scaleCmax = 1e+05, scaleCmin = 1e-05,
    scaleC = NULL, scaleTo = 1, gradTo = 1, rxControl = NULL,
    optExpression = TRUE, sumProd = FALSE, literalFix = TRUE,
    addProp = c("combined2", "combined1"), calcTables = TRUE,
    compress = TRUE, covMethod = c("r", ""), adjObf = TRUE, ci = 0.95,
    sigdig = 4, sigdigTable = NULL, ...) { # nocov start
    nlmixr2est::lbfgsb3cControl(trace = trace, factr = factr,
        pgtol = pgtol, abstol = abstol, reltol = reltol, lmm = lmm,
        maxit = maxit, returnLbfgsb3c = returnLbfgsb3c, stickyRecalcN = stickyRecalcN,
        maxOdeRecalc = maxOdeRecalc, odeRecalcFactor = odeRecalcFactor,
        useColor = useColor, printNcol = printNcol, print = print,
        normType = normType, scaleType = scaleType, scaleCmax = scaleCmax,
        scaleCmin = scaleCmin, scaleC = scaleC, scaleTo = scaleTo,
        gradTo = gradTo, rxControl = rxControl, optExpression = optExpression,
        sumProd = sumProd, literalFix = literalFix, addProp = addProp,
        calcTables = calcTables, compress = compress, covMethod = covMethod,
        adjObf = adjObf, ci = ci, sigdig = sigdig, sigdigTable = sigdigTable,
        ...)
} # nocov end

#' @inherit nlmixr2est::n1qn1Control
#' @param ... Additional arguments passed to [nlmixr2est::n1qn1Control()].
#' @export
n1qn1Control <- function(epsilon = (.Machine$double.eps)^0.25,
    max_iterations = 10000, nsim = 10000, imp = 0, print.functions = FALSE,
    returnN1qn1 = FALSE, stickyRecalcN = 4, maxOdeRecalc = 5,
    odeRecalcFactor = 10^(0.5), useColor = crayon::has_color(),
    printNcol = floor((getOption("width") - 23)/12), print = 1L,
    normType = c("rescale2", "mean", "rescale", "std", "len",
        "constant"), scaleType = c("nlmixr2", "norm", "mult",
        "multAdd"), scaleCmax = 1e+05, scaleCmin = 1e-05, scaleC = NULL,
    scaleTo = 1, gradTo = 1, rxControl = NULL, optExpression = TRUE,
    sumProd = FALSE, literalFix = TRUE, addProp = c("combined2",
        "combined1"), calcTables = TRUE, compress = TRUE, covMethod = c("r",
        "n1qn1", ""), adjObf = TRUE, ci = 0.95, sigdig = 4, sigdigTable = NULL,
    ...) { # nocov start
    nlmixr2est::n1qn1Control(epsilon = epsilon, max_iterations = max_iterations,
        nsim = nsim, imp = imp, print.functions = print.functions,
        returnN1qn1 = returnN1qn1, stickyRecalcN = stickyRecalcN,
        maxOdeRecalc = maxOdeRecalc, odeRecalcFactor = odeRecalcFactor,
        useColor = useColor, printNcol = printNcol, print = print,
        normType = normType, scaleType = scaleType, scaleCmax = scaleCmax,
        scaleCmin = scaleCmin, scaleC = scaleC, scaleTo = scaleTo,
        gradTo = gradTo, rxControl = rxControl, optExpression = optExpression,
        sumProd = sumProd, literalFix = literalFix, addProp = addProp,
        calcTables = calcTables, compress = compress, covMethod = covMethod,
        adjObf = adjObf, ci = ci, sigdig = sigdig, sigdigTable = sigdigTable,
        ...)
} # nocov end

#' @inherit nlmixr2est::newuoaControl
#' @param ... Additional arguments passed to [nlmixr2est::newuoaControl()].
#' @export
newuoaControl <- function(npt = NULL, rhobeg = NULL, rhoend = NULL,
    iprint = 0L, maxfun = 100000L, returnNewuoa = FALSE, stickyRecalcN = 4,
    maxOdeRecalc = 5, odeRecalcFactor = 10^(0.5), useColor = crayon::has_color(),
    printNcol = floor((getOption("width") - 23)/12), print = 1L,
    normType = c("rescale2", "mean", "rescale", "std", "len",
        "constant"), scaleType = c("nlmixr2", "norm", "mult",
        "multAdd"), scaleCmax = 1e+05, scaleCmin = 1e-05, scaleC = NULL,
    scaleTo = 1, rxControl = NULL, optExpression = TRUE, sumProd = FALSE,
    literalFix = TRUE, addProp = c("combined2", "combined1"),
    calcTables = TRUE, compress = TRUE, covMethod = c("r", ""),
    adjObf = TRUE, ci = 0.95, sigdig = 4, sigdigTable = NULL,
    ...) { # nocov start
    nlmixr2est::newuoaControl(npt = npt, rhobeg = rhobeg, rhoend = rhoend,
        iprint = iprint, maxfun = maxfun, returnNewuoa = returnNewuoa,
        stickyRecalcN = stickyRecalcN, maxOdeRecalc = maxOdeRecalc,
        odeRecalcFactor = odeRecalcFactor, useColor = useColor,
        printNcol = printNcol, print = print, normType = normType,
        scaleType = scaleType, scaleCmax = scaleCmax, scaleCmin = scaleCmin,
        scaleC = scaleC, scaleTo = scaleTo, rxControl = rxControl,
        optExpression = optExpression, sumProd = sumProd, literalFix = literalFix,
        addProp = addProp, calcTables = calcTables, compress = compress,
        covMethod = covMethod, adjObf = adjObf, ci = ci, sigdig = sigdig,
        sigdigTable = sigdigTable, ...)
} # nocov end

#' @inherit nlmixr2est::nlmControl
#' @param ... Additional arguments passed to [nlmixr2est::nlmControl()].
#' @export
nlmControl <- function(typsize = NULL, fscale = 1, print.level = 0,
    ndigit = NULL, gradtol = 1e-06, stepmax = NULL, steptol = 1e-06,
    iterlim = 10000, check.analyticals = FALSE, returnNlm = FALSE,
    solveType = c("hessian", "grad", "fun"), stickyRecalcN = 4,
    maxOdeRecalc = 5, odeRecalcFactor = 10^(0.5), eventType = c("central",
        "forward"), shiErr = (.Machine$double.eps)^(1/3), shi21maxFD = 20L,
    optimHessType = c("central", "forward"), hessErr = (.Machine$double.eps)^(1/3),
    shi21maxHess = 20L, useColor = crayon::has_color(), printNcol = floor((getOption("width") -
        23)/12), print = 1L, normType = c("rescale2", "mean",
        "rescale", "std", "len", "constant"), scaleType = c("nlmixr2",
        "norm", "mult", "multAdd"), scaleCmax = 1e+05, scaleCmin = 1e-05,
    scaleC = NULL, scaleTo = 1, gradTo = 1, rxControl = NULL,
    optExpression = TRUE, sumProd = FALSE, literalFix = TRUE,
    addProp = c("combined2", "combined1"), calcTables = TRUE,
    compress = TRUE, covMethod = c("r", "nlm", ""), adjObf = TRUE,
    ci = 0.95, sigdig = 4, sigdigTable = NULL, ...) { # nocov start
    nlmixr2est::nlmControl(typsize = typsize, fscale = fscale,
        print.level = print.level, ndigit = ndigit, gradtol = gradtol,
        stepmax = stepmax, steptol = steptol, iterlim = iterlim,
        check.analyticals = check.analyticals, returnNlm = returnNlm,
        solveType = solveType, stickyRecalcN = stickyRecalcN,
        maxOdeRecalc = maxOdeRecalc, odeRecalcFactor = odeRecalcFactor,
        eventType = eventType, shiErr = shiErr, shi21maxFD = shi21maxFD,
        optimHessType = optimHessType, hessErr = hessErr, shi21maxHess = shi21maxHess,
        useColor = useColor, printNcol = printNcol, print = print,
        normType = normType, scaleType = scaleType, scaleCmax = scaleCmax,
        scaleCmin = scaleCmin, scaleC = scaleC, scaleTo = scaleTo,
        gradTo = gradTo, rxControl = rxControl, optExpression = optExpression,
        sumProd = sumProd, literalFix = literalFix, addProp = addProp,
        calcTables = calcTables, compress = compress, covMethod = covMethod,
        adjObf = adjObf, ci = ci, sigdig = sigdig, sigdigTable = sigdigTable,
        ...)
} # nocov end

#' @inherit nlmixr2est::nlminbControl
#' @param ... Additional arguments passed to [nlmixr2est::nlminbControl()].
#' @export
nlminbControl <- function(eval.max = 200, iter.max = 150, trace = 0,
    abs.tol = 0, rel.tol = 1e-10, x.tol = 1.5e-08, xf.tol = 2.2e-14,
    step.min = 1, step.max = 1, sing.tol = rel.tol, scale = 1,
    scale.init = NULL, diff.g = NULL, rxControl = NULL, optExpression = TRUE,
    sumProd = FALSE, literalFix = TRUE, returnNlminb = FALSE,
    solveType = c("hessian", "grad", "fun"), stickyRecalcN = 4,
    maxOdeRecalc = 5, odeRecalcFactor = 10^(0.5), eventType = c("central",
        "forward"), shiErr = (.Machine$double.eps)^(1/3), shi21maxFD = 20L,
    optimHessType = c("central", "forward"), hessErr = (.Machine$double.eps)^(1/3),
    shi21maxHess = 20L, useColor = crayon::has_color(), printNcol = floor((getOption("width") -
        23)/12), print = 1L, normType = c("rescale2", "mean",
        "rescale", "std", "len", "constant"), scaleType = c("nlmixr2",
        "norm", "mult", "multAdd"), scaleCmax = 1e+05, scaleCmin = 1e-05,
    scaleC = NULL, scaleTo = 1, gradTo = 1, addProp = c("combined2",
        "combined1"), calcTables = TRUE, compress = TRUE, covMethod = c("r",
        "nlminb", ""), adjObf = TRUE, ci = 0.95, sigdig = 4,
    sigdigTable = NULL, ...) { # nocov start
    nlmixr2est::nlminbControl(eval.max = eval.max, iter.max = iter.max,
        trace = trace, abs.tol = abs.tol, rel.tol = rel.tol,
        x.tol = x.tol, xf.tol = xf.tol, step.min = step.min,
        step.max = step.max, sing.tol = sing.tol, scale = scale,
        scale.init = scale.init, diff.g = diff.g, rxControl = rxControl,
        optExpression = optExpression, sumProd = sumProd, literalFix = literalFix,
        returnNlminb = returnNlminb, solveType = solveType, stickyRecalcN = stickyRecalcN,
        maxOdeRecalc = maxOdeRecalc, odeRecalcFactor = odeRecalcFactor,
        eventType = eventType, shiErr = shiErr, shi21maxFD = shi21maxFD,
        optimHessType = optimHessType, hessErr = hessErr, shi21maxHess = shi21maxHess,
        useColor = useColor, printNcol = printNcol, print = print,
        normType = normType, scaleType = scaleType, scaleCmax = scaleCmax,
        scaleCmin = scaleCmin, scaleC = scaleC, scaleTo = scaleTo,
        gradTo = gradTo, addProp = addProp, calcTables = calcTables,
        compress = compress, covMethod = covMethod, adjObf = adjObf,
        ci = ci, sigdig = sigdig, sigdigTable = sigdigTable,
        ...)
} # nocov end

#' @inherit nlmixr2est::nlsControl
#' @param ... Additional arguments passed to [nlmixr2est::nlsControl()].
#' @export
nlsControl <- function(maxiter = 10000, tol = 1e-05, minFactor = 1/1024,
    printEval = FALSE, warnOnly = FALSE, scaleOffset = 0, nDcentral = FALSE,
    algorithm = c("LM", "default", "plinear", "port"), ftol = sqrt(.Machine$double.eps),
    ptol = sqrt(.Machine$double.eps), gtol = 0, diag = list(),
    epsfcn = 0, factor = 100, maxfev = integer(), nprint = 0,
    solveType = c("grad", "fun"), stickyRecalcN = 4, maxOdeRecalc = 5,
    odeRecalcFactor = 10^(0.5), eventType = c("central", "forward"),
    shiErr = (.Machine$double.eps)^(1/3), shi21maxFD = 20L, useColor = crayon::has_color(),
    printNcol = floor((getOption("width") - 23)/12), print = 1L,
    normType = c("rescale2", "mean", "rescale", "std", "len",
        "constant"), scaleType = c("nlmixr2", "norm", "mult",
        "multAdd"), scaleCmax = 1e+05, scaleCmin = 1e-05, scaleC = NULL,
    scaleTo = 1, gradTo = 1, trace = FALSE, rxControl = NULL,
    optExpression = TRUE, sumProd = FALSE, literalFix = TRUE,
    returnNls = FALSE, addProp = c("combined2", "combined1"),
    calcTables = TRUE, compress = TRUE, adjObf = TRUE, ci = 0.95,
    sigdig = 4, sigdigTable = NULL, ...) { # nocov start
    nlmixr2est::nlsControl(maxiter = maxiter, tol = tol, minFactor = minFactor,
        printEval = printEval, warnOnly = warnOnly, scaleOffset = scaleOffset,
        nDcentral = nDcentral, algorithm = algorithm, ftol = ftol,
        ptol = ptol, gtol = gtol, diag = diag, epsfcn = epsfcn,
        factor = factor, maxfev = maxfev, nprint = nprint, solveType = solveType,
        stickyRecalcN = stickyRecalcN, maxOdeRecalc = maxOdeRecalc,
        odeRecalcFactor = odeRecalcFactor, eventType = eventType,
        shiErr = shiErr, shi21maxFD = shi21maxFD, useColor = useColor,
        printNcol = printNcol, print = print, normType = normType,
        scaleType = scaleType, scaleCmax = scaleCmax, scaleCmin = scaleCmin,
        scaleC = scaleC, scaleTo = scaleTo, gradTo = gradTo,
        trace = trace, rxControl = rxControl, optExpression = optExpression,
        sumProd = sumProd, literalFix = literalFix, returnNls = returnNls,
        addProp = addProp, calcTables = calcTables, compress = compress,
        adjObf = adjObf, ci = ci, sigdig = sigdig, sigdigTable = sigdigTable,
        ...)
} # nocov end

#' @inherit nlmixr2est::optimControl
#' @param ... Additional arguments passed to [nlmixr2est::optimControl()].
#' @export
optimControl <- function(method = c("Nelder-Mead", "BFGS", "CG",
    "L-BFGS-B", "SANN", "Brent"), trace = 0, fnscale = 1, parscale = 1,
    ndeps = 0.001, maxit = 10000, abstol = 1e-08, reltol = 1e-08,
    alpha = 1, beta = 0.5, gamma = 2, REPORT = NULL, warn.1d.NelderMead = TRUE,
    type = NULL, lmm = 5, factr = 1e+07, pgtol = 0, temp = 10,
    tmax = 10, stickyRecalcN = 4, maxOdeRecalc = 5, odeRecalcFactor = 10^(0.5),
    eventType = c("central", "forward"), shiErr = (.Machine$double.eps)^(1/3),
    shi21maxFD = 20L, solveType = c("grad", "fun"), useColor = crayon::has_color(),
    printNcol = floor((getOption("width") - 23)/12), print = 1L,
    normType = c("rescale2", "mean", "rescale", "std", "len",
        "constant"), scaleType = c("nlmixr2", "norm", "mult",
        "multAdd"), scaleCmax = 1e+05, scaleCmin = 1e-05, scaleC = NULL,
    scaleTo = 1, gradTo = 1, rxControl = NULL, optExpression = TRUE,
    sumProd = FALSE, literalFix = TRUE, returnOptim = FALSE,
    addProp = c("combined2", "combined1"), calcTables = TRUE,
    compress = TRUE, covMethod = c("r", "optim", ""), adjObf = TRUE,
    ci = 0.95, sigdig = 4, sigdigTable = NULL, ...) { # nocov start
    nlmixr2est::optimControl(method = method, trace = trace,
        fnscale = fnscale, parscale = parscale, ndeps = ndeps,
        maxit = maxit, abstol = abstol, reltol = reltol, alpha = alpha,
        beta = beta, gamma = gamma, REPORT = REPORT, warn.1d.NelderMead = warn.1d.NelderMead,
        type = type, lmm = lmm, factr = factr, pgtol = pgtol,
        temp = temp, tmax = tmax, stickyRecalcN = stickyRecalcN,
        maxOdeRecalc = maxOdeRecalc, odeRecalcFactor = odeRecalcFactor,
        eventType = eventType, shiErr = shiErr, shi21maxFD = shi21maxFD,
        solveType = solveType, useColor = useColor, printNcol = printNcol,
        print = print, normType = normType, scaleType = scaleType,
        scaleCmax = scaleCmax, scaleCmin = scaleCmin, scaleC = scaleC,
        scaleTo = scaleTo, gradTo = gradTo, rxControl = rxControl,
        optExpression = optExpression, sumProd = sumProd, literalFix = literalFix,
        returnOptim = returnOptim, addProp = addProp, calcTables = calcTables,
        compress = compress, covMethod = covMethod, adjObf = adjObf,
        ci = ci, sigdig = sigdig, sigdigTable = sigdigTable,
        ...)
} # nocov end

#' @inherit nlmixr2est::uobyqaControl
#' @param ... Additional arguments passed to [nlmixr2est::uobyqaControl()].
#' @export
uobyqaControl <- function(npt = NULL, rhobeg = NULL, rhoend = NULL,
    iprint = 0L, maxfun = 100000L, returnUobyqa = FALSE, stickyRecalcN = 4,
    maxOdeRecalc = 5, odeRecalcFactor = 10^(0.5), useColor = crayon::has_color(),
    printNcol = floor((getOption("width") - 23)/12), print = 1L,
    normType = c("rescale2", "mean", "rescale", "std", "len",
        "constant"), scaleType = c("nlmixr2", "norm", "mult",
        "multAdd"), scaleCmax = 1e+05, scaleCmin = 1e-05, scaleC = NULL,
    scaleTo = 1, rxControl = NULL, optExpression = TRUE, sumProd = FALSE,
    literalFix = TRUE, addProp = c("combined2", "combined1"),
    calcTables = TRUE, compress = TRUE, covMethod = c("r", ""),
    adjObf = TRUE, ci = 0.95, sigdig = 4, sigdigTable = NULL,
    ...) { # nocov start
    nlmixr2est::uobyqaControl(npt = npt, rhobeg = rhobeg, rhoend = rhoend,
        iprint = iprint, maxfun = maxfun, returnUobyqa = returnUobyqa,
        stickyRecalcN = stickyRecalcN, maxOdeRecalc = maxOdeRecalc,
        odeRecalcFactor = odeRecalcFactor, useColor = useColor,
        printNcol = printNcol, print = print, normType = normType,
        scaleType = scaleType, scaleCmax = scaleCmax, scaleCmin = scaleCmin,
        scaleC = scaleC, scaleTo = scaleTo, rxControl = rxControl,
        optExpression = optExpression, sumProd = sumProd, literalFix = literalFix,
        addProp = addProp, calcTables = calcTables, compress = compress,
        covMethod = covMethod, adjObf = adjObf, ci = ci, sigdig = sigdig,
        sigdigTable = sigdigTable, ...)
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

#' @inherit nlmixr2extra::profileFixed
#' @export
profileFixed <- function(fitted, which, control = list()) { # nocov start
    nlmixr2extra::profileFixed(fitted = fitted, which = which,
        control = control)
} # nocov end

#' @inherit nlmixr2extra::profileFixedSingle
#' @export
profileFixedSingle <- function(fitted, which) { # nocov start
    nlmixr2extra::profileFixedSingle(fitted = fitted, which = which)
} # nocov end

#' @inherit nlmixr2extra::profileLlp
#' @export
profileLlp <- function(fitted, which, control) { # nocov start
    nlmixr2extra::profileLlp(fitted = fitted, which = which,
        control = control)
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
    stdErrType = c("perc", "sd", "se"), ci = 0.95, pvalues = NULL,
    restart = FALSE, plotHist = FALSE, fitName = as.character(substitute(fit))) { # nocov start
    nlmixr2extra::bootstrapFit(fit = fit, nboot = nboot, nSampIndiv = nSampIndiv,
        stratVar = stratVar, stdErrType = stdErrType, ci = ci,
        pvalues = pvalues, restart = restart, plotHist = plotHist,
        fitName = fitName)
} # nocov end

#' @inherit nlmixr2extra::bootplot
#' @param ... Additional arguments passed to [nlmixr2extra::bootplot()].
#' @export
bootplot <- function(x, ...) { # nocov start
    nlmixr2extra::bootplot(x = x, ...)
} # nocov end
