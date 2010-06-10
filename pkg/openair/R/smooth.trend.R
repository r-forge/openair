
smooth.trend <- function(mydata,
                         pollutant = "nox",
                         deseason = FALSE,
                         type = "default",
                         statistic = "mean",
                         percentile = 95,
                         simulate = FALSE,
                         n = 200, #bootstrap simulations
                         autocor = FALSE,
                         cols = "brewer1",
                         ylab = pollutant,
                         xlab = "year",
                         lty = 1,
                         lwd = 1,
                         pch = 1,
                         cex = 1,
                         key.columns = length(percentile),
                         main = "",
                         ci = FALSE,
                         alpha = 0.2,
                         date.breaks = 7,
                         auto.text = TRUE,...)  {

    ##library(mgcv)
    library(lattice)
    library(zoo)

    vars <- c("date", pollutant)

    mydata <- check.prep(mydata, vars, type)

    if (!missing(percentile)) statistic <- "percentile"

    ## sometimes data have long trailing NAs, so start and end at first and last data
    min.idx <- min(which(!is.na(mydata[, pollutant])))
    max.idx <- max(which(!is.na(mydata[, pollutant])))
    mydata <- mydata[min.idx:max.idx, ]

    ## for overall data and graph plotting
    start.year <- as.numeric(format(mydata$date[1], "%Y"))
    end.year <- as.numeric(format(mydata$date[nrow(mydata)], "%Y"))
    start.month <- as.numeric(format(mydata$date[1], "%m"))
    end.month <- as.numeric(format(mydata$date[nrow(mydata)], "%m"))

    ## cut data depending on type
    mydata <- cut.data(mydata, type)

    ## The aim to to get colums "date", "site" then turn to column data using melt
    ## Finally end up with "date", "value", "variable"

    ## don't need type, now a condition
    vars <-  c(vars, "cond")
    vars <- vars[vars != type]
    mydata <- mydata[, vars]
    mydata <- rename(mydata, c(cond = "site")) ## change to name "site"

    if (type == "default") {
        mydata <- melt(mydata, id.var = c("date", "site"))
    } else {
        ## should always be in this order
        names(mydata)[2:3] <- c("value", "variable")
        mylab <- levels(factor(mydata$variable))
    }

    mylab <- levels(factor(mydata$variable))

    mydata <- na.omit(mydata)

    process.cond <- function(mydata, percentile = percentile) {

        ## sometimes data have long trailing NAs, so start and end at
        ## first and last data
        min.idx <- min(which(!is.na(mydata[, "value"])))
        max.idx <- max(which(!is.na(mydata[, "value"])))
        mydata <- mydata[min.idx:max.idx, ]

        ## these subsets may have different dates to overall
        start.year <- as.numeric(format(mydata$date[1], "%Y"))
        end.year <- as.numeric(format(mydata$date[nrow(mydata)], "%Y"))
        start.month <- as.numeric(format(mydata$date[1], "%m"))
        end.month <- as.numeric(format(mydata$date[nrow(mydata)], "%m"))

        cond <- mydata$variable[1]

        mydata <- time.average(mydata, period = "month", statistic = statistic, percentile = percentile)

        if (type == "season") { ## special case

            results <- cbind(mydata, cond)
            ## winter stradles 2 years, need to deal with this
            results$month <- as.numeric(format(results$date, "%m"))
            results$year <- as.numeric(format(results$date, "%Y"))
            results$year[results$month == 12] <- results$year[results$month == 12] + 1
            ## remove missing for proper aggregation

            results <- subset(results, select = -cond)
            results <- aggregate(results, list(results$year), mean, na.rm = TRUE)

            class(results$date) <- c("POSIXt", "POSIXct")

            results$cond <- cond
            mydata <- na.omit(results)

        }

        ## can't deseason less than 2 years of data
        if (nrow(mydata) < 24) deseason <- FALSE

        if (deseason) {
            ## interpolate missing data using zoo

            mydata[, "value"] <- na.approx(mydata[, "value"])

            myts <- ts(mydata[, "value"], start = c(start.year, start.month),
                       end = c(end.year, end.month), frequency = 12)

            ssd <- stl(myts, s.window = 35, robust = TRUE, s.degree = 0)

            deseas <- ssd$time.series[, "trend"] + ssd$time.series[, "remainder"]
            deseas <- as.vector(deseas)

            results <- data.frame(date = mydata$date, conc = as.vector(deseas), cond = cond)

        } else {

            results <- data.frame(date = mydata$date, conc = mydata[, "value"],
                                  cond = cond)
        }

        results$group <- "NA"
        if (statistic == "percentile") { ## need to add "group" and percentile name
            per.name <- paste(percentile, "th", " percentile", sep = "")
            results$group <- per.name
            results$group <- ordered(results$group)

        }
        results
    }

    calc.res <- function (x) ddply(mydata, .(variable), process.cond, percentile = x)
    split.data <- lapply(percentile, calc.res)
    split.data <- do.call(rbind, split.data)

    ## define the levels for plotting

    if (type == "wd") layout = c(3, 3)

    strip <- TRUE
    skip <- FALSE
    if (type == "default") strip <- FALSE ## remove strip
    if (type == "wd") skip <-  c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE,
        FALSE, FALSE)

    ## colours according to number of percentiles
    npol <- length(percentile) ## number of pollutants

    ## set up colours
    myColors <- open.colours(cols, npol)

    ## percentile names for key
    key.lab <- levels(split.data$group)

    if (npol > 1) {
        key <- list(lines = list(col = myColors[1:npol], lty = lty, lwd = lwd, pch = pch, type = "b",
                    cex = cex), text = list(lab = key.lab),  space = "bottom", columns = key.columns)
    } else {
        key <- NULL ## either there is a key or there is not
    }

    xyplot(conc ~ date | cond, data = split.data, groups = group,
           as.table = TRUE,
           strip = strip,
           layout = layout,
           key = key,
           lwd = lwd,
           lty = lty,
           pch = pch,
           cex = cex,
           skip = skip,
           xlab = quick.text(xlab, auto.text),
           ylab = quick.text(ylab, auto.text),
           main = quick.text(main, auto.text),
           scales = list(x = list(at = dateBreaks(mydata$date, date.breaks)$major, format =
                                                         dateBreaks(mydata$date)$format)),
           panel = panel.superpose,
           ...,

           panel.groups = function(x, y, group.number, lwd, lty, pch, col, col.line, col.symbol,
           subscripts, type = "b",...) {


               if (group.number == 1) {  ## otherwise this is called every time

                   panel.shade(split.data, start.year, end.year, ylim = current.panel.limits()$ylim)

               }
               panel.xyplot(x, y, type = "b", lwd = lwd, lty = lty, pch = pch,
                            col.line = myColors[group.number],col.symbol = myColors[group.number], ...)

               panel.gam(x, y, col = "grey40", col.se = "black", simulate = simulate, n.sim = n,
                         autocor = autocor, lty = 1, lwd = 1, se = ci, ...)

           })

    ## invisible(results)
}


