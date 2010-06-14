## functions to calculate Mann-Kendall and Sen-Theil slopes
## Uncertainty in slopes are calculated using bootstrap methods
## The block bootstrap used should be regarded as an ongoing development
## see http://www-rcf.usc.edu/~rwilcox/
##
## Author: DCC with Mann-Kendall and Sen-Theil functions from
## Rand Wilcox
###############################################################################

##library(lattice)
##library(zoo)
##library(boot)

MannKendall <- function(mydata,
                        pollutant = "nox",
                        deseason = FALSE,
                        type = "default",
                        period = "monthly",
                        simulate = FALSE,
                        alpha = 0.05,
                        dec.place = 2,
                        ylab = pollutant,
                        xlab = "year",
                        main = "",
                        auto.text = TRUE,
                        autocor = FALSE,
                        date.breaks = 7,...)  {

    ## extract variables of interest
    if (type == "wd") vars <- c("date", pollutant, "wd")
    if (type == "ws") vars <- c("date", pollutant, "ws")
    if (type == "site") vars <- c("date", pollutant, "site")
    if (type != "wd" & type != "ws" & type != "site") vars <- c("date", pollutant)

    ## if autocor is TRUE, then need simulations
    if (autocor) simulate <- TRUE

    ## data checks
    mydata <- check.prep(mydata, vars, type)

    ## cut data depending on type
    mydata <- cut.data(mydata, type)

    ## sometimes data have long trailing NAs, so start and end at first and last data
    min.idx <- min(which(!is.na(mydata[, pollutant])))
    max.idx <- max(which(!is.na(mydata[, pollutant])))
    mydata <- mydata[min.idx:max.idx, ]

    ## for overall data and graph plotting
    start.year <- as.numeric(format(mydata$date[1], "%Y"))
    end.year <- as.numeric(format(mydata$date[nrow(mydata)], "%Y"))
    start.month <- as.numeric(format(mydata$date[1], "%m"))
    end.month <- as.numeric(format(mydata$date[nrow(mydata)], "%m"))

    process.cond <- function(mydata) {

        ## sometimes data have long trailing NAs, so start and end at
        ## first and last data
        min.idx <- min(which(!is.na(mydata[, pollutant])))
        max.idx <- max(which(!is.na(mydata[, pollutant])))
        mydata <- mydata[min.idx:max.idx, ]

        ## these subsets may have different dates to overall
        start.year <- as.numeric(format(mydata$date[1], "%Y"))
        end.year <- as.numeric(format(mydata$date[nrow(mydata)], "%Y"))
        start.month <- as.numeric(format(mydata$date[1], "%m"))
        end.month <- as.numeric(format(mydata$date[nrow(mydata)], "%m"))

        cond <- as.character(unique(na.omit(mydata$cond)))

        if (period == "monthly") {

            ## use this to make sure all dates are present, even when data are missing
            ## assume mid-point of month for better plotting (less unambiguous)
            all.dates <- data.frame(date = seq(as.Date(ISOdate(start.year, start.month, 15)),
                                    as.Date(ISOdate(end.year, end.month, 15)), by = "months"))

            means <- tapply(mydata[, pollutant], format(mydata$date, "%Y-%m"),
                            mean, na.rm = TRUE)

            ## actual dates in data
            dates <- as.Date(paste(names(means), "-15", sep = ""))
            mydata <- data.frame(dates = dates, means = as.vector(means))

            mydata <- merge(mydata, all.dates, by.x = "dates", by.y = "date", all.y = TRUE)
            deseas <- mydata$means
            ## can't deseason less than 2 years of data
            if (nrow(mydata) < 24) deseason <- FALSE

            if (deseason) {
                ## interpolate missing data using zoo
                mydata$means <- na.approx(mydata$means)

                myts <- ts(mydata$means, start = c(start.year, start.month),
                           end = c(end.year, end.month), frequency = 12)
                ## key thing is to allow the seanonal cycle to vary, hence
                ## s.window should not be "periodic"; set quite high to avoid
                ## overly fitted seasonal cycle
                ## robustness also makes sense for sometimes noisy data
                ssd <- stl(myts, s.window = 35, robust = TRUE, s.degree = 0)

                deseas <- ssd$time.series[, "trend"] + ssd$time.series[, "remainder"]

                deseas <- as.vector(deseas)
            }
             all.results <- data.frame(date = mydata$dates, conc = deseas, cond = cond)
            if (type == "month" | type == "season")

           # all.results <- data.frame(date = mydata$dates, conc = deseas, cond = cond)

            ## need to do some aggregating for season
            if (type == "season") {
                ## winter stradles 2 years, need to deal with this
                all.results <- subset(all.results, select = -cond) ## remove for aggregation
                all.results$month <- as.numeric(format(all.results$date, "%m"))
                all.results$year <- as.numeric(format(all.results$date, "%Y"))
                all.results$year[all.results$month == 12] <-
                    all.results$year[all.results$month == 12] + 1
                ## remove missing for proper aggregation
                all.results <- na.omit(all.results)

                results <- aggregate(all.results, list(all.results$year), mean, na.rm = TRUE)
                class(results$date) <- "Date"
                results$cond <- cond
                all.results <- results
            }
          #  results$cond <- cond
          #  all.results <- results
            results <- na.omit(all.results)


        } else {

            ## assume annual
            means <- tapply(mydata[, pollutant], format(mydata$date, "%Y"),
                            mean, na.rm = TRUE)
            dates <- unique(as.numeric(names(means)))
            dates <- as.Date(ISOdate(dates, 7, 1)) ## convert to years
            means <- as.vector(means)

            all.results <- data.frame(date = dates, conc = means, cond = cond)
            results <- na.omit(all.results)
        }

        ## now calculate trend, uncertainties etc ###############################################

        MKresults <- MKstats(results$date, results$conc, alpha, simulate, autocor)
        ## make sure missing data are put back in for plotting
        results <- suppressWarnings(merge(all.results, MKresults, by = "date", all = TRUE))
        results
    }

    split.data <- split(mydata, mydata$cond)
    split.data <- lapply(split.data, function(x) process.cond(x))
    split.data <- split.data[which(lapply(split.data, nrow) >= 4)] ## need at least 4 points
    split.data <- do.call(rbind, split.data)

    ## define the levels for plotting

    if (type == "wd") layout = c(3, 3)

    strip <- TRUE
    skip <- FALSE
    if (type == "default") strip <- FALSE ## remove strip
    if (type == "wd") skip <- c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE)

    ## plot in date format for nice formatting of plots, trend statistics based on numerical dates (days)
    if (type == "month" | type == "season") split.data <- na.omit(split.data)
    ## there are "missing" data

    plt <- xyplot(conc ~ date | cond, data = split.data,
                  ylab = quick.text(ylab, auto.text),
                  main = quick.text(main, auto.text),
                  xlab = quick.text(xlab, auto.text),
                  as.table = TRUE,
                  layout = layout,
                  skip = skip,
                  strip = strip,
                   scales = list(x = list(at = dateBreaks(split.data$date, date.breaks)$major, format =
                                                         dateBreaks(split.data$date)$format)),...,

                  panel = function(x, y, subscripts,...){
                      ## year shading
                      panel.shade(split.data, start.year, end.year, ylim = current.panel.limits()$ylim)

                      panel.xyplot(x, y, type = "b",...)

                      sub.dat <- na.omit(split.data[subscripts, ])

                      panel.abline(a = sub.dat[1, "a"], b = sub.dat[1, "b"], col = "red", lwd = 2)
                      panel.abline(a = sub.dat[1, "lower.a"], b = sub.dat[1, "lower.b"], lty = 5,
                                   col = "red")
                      panel.abline(a = sub.dat[1, "upper.a"], b = sub.dat[1, "upper.b"], lty = 5,
                                   col = "red")
                      ## note 365 to get trend in /year rather than /day
                      panel.text(split.data$date[1], max(split.data$conc, na.rm = TRUE),
                                 paste(round(365 * sub.dat[1, "b"], dec.place), " ", "[",
                                       round(365 * sub.dat[1, "upper.b"], dec.place), ", ",
                                       round(365 * sub.dat[1, "lower.b"], dec.place), "]",
                                       " units/", xlab, " ", sub.dat[1, "p.stars"], sep = ""),
                                 cex = 0.7, pos = 4, col = "forestgreen")
                  }
                  )

    res <- data.frame(date = split.data$date, mean = split.data$conc,
                      cond = split.data$cond, slope = 365 * split.data$b,
                      lower = 365 * split.data$upper.b,
                      upper = 365 * split.data$lower.b, p = split.data$p,
                      p.stars = split.data$p.stars)

    ## aggregated results
    res2 <- aggregate(subset(res, select = c(-date, - cond, - p.stars)),
                      list(variable = res$cond, p.stars = res$p.stars), mean)

    print(plt)
    invisible(list(res, res2))
}



