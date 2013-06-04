library(shiny)
pkgs <- c("gbm","plyr","ggplot2")
pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(pkgs)) install.packages(pkgs,repos="http://cran.cs.wwu.edu/")
library(gbm); library(plyr); library(ggplot2)

## Make data
N <- 1000
X1 <- runif(N)
X2 <- 2*runif(N)
X3 <- ordered(sample(letters[1:4],N,replace=TRUE),levels=letters[4:1])
X4 <- factor(sample(letters[1:6],N,replace=TRUE))
X5 <- factor(sample(letters[1:3],N,replace=TRUE))
X6 <- 3*runif(N) 
mu <- c(-1,0,1,2)[as.numeric(X3)]

SNR <- 10 # signal-to-noise ratio
Y <- X1^1.5 + 2 * (X2^.5) + mu
sigma <- sqrt(var(Y)/SNR)
Y <- Y + rnorm(N,0,sigma)

# introduce some missing values
X1[sample(1:N,size=500)] <- NA
X4[sample(1:N,size=300)] <- NA

dat1 <- data.frame(Y=Y,X1=X1,X2=X2,X3=X3,X4=X4,X5=X5,X6=X6)

## New data
N <- 1000
X1 <- runif(N)
X2 <- 2*runif(N)
X3 <- ordered(sample(letters[1:4],N,replace=TRUE))
X4 <- factor(sample(letters[1:6],N,replace=TRUE))
X5 <- factor(sample(letters[1:3],N,replace=TRUE))
X6 <- 3*runif(N) 
mu <- c(-1,0,1,2)[as.numeric(X3)]

Y <- X1^1.5 + 2 * (X2^.5) + mu + rnorm(N,0,sigma)

dat2 <- data.frame(Y=Y,X1=X1,X2=X2,X3=X3,X4=X4,X5=X5,X6=X6)

## Custom hacks to gbm package functions to make cross-validation work within gbm inside of Shiny
gbm_noPar <- function (formula = formula(data), distribution = "bernoulli", 
    data = list(), weights, var.monotone = NULL, n.trees = 100, 
    interaction.depth = 1, n.minobsinnode = 10, shrinkage = 0.001, 
    bag.fraction = 0.5, train.fraction = 1, cv.folds = 0, keep.data = TRUE, 
    verbose = "CV", class.stratify.cv = NULL, n.cores = NULL) 
{
    theCall <- match.call()
    lVerbose <- if (!is.logical(verbose)) {
        FALSE
    }
    else {
        verbose
    }
    mf <- match.call(expand.dots = FALSE)
    m <- match(c("formula", "data", "weights", "offset"), names(mf), 
        0)
    mf <- mf[c(1, m)]
    mf$drop.unused.levels <- TRUE
    mf$na.action <- na.pass
    mf[[1]] <- as.name("model.frame")
    m <- mf
    mf <- eval(mf, parent.frame())
    Terms <- attr(mf, "terms")
    y <- model.response(mf)
    if (missing(distribution)) {
        distribution <- guessDist(y)
    }
    else if (is.character(distribution)) {
        distribution <- list(name = distribution)
    }
    w <- model.weights(mf)
    offset <- model.offset(mf)
    var.names <- attributes(Terms)$term.labels
    x <- model.frame(terms(reformulate(var.names)), data, na.action = na.pass)
    response.name <- as.character(formula[[2]])
    lVerbose <- if (!is.logical(verbose)) {
        FALSE
    }
    else {
        verbose
    }
    class.stratify.cv <- getStratify(class.stratify.cv, distribution)
    group <- NULL
    num.groups <- 0
    if (distribution$name != "pairwise") {
        nTrain <- floor(train.fraction * nrow(x))
    }
    else {
        distribution.group <- distribution[["group"]]
        if (is.null(distribution.group)) {
            stop("For pairwise regression, the distribution parameter must be a list with a parameter 'group' for the a list of the column names indicating groups, for example list(name=\"pairwise\",group=c(\"date\",\"session\",\"category\",\"keywords\")).")
        }
        i <- match(distribution.group, colnames(data))
        if (any(is.na(i))) {
            stop("Group column does not occur in data: ", distribution.group[is.na(i)])
        }
        group <- factor(do.call(paste, c(data[, distribution.group, 
            drop = FALSE], sep = ":")))
        if ((!missing(weights)) && (!is.null(weights))) {
            w.min <- tapply(w, INDEX = group, FUN = min)
            w.max <- tapply(w, INDEX = group, FUN = max)
            if (any(w.min != w.max)) {
                stop("For distribution 'pairwise', all instances for the same group must have the same weight")
            }
            w <- w * length(w.min)/sum(w.min)
        }
        perm.levels <- levels(group)[sample(1:nlevels(group))]
        group <- factor(group, levels = perm.levels)
        ord.group <- order(group, -y)
        group <- group[ord.group]
        y <- y[ord.group]
        x <- x[ord.group, , drop = FALSE]
        w <- w[ord.group]
        num.groups.train <- max(1, round(train.fraction * nlevels(group)))
        nTrain <- max(which(group == levels(group)[num.groups.train]))
        Misc <- group
    }
    cv.error <- NULL
    if (cv.folds > 1) {
        cv.results <- gbmCrossVal_noPar(cv.folds, nTrain, n.cores, 
            class.stratify.cv, data, x, y, offset, distribution, 
            w, var.monotone, n.trees, interaction.depth, n.minobsinnode, 
            shrinkage, bag.fraction, var.names, response.name, 
            group)
        cv.error <- cv.results$error
        p <- cv.results$predictions
    }
    gbm.obj <- gbm.fit_noPar(x, y, offset = offset, distribution = distribution, 
        w = w, var.monotone = var.monotone, n.trees = n.trees, 
        interaction.depth = interaction.depth, n.minobsinnode = n.minobsinnode, 
        shrinkage = shrinkage, bag.fraction = bag.fraction, nTrain = nTrain, 
        keep.data = keep.data, verbose = lVerbose, var.names = var.names, 
        response.name = response.name, group = group)
    gbm.obj$train.fraction <- train.fraction
    gbm.obj$Terms <- Terms
    gbm.obj$cv.error <- cv.error
    gbm.obj$cv.folds <- cv.folds
    gbm.obj$call <- theCall
    gbm.obj$m <- m
    if (cv.folds > 0) {
        gbm.obj$cv.fitted <- p
    }
    if (distribution$name == "pairwise") {
        gbm.obj$ord.group <- ord.group
        gbm.obj$fit <- gbm.obj$fit[order(ord.group)]
    }
    return(gbm.obj)
}