panel.gam <- function (x, y, form = y ~ x, method = "loess", ..., simulate = FALSE, n.sim = 200,
                       autocor = FALSE, se = TRUE,
                       level = 0.95, n = 100, col = plot.line$col, col.se = col,
                       lty = plot.line$lty, lwd = plot.line$lwd, alpha = plot.line$alpha,
                       alpha.se = 0.25, border = NA, subscripts, group.number, group.value,
                       type, col.line, col.symbol, fill, pch, cex, font, fontface,
                       fontfamily)
{
    library(mgcv)
    ## panel function to add a smooth line to a plot
    ## Uses a GAM (mgcv) to fit smooth
    ## Optionally can plot 95% confidence intervals and run bootstrap simulations
    ## to estimate uncertainties. Simple block bootstrap is also available for correlated data

    thedata <- data.frame(x = x, y = y)
    tryCatch({

        if (!simulate) {
            mod <- gam(y ~ s(x), se = TRUE, data = thedata)


            lims <- current.panel.limits()
            xrange <- c(max(min(lims$x), min(x)), min(max(lims$x), max(x)))
            xseq <- seq(xrange[1], xrange[2], length = n)

            pred <- predict(mod, data.frame(x = xseq), se = se)

            if (se) {
                std <- qnorm(level / 2 + 0.5)
                panel.polygon(x = c(xseq, rev(xseq)), y = c(pred$fit -
                                                      std * pred$se, rev(pred$fit + std * pred$se)),
                              col = col.se, alpha = alpha.se, border = border)
                pred <- pred$fit
            }

            panel.lines(xseq, pred, col = col, alpha = alpha, lty = lty, lwd = 2)
        } else { ## simulations required

            sam.size <- length(x)
            print(sam.size)
            lims <- current.panel.limits()
            xrange <- c(max(min(lims$x), min(x)), min(max(lims$x), max(x)))
            xseq <- seq(xrange[1], xrange[2], length = sam.size)

            boot.pred <- matrix(nrow = sam.size, ncol = n.sim)

            print ("Taking bootstrap samples. Please wait...")

            ## set up bootstrap
            block.length <- 1

            if (autocor) block.length <- round(sam.size ^ (1 / 3))
            index <- samp.boot.block(sam.size, n.sim, block.length)

            ## predict first
            mod <- gam(y ~ s(x), data = thedata)

            residuals <- residuals(mod) ## residuals of the model

            pred.input <- predict(mod, thedata)

            for (i in 1:n.sim) {
                ## make new data
                new.data <- data.frame(x = xseq, y = pred.input + residuals[index[, i]])

                mod <- gam(y ~ s(x),  data = new.data)

                pred <- predict(mod, new.data)

                boot.pred[, i] <- as.vector(pred)

            }

            ## calculate percentiles
            percentiles <- apply(boot.pred, 1, function(x) quantile(x, probs = c(0.025, 0.975)))

            results <- as.data.frame(cbind(pred = rowMeans(boot.pred),
                                           lower = percentiles[1, ], upper = percentiles[2, ]))

            if (se) {

                panel.polygon(x = c(xseq, rev(xseq)), y = c(results$lower, rev(results$upper)),
                              col = col.se, alpha = alpha.se, border = border)

            }

            panel.lines(xseq, pred.input, col = col, alpha = alpha, lty = lty, lwd = 2)

        }

    }, error = function(x) return)
}





