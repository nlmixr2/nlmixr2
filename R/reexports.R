#' @import nlmixr2plot
#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

#' @importFrom rxode2 rxode2
#' @export
#' @inherit rxode2::rxode2
#' @rdname rxode2
#' @name rxode2
#' @title Create an ODE-based model specification (from `rxode2`)
rxode2::rxode2

#' @importFrom rxode2 rxode
#' @export
#' @rdname rxode2
#' @name rxode
rxode2::rxode

#' @importFrom rxode2 RxODE
#' @export
#' @rdname rxode2
#' @name rxode
rxode2::RxODE

#' @importFrom rxode2 ini
#' @export
#' @rdname ini
#' @name ini
#' @title Ini block for rxode2/nlmixr models (from `rxode2`)
#' @inherit rxode2::ini
rxode2::ini

#' @importFrom rxode2 model
#' @export
#' @rdname model
#' @name model
#' @title Model block for rxode2/nlmixr models (from `rxode2`)
#' #' @inherit rxode2::model
rxode2::model

#' @importFrom rxode2 lotri
#' @export
rxode2::lotri


#' @importFrom rxode2 logit
#' @export
#' @rdname logit
#' @name logit
#' @inherit rxode2::logit
#' @title logit transform
rxode2::logit

#' @importFrom rxode2 expit
#' @export
#' @rdname expit
#' @name expit
#' @title expit transform
#' @inherit rxode2::expit
rxode2::expit

#' @importFrom rxode2 probit
#' @export
#' @rdname probit
#' @name probit
#' @title probit function
#' @inherit rxode2::probit
rxode2::probit

#' @importFrom rxode2 probitInv
#' @export
#' @rdname probitInv
#' @name probitInv
#' @title Probit-inverse function
#' @inherit rxode2::probitInv
rxode2::probitInv

#' @importFrom rxode2 rxSolve
#' @export
#' @rdname rxSolve
#' @name rxSolve
#' @title Solving & Simulation of a ODE/solved system (from `rxode2`)
#' @inherit rxode2::rxSolve
rxode2::rxSolve

#' @importFrom rxode2 rxClean
#' @export
#' @rdname rxClean
#' @name rxClean
#' @title Clean Cached Binaries (from `rxode2`)
#' @inherit rxode2::rxClean
rxode2::rxClean

#' @importFrom rxode2 rxCat
#' @export
#' @rdname rxCat
#' @name rxCat
#' @inherit rxode2::rxCat
#' @title Use cat when rxode2.verbose is TRUE
rxode2::rxCat


#' @importFrom rxode2 eventTable
#' @export
#' @rdname eventTable
#' @name eventTable
#' @title Event Table (from `rxode2()`)
#' @inherit rxode2::eventTable
rxode2::eventTable

#' @importFrom rxode2 add.dosing
#' @export
#' @rdname add.dosing
#' @name add.dosing
#' @title Add dosing to `rxode2` event table (from `rxode2()`)
#' @inherit rxode2::add.dosing
rxode2::add.dosing

#' @importFrom rxode2 add.sampling
#' @export
#' @rdname add.sampling
#' @name add.sampling
#' @title Add sampling to `rxode2` event table (from `rxode2()`)
#' @inherit rxode2::add.sampling
rxode2::add.sampling

#' @importFrom nlmixr2est pdDiag
#' @export
nlmixr2est::pdDiag

#' @importFrom nlmixr2est pdSymm
#' @export
nlmixr2est::pdSymm

#' @importFrom nlmixr2est pdLogChol
#' @export
nlmixr2est::pdLogChol

#' @importFrom nlmixr2est pdIdent
#' @export
nlmixr2est::pdIdent

#' @importFrom nlmixr2est pdCompSymm
#' @export
nlmixr2est::pdCompSymm

#' @importFrom nlmixr2est pdBlocked
#' @export
nlmixr2est::pdBlocked