gbmCrossVal_noPar <- function (cv.folds, nTrain, n.cores, class.stratify.cv, data, 
    x, y, offset, distribution, w, var.monotone, n.trees, interaction.depth, 
    n.minobsinnode, shrinkage, bag.fraction, var.names, response.name, 
    group) 
{
    i.train <- 1:nTrain
    cv.group <- getCVgroup(distribution, class.stratify.cv, y, 
        i.train, cv.folds, group)
    cv.models <- gbmCrossValModelBuild_noPar(cv.folds, cv.group, n.cores, 
        i.train, x, y, offset, distribution, w, var.monotone, 
        n.trees, interaction.depth, n.minobsinnode, shrinkage, 
        bag.fraction, var.names, response.name, group)
    cv.error <- gbmCrossValErr(cv.models, cv.folds, cv.group, 
        nTrain, n.trees)
    best.iter.cv <- which.min(cv.error)
    predictions <- gbmCrossValPredictions(cv.models, cv.folds, 
        cv.group, best.iter.cv, distribution, data[i.train, ], 
        y)
    list(error = cv.error, predictions = predictions)
}

gbmCrossValModelBuild_noPar <- function (cv.folds, cv.group, n.cores, i.train, x, y, offset, 
    distribution, w, var.monotone, n.trees, interaction.depth, 
    n.minobsinnode, shrinkage, bag.fraction, var.names, response.name, 
    group) 
{
    #### cluster <- gbmCluster(n.cores)
    #### on.exit(stopCluster(cluster))
    seeds <- as.integer(runif(cv.folds, -(2^31 - 1), 2^31))
    lapply(X = 1:cv.folds, gbmDoFold_noPar, i.train, 
        x, y, offset, distribution, w, var.monotone, n.trees, 
        interaction.depth, n.minobsinnode, shrinkage, bag.fraction, 
        cv.group, var.names, response.name, group, seeds)
}