panel.shade <- function(split.data, start.year, end.year, ylim) {
    
    x1 <- as.POSIXct(seq(ISOdate(start.year, 1, 1),
                      ISOdate(end.year + 1, 1, 1), by = "2 years"), "GMT")
    x2 <- as.POSIXct(seq(ISOdate(start.year + 1, 1, 1),
                      ISOdate(end.year + 2, 1, 1), by = "2 years"), "GMT")
    if (class(split.data$date)[1]  == "Date") {x1 <- as.Date(x1)
                                            x2 <- as.Date(x2)
                                           }

    rng <- range(split.data$conc, na.rm = TRUE) ## range of data
    y1 <- min(split.data$conc, na.rm = TRUE) - 0.1 * abs(rng[2] - rng[1])
    y2 <- max(split.data$conc, na.rm = TRUE) + 0.1 * abs(rng[2] - rng[1])

    ## if user selects specific limits

    if (!missing(ylim)) {
         y1 <- ylim[1] - 0.1 * abs(ylim[2] - ylim[1])
         y2 <- ylim[2] + 0.1 * abs(ylim[2] - ylim[1])
    }

    sapply(seq_along(x1), function(x) lpolygon(c(x1[x], x1[x], x2[x], x2[x]),
                                               c(y1, y2, y2, y1),
                                               col = "grey95", border = "grey95"))
}