#' @importFrom nlmixr2est pdNatural
#' @export
nlmixr2est::pdNatural

#' @importFrom nlmixr2est pdConstruct
#' @export
nlmixr2est::pdConstruct

#' @importFrom nlmixr2est pdFactor
#' @export
nlmixr2est::pdFactor

#' @importFrom nlmixr2est pdMat
#' @export
nlmixr2est::pdMat

#' @importFrom nlmixr2est pdMatrix
#' @export
nlmixr2est::pdMatrix

#' @importFrom nlmixr2est reStruct
#' @export
nlmixr2est::reStruct

#' @importFrom nlmixr2est varWeights
#' @export
nlmixr2est::varWeights

#' @importFrom nlmixr2est varPower
#' @export
nlmixr2est::varPower

#' @importFrom nlmixr2est varFixed
#' @export
nlmixr2est::varFixed

#' @importFrom nlmixr2est varFunc
#' @export
nlmixr2est::varFunc

#' @importFrom nlmixr2est varExp
#' @export
nlmixr2est::varExp

#' @importFrom nlmixr2est varConstPower
#' @export
nlmixr2est::varConstPower

#' @importFrom nlmixr2est varIdent
#' @export
nlmixr2est::varIdent

#' @importFrom nlmixr2est varComb
#' @export
nlmixr2est::varComb

#' @importFrom nlmixr2est groupedData
#' @export
nlmixr2est::groupedData

#' @importFrom nlmixr2est getData
#' @export
nlmixr2est::getData

#' @importFrom rxode2 et
#' @export
#' @rdname et
#' @name et
#' @title  Event Table Function (from `rxode2`)
#' @inherit rxode2::et
rxode2::et

#' @importFrom rxode2 rxParams
#' @export
#' @rdname rxParams
#' @name rxParams
#' @title Parameters specified by the model (from `rxode2`)
#' @inherit rxode2::rxParams
rxode2::rxParams

#' @importFrom rxode2 rxParam
#' @export
#' @rdname rxParams
#' @name rxParam
rxode2::rxParam

#' @importFrom rxode2 geom_cens
#' @export
#' @rdname geom_cens
#' @name geom_cens
#' @inherit rxode2::geom_cens
#' @title Add censoring shading to the plot (from `rxode2`)
rxode2::geom_cens

#' @importFrom rxode2 geom_amt
#' @export
#' @rdname geom_amt
#' @name geom_amt
#' @title Add dosing times to the plot (from `rxode2`)
#' @inherit rxode2::geom_amt
rxode2::geom_amt


#' @importFrom rxode2 stat_cens
#' @export
#' @rdname stat_cens
#' @name stat_cens
#' @inherit rxode2::stat_cens
rxode2::stat_cens

#' @importFrom rxode2 stat_amt
#' @export
#' @rdname stat_amt
#' @name stat_amt
#' @inherit rxode2::stat_amt
rxode2::stat_amt

#' @importFrom rxode2 rxControl
#' @export
#' @rdname rxControl
#' @name rxControl
#' @inherit rxode2::rxControl
#' @title Control options for `rxode2` solves
rxode2::rxControl

#' @importFrom nlmixr2plot traceplot
#' @export
#' @rdname traceplot
#' @name traceplot
#' @inherit nlmixr2plot::traceplot
#' @title Produce trace-plot for fit if applicable (from `nlmixr2plot`)
nlmixr2plot::traceplot

#' @importFrom nlmixr2plot vpcPlot
#' @export
#' @rdname vpcPlot
#' @name vpcPlot
#' @inherit nlmixr2plot::vpcPlot
#' @title Produce VPC-plot for fit if applicable (from `nlmixr2plot`)
nlmixr2plot::vpcPlot


#' @importFrom nlmixr2est vpcSim
#' @export
#' @rdname vpcSim
#' @name vpcSim
#' @inherit nlmixr2est::vpcSim
#' @title Produce VPC-plot for fit if applicable (from `nlmixr2est`)
nlmixr2est::vpcSim