gbmDoFold_noPar <- function (X, i.train, x, y, offset, distribution, w, var.monotone, 
    n.trees, interaction.depth, n.minobsinnode, shrinkage, bag.fraction, 
    cv.group, var.names, response.name, group, s) 
{
    library(gbm, quietly = TRUE)
    cat("CV:", X, "\n")
    set.seed(s[[X]])
    i <- order(cv.group == X)
    x <- x[i.train, , drop = TRUE][i, , drop = FALSE]
    y <- y[i.train][i]
    offset <- offset[i.train][i]
    nTrain <- length(which(cv.group != X))
    group <- group[i.train][i]
    res <- gbm.fit_noPar(x, y, offset = offset, distribution = distribution, 
        w = w, var.monotone = var.monotone, n.trees = n.trees, 
        interaction.depth = interaction.depth, n.minobsinnode = n.minobsinnode, 
        shrinkage = shrinkage, bag.fraction = bag.fraction, nTrain = nTrain, 
        keep.data = FALSE, verbose = FALSE, response.name = response.name, 
        group = group)
    res
}

gbm.fit_noPar <- function (x, y, offset = NULL, misc = NULL, distribution = "bernoulli", 
    w = NULL, var.monotone = NULL, n.trees = 100, interaction.depth = 1, 
    n.minobsinnode = 10, shrinkage = 0.001, bag.fraction = 0.5, 
    nTrain = NULL, train.fraction = NULL, keep.data = TRUE, verbose = TRUE, 
    var.names = NULL, response.name = "y", group = NULL) 
{
    if (is.character(distribution)) {
        distribution <- list(name = distribution)
    }
    cRows <- nrow(x)
    cCols <- ncol(x)
    if (nrow(x) != ifelse(class(y) == "Surv", nrow(y), length(y))) {
        stop("The number of rows in x does not equal the length of y.")
    }
    if (!is.null(nTrain) && !is.null(train.fraction)) {
        stop("Parameters 'nTrain' and 'train.fraction' cannot both be specified")
    }
    else if (!is.null(train.fraction)) {
        warning("Parameter 'train.fraction' of gbm.fit is deprecated, please specify 'nTrain' instead")
        nTrain <- floor(train.fraction * cRows)
    }
    else if (is.null(nTrain)) {
        nTrain <- cRows
    }
    if (is.null(train.fraction)) {
        train.fraction <- nTrain/cRows
    }
    if (is.null(var.names)) {
        var.names <- getVarNames(x)
    }
    if (nTrain * bag.fraction <= 2 * n.minobsinnode + 1) {
        stop("The dataset size is too small or subsampling rate is too large: nTrain*bag.fraction <= n.minobsinnode")
    }
    if (distribution$name != "pairwise") {
        w <- w * length(w)/sum(w)
    }
    ch <- checkMissing(x, y)
    interaction.depth <- checkID(interaction.depth)
    w <- checkWeights(w, length(y))
    offset <- checkOffset(offset, y)
    Misc <- NA
    var.type <- rep(0, cCols)
    var.levels <- vector("list", cCols)
    for (i in 1:length(var.type)) {
        if (all(is.na(x[, i]))) {
            stop("variable ", i, ": ", var.names[i], " has only missing values.")
        }
        if (is.ordered(x[, i])) {
            var.levels[[i]] <- levels(x[, i])
            x[, i] <- as.numeric(x[, i]) - 1
            var.type[i] <- 0
        }
        else if (is.factor(x[, i])) {
            if (length(levels(x[, i])) > 1024) 
                stop("gbm does not currently handle categorical variables with more than 1024 levels. Variable ", 
                  i, ": ", var.names[i], " has ", length(levels(x[, 
                    i])), " levels.")
            var.levels[[i]] <- levels(x[, i])
            x[, i] <- as.numeric(x[, i]) - 1
            var.type[i] <- max(x[, i], na.rm = TRUE) + 1
        }
        else if (is.numeric(x[, i])) {
            var.levels[[i]] <- quantile(x[, i], prob = (0:10)/10, 
                na.rm = TRUE)
        }
        else {
            stop("variable ", i, ": ", var.names[i], " is not of type numeric, ordered, or factor.")
        }
        if (length(unique(var.levels[[i]])) == 1) {
            warning("variable ", i, ": ", var.names[i], " has no variation.")
        }
    }
    nClass <- 1
    if (!("name" %in% names(distribution))) {
        stop("The distribution is missing a 'name' component, for example list(name=\"gaussian\")")
    }
    supported.distributions <- c("bernoulli", "gaussian", "poisson", 
        "adaboost", "laplace", "coxph", "quantile", "tdist", 
        "multinomial", "huberized", "pairwise")
    distribution.call.name <- distribution$name
    if (!is.element(distribution$name, supported.distributions)) {
        stop("Distribution ", distribution$name, " is not supported")
    }
    if ((distribution$name == "bernoulli") && !all(is.element(y, 
        0:1))) {
        stop("Bernoulli requires the response to be in {0,1}")
    }
    if ((distribution$name == "huberized") && !all(is.element(y, 
        0:1))) {
        stop("Huberized square hinged loss requires the response to be in {0,1}")
    }
    if ((distribution$name == "poisson") && any(y < 0)) {
        stop("Poisson requires the response to be positive")
    }
    if ((distribution$name == "poisson") && any(y != trunc(y))) {
        stop("Poisson requires the response to be a positive integer")
    }
    if ((distribution$name == "adaboost") && !all(is.element(y, 
        0:1))) {
        stop("This version of AdaBoost requires the response to be in {0,1}")
    }
    if (distribution$name == "quantile") {
        if (length(unique(w)) > 1) {
            stop("This version of gbm for the quantile regression lacks a weighted quantile. For now the weights must be constant.")
        }
        if (is.null(distribution$alpha)) {
            stop("For quantile regression, the distribution parameter must be a list with a parameter 'alpha' indicating the quantile, for example list(name=\"quantile\",alpha=0.95).")
        }
        else if ((distribution$alpha < 0) || (distribution$alpha > 
            1)) {
            stop("alpha must be between 0 and 1.")
        }
        Misc <- c(alpha = distribution$alpha)
    }
    if (distribution$name == "coxph") {
        if (class(y) != "Surv") {
            stop("Outcome must be a survival object Surv(time,failure)")
        }
        if (attr(y, "type") != "right") {
            stop("gbm() currently only handles right censored observations")
        }
        Misc <- y[, 2]
        y <- y[, 1]
        i.train <- order(-y[1:nTrain])
        n.test <- cRows - nTrain
        if (n.test > 0) {
            i.test <- order(-y[(nTrain + 1):cRows]) + nTrain
        }
        else {
            i.test <- NULL
        }
        i.timeorder <- c(i.train, i.test)
        y <- y[i.timeorder]
        Misc <- Misc[i.timeorder]
        x <- x[i.timeorder, , drop = FALSE]
        w <- w[i.timeorder]
        if (!is.na(offset)) 
            offset <- offset[i.timeorder]
    }
    if (distribution$name == "tdist") {
        if (is.null(distribution$df) || !is.numeric(distribution$df)) {
            Misc <- 4
        }
        else {
            Misc <- distribution$df[1]
        }
    }
    if (distribution$name == "multinomial") {
        classes <- attr(factor(y), "levels")
        nClass <- length(classes)
        if (nClass > nTrain) {
            stop(paste("Number of classes (", nClass, ") must be less than the size of the training set (", 
                nTrain, ")", sep = ""))
        }
        new.idx <- as.vector(sapply(classes, function(a, x) {
            min((1:length(x))[x == a])
        }, y))
        all.idx <- 1:length(y)
        new.idx <- c(new.idx, all.idx[!(all.idx %in% new.idx)])
        y <- y[new.idx]
        x <- x[new.idx, ]
        w <- w[new.idx]
        if (!is.null(offset)) {
            offset <- offset[new.idx]
        }
        y <- as.numeric(as.vector(outer(y, classes, "==")))
        w <- rep(w, nClass)
        if (!is.null(offset)) {
            offset <- rep(offset, nClass)
        }
    }
    if (distribution$name == "pairwise") {
        distribution.metric <- distribution[["metric"]]
        if (!is.null(distribution.metric)) {
            distribution.metric <- tolower(distribution.metric)
            supported.metrics <- c("conc", "ndcg", "map", "mrr")
            if (!is.element(distribution.metric, supported.metrics)) {
                stop("Metric '", distribution.metric, "' is not supported, use either 'conc', 'ndcg', 'map', or 'mrr'")
            }
            metric <- distribution.metric
        }
        else {
            warning("No metric specified, using 'ndcg'")
            metric <- "ndcg"
            distribution[["metric"]] <- metric
        }
        if (any(y < 0)) {
            stop("targets for 'pairwise' should be non-negative")
        }
        if (is.element(metric, c("mrr", "map")) && (!all(is.element(y, 
            0:1)))) {
            stop("Metrics 'map' and 'mrr' require the response to be in {0,1}")
        }
        max.rank <- 0
        if (!is.null(distribution[["max.rank"]]) && distribution[["max.rank"]] > 
            0) {
            if (is.element(metric, c("ndcg", "mrr"))) {
                max.rank <- distribution[["max.rank"]]
            }
            else {
                stop("Parameter 'max.rank' cannot be specified for metric '", 
                  distribution.metric, "', only supported for 'ndcg' and 'mrr'")
            }
        }
        Misc <- c(group, max.rank)
        distribution.call.name <- sprintf("pairwise_%s", metric)
    }
    x.order <- apply(x[1:nTrain, , drop = FALSE], 2, order, na.last = FALSE) - 
        1
    x <- as.vector(data.matrix(x))
    predF <- rep(0, length(y))
    train.error <- rep(0, n.trees)
    valid.error <- rep(0, n.trees)
    oobag.improve <- rep(0, n.trees)
    if (is.null(var.monotone)) 
        var.monotone <- rep(0, cCols)
    else if (length(var.monotone) != cCols) {
        stop("Length of var.monotone != number of predictors")
    }
    else if (!all(is.element(var.monotone, -1:1))) {
        stop("var.monotone must be -1, 0, or 1")
    }
    fError <- FALSE
    gbm.obj <- .Call("gbm", Y = as.double(y), Offset = as.double(offset), 
        X = as.double(x), X.order = as.integer(x.order), weights = as.double(w), 
        Misc = as.double(Misc), cRows = as.integer(cRows), cCols = as.integer(cCols), 
        var.type = as.integer(var.type), var.monotone = as.integer(var.monotone), 
        distribution = as.character(distribution.call.name), 
        n.trees = as.integer(n.trees), interaction.depth = as.integer(interaction.depth), 
        n.minobsinnode = as.integer(n.minobsinnode), n.classes = as.integer(nClass), 
        shrinkage = as.double(shrinkage), bag.fraction = as.double(bag.fraction), 
        nTrain = as.integer(nTrain), fit.old = as.double(NA), 
        n.cat.splits.old = as.integer(0), n.trees.old = as.integer(0), 
        verbose = as.integer(verbose), PACKAGE="gbm")
    names(gbm.obj) <- c("initF", "fit", "train.error", "valid.error", 
        "oobag.improve", "trees", "c.splits")
    gbm.obj$bag.fraction <- bag.fraction
    gbm.obj$distribution <- distribution
    gbm.obj$interaction.depth <- interaction.depth
    gbm.obj$n.minobsinnode <- n.minobsinnode
    gbm.obj$num.classes <- nClass
    gbm.obj$n.trees <- length(gbm.obj$trees)/nClass
    gbm.obj$nTrain <- nTrain
    gbm.obj$train.fraction <- train.fraction
    gbm.obj$response.name <- response.name
    gbm.obj$shrinkage <- shrinkage
    gbm.obj$var.levels <- var.levels
    gbm.obj$var.monotone <- var.monotone
    gbm.obj$var.names <- var.names
    gbm.obj$var.type <- var.type
    gbm.obj$verbose <- verbose
    gbm.obj$Terms <- NULL
    if (distribution$name == "coxph") {
        gbm.obj$fit[i.timeorder] <- gbm.obj$fit
    }
    if (distribution$name == "multinomial") {
        gbm.obj$fit <- matrix(gbm.obj$fit, ncol = nClass)
        dimnames(gbm.obj$fit)[[2]] <- classes
        gbm.obj$classes <- classes
        exp.f <- exp(gbm.obj$fit)
        denom <- matrix(rep(rowSums(exp.f), nClass), ncol = nClass)
        gbm.obj$estimator <- exp.f/denom
    }
    if (keep.data) {
        if (distribution$name == "coxph") {
            gbm.obj$data <- list(y = y, x = x, x.order = x.order, 
                offset = offset, Misc = Misc, w = w, i.timeorder = i.timeorder)
        }
        else if (distribution$name == "multinomial") {
            new.idx <- order(new.idx)
            gbm.obj$data <- list(y = as.vector(matrix(y, ncol = length(classes), 
                byrow = FALSE)[new.idx, ]), x = as.vector(matrix(x, 
                ncol = length(var.names), byrow = FALSE)[new.idx, 
                ]), x.order = x.order, offset = offset[new.idx], 
                Misc = Misc, w = w[new.idx])
        }
        else {
            gbm.obj$data <- list(y = y, x = x, x.order = x.order, 
                offset = offset, Misc = Misc, w = w)
        }
    }
    else {
        gbm.obj$data <- NULL
    }
    class(gbm.obj) <- "gbm"
    return(gbm.obj)
}