MKstats <- function(x, y, alpha, simulate, autocor) {
    ## function to calculate Mann-Kendall stats with different options
    if (simulate) {

        block.length <- 1
        ## block length equal to length ts^(1/3) - need reference
        if (autocor) block.length <- round(length(x) ^ (1 / 3))

        MKtau <- function(z) tau.boot(z)$cor

        boot.res <- tsboot(y, MKtau, R = 1000, l = block.length, sim = "fixed")

        ## approx p value; see ?boot for this (which I think is wrong!)
        p <- 1 - sum(abs(boot.res$t[, 1] - 1) > abs(boot.res$t0[1] - 1)) / (1 + boot.res$R)

    } else {
        ## trend information in days
        MKtau <- tau(as.numeric(x), y, alpha = alpha)
        p <- MKtau$siglevel ## signficance level of trend
    }

    coef <- tsp1reg(as.numeric(x), y)$coef
    uncer <- regci(as.numeric(x), y, alpha = alpha, autocor = autocor)$regci

    if (p >= 0.1) stars <- ""
    if (p < 0.1 & p >= 0.05) stars <- "+"
    if (p < 0.05 & p >= 0.01) stars <- "*"
    if (p < 0.01 & p >= 0.001) stars <- "**"
    if (p < 0.001) stars <- "***"

    ## make a data frame with all the results, wanring is about row name
    results <- suppressWarnings(data.frame(date = x, a = coef[1], b = coef[2],
                                           lower.a = uncer[1, 1],
                                           lower.b = uncer[2, 2], upper.a = uncer[1, 2],
                                           upper.b = uncer[2, 1],  p = p, p.stars = stars))
    results
}