#' @importFrom nlmixr2est nlmixr2
#' @export
#' @rdname nlmixr2
#' @name nlmixr2
#' @title Non-linear mixed effect models in R (from `nlmixr2est`)
#' @inherit nlmixr2est::nlmixr2
nlmixr2est::nlmixr2

#' @importFrom nlmixr2est nlmixr
#' @export
#' @rdname nlmixr2
#' @name nlmixr
nlmixr2est::nlmixr

#' @importFrom nlmixr2est saemControl
#' @export
#' @rdname saemControl
#' @name saemControl
#' @inherit nlmixr2est::saemControl
#' @title Control options for the `saem` procedure (from `nlmixr2est`)
nlmixr2est::saemControl

#' @importFrom nlmixr2est foceiControl
#' @export
#' @rdname foceiControl
#' @name foceiControl
#' @title Control options for the `saem` procedure (from `nlmixr2est`)
#' @inherit nlmixr2est::foceiControl
nlmixr2est::foceiControl

#' @importFrom nlmixr2est nlmixr2NlmeControl
#' @export
#' @rdname nlmixr2NlmeControl
#' @name nlmixr2NlmeControl
#' @inherit nlmixr2est::nlmixr2NlmeControl
#' @title Control options for the `nlme` procedure (from `nlmixr2est`)
nlmixr2est::nlmixr2NlmeControl

#' @importFrom nlmixr2est nlmeControl
#' @export
#' @rdname nlmixr2nlmeControl
#' @name nlmeControl
nlmixr2est::nlmeControl

#' @importFrom nlmixr2est tableControl
#' @export
#' @rdname tableControl
#' @name tableControl
#' @inherit nlmixr2est::tableControl
#' @title Table output control options for the `nlme` procedure (from `nlmixr2est`)
nlmixr2est::tableControl

#' @importFrom nlmixr2est nlme
#' @export
#' @inherit nlmixr2est::tableControl
nlmixr2est::nlme

#' @importFrom nlmixr2est ACF
#' @export
nlmixr2est::ACF

#' @importFrom nlmixr2est VarCorr
#' @export
nlmixr2est::VarCorr

#' @importFrom nlmixr2est getVarCov
#' @export
nlmixr2est::getVarCov


#' @importFrom nlmixr2est augPred
#' @export
nlmixr2est::augPred

#' @importFrom nlmixr2est fixef
#' @export
nlmixr2est::fixef

#' @importFrom nlmixr2est fixed.effects
#' @export
nlmixr2est::fixed.effects

#' @importFrom nlmixr2est ranef
#' @export
nlmixr2est::ranef

#' @importFrom nlmixr2est random.effects
#' @export
nlmixr2est::random.effects

#' @importFrom nlmixr2est .nlmixrNlmeFun
#' @export
nlmixr2est::.nlmixrNlmeFun

#' @importFrom nlmixr2est addCwres
#' @export
#' @rdname addCwres
#' @name addCwres
#' @inherit nlmixr2est::addCwres
#' @title Add conditional weighted residuals to fit (from `nlmixr2est`)
nlmixr2est::addCwres

#' @importFrom nlmixr2est addNpde
#' @export
#' @rdname addNpde
#' @name addNpde
#' @inherit nlmixr2est::addNpde
#' @title Add NPDE to he plnot (from `nlmixr2est`)
nlmixr2est::addNpde

#' @importFrom nlmixr2est addTable
#' @export
#' @rdname addTable
#' @name addTable
#' @inherit nlmixr2est::addTable
#' @title Add NPDE to he plot (from `nlmixr2est`)
nlmixr2est::addTable

#' @importFrom nlmixr2est setOfv
#' @export
#' @rdname setOfv
#' @name setOfv
#' @inherit nlmixr2est::setOfv
#' @title Set the method to calculate the objective function
nlmixr2est::setOfv
