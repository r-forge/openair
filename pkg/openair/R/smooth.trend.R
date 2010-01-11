
smooth.trend <- function(mydata,
                         pollutant = "nox",
                         deseason = FALSE,
                         type = "default",
                         simulate = FALSE,
                         n = 200, #bootstrap simulations
                         autocor = FALSE,
                         ylab = pollutant,
                         main = "",
                         ci = FALSE,
                         alpha = 0.2,
                         auto.text = TRUE,...)  {

    ##library(mgcv)
    ##library(lattice)
    ##library(zoo)

    ## extract variables of interest
    if (type == "wd") vars <- c("date", pollutant, "wd")
    if (type == "ws") vars <- c("date", pollutant, "ws")
    if (type == "site") vars <- c("date", pollutant, "site")
    if (type != "wd" & type != "ws" & type != "site") vars <- c("date", pollutant)

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

        cond = as.character(unique(na.omit(mydata$cond)))

        ## use this to make sure all dates are present, even when data are missing
        all.dates <- data.frame(date = seq(
                                as.Date(ISOdate(start.year, start.month, 15)),
                                as.Date(ISOdate(end.year, end.month, 15)),
                                by = "months"))

        means <- tapply(mydata[, pollutant], format(mydata$date, "%Y-%m"),
                        mean, na.rm = TRUE)

        ## actual dates in data
        dates <- as.Date(paste(names(means), "-15", sep = ""))
        mydata <- data.frame(dates = dates, means = as.vector(means))

        mydata <- merge(mydata, all.dates, by.x = "dates", by.y = "date", all.y = TRUE)

        dates <- mydata$dates

        if (type == "season") { ## special case
                    results <- data.frame(dates = dates, means = mydata$means,
                                      cond = cond)
                    ## winter stradles 2 years, need to deal with this
                    results$month <- as.numeric(format(results$dates, "%m"))
                    results$year <- as.numeric(format(results$dates, "%Y"))
                    results$year[results$month == 12] <-
                        results$year[results$month == 12] + 1
                    ## remove missing for proper aggregation
                    results <- na.omit(results)
                    results <- subset(results, select = -cond)
                    results <- aggregate(results, list(results$year), mean, na.rm = TRUE)
                    class(results$dates) <- "Date"
                    dates <- results$dates
                    results$cond <- cond

                    mydata <- na.omit(results)
                }

        ## use loess smooth if <12 points
        if (length(na.omit(mydata$means)) < 12) {
            mydata <- na.omit(mydata)

            Loess <- loess(means ~ as.numeric(dates), data = mydata, span = 0.8, degree = 1,
                           family ="gaussian")
            predicted <- predict(Loess)
            results <- data.frame(date = mydata$dates, conc = mydata$means, cond = cond)
            results <- cbind(results, pred = predicted, lower = NA, upper = NA)
            results

        } else { ## enough data to calculate uncertainties

            ## can't deseason less than 2 years of data
            if (nrow(mydata) < 24) deseason <- FALSE

            if (deseason) {
                ## interpolate missing data using zoo
                mydata$means <- na.approx(mydata$means)

                myts <- ts(mydata$means, start = c(start.year, start.month),
                           end = c(end.year, end.month), frequency = 12)

                ssd <- stl(myts, s.window = 35, robust = TRUE, s.degree = 0)

                deseas <- ssd$time.series[, "trend"] +
                    ssd$time.series[, "remainder"]
                deseas <- as.vector(deseas)

                results <- data.frame(date = dates, conc = as.vector(deseas),
                                      cond = cond)

            } else {

                results <- data.frame(date = dates, conc = mydata$means,
                                      cond = cond)
            }

            if (!simulate) {  ## just plot the data
                mod <- gam(conc ~ s(as.numeric(date)), data = results)
                pred <- predict(mod, results, se = TRUE)

                results <- cbind(results, pred = pred$fit,
                                 lower = pred$fit - 2 * pred$se.fit,
                                 upper = pred$fit + 2 * pred$se.fit)

            } else {

                sam.size = nrow(results)
                boot.pred <- matrix(nrow = sam.size, ncol = n)

                print ("Taking bootstrap samples. Please wait...")

                ## set up bootstrap
                block.length <- 1
                if (autocor) block.length <- round(sam.size ^ (1 / 3))
                index <- samp.boot.block(sam.size, n, block.length)

                ## predict first
                mod <- gam(conc ~ s(as.numeric(date), bs = "tp"), data = results)
                residuals <- residuals(mod) ## residuals of the model
                pred.input <- predict(mod, results)

                for (i in 1:n) {
                    ## make new data
                    new.data <- data.frame(date = results$date,
                                           conc = pred.input +
                                           residuals[index[, i]])

                    mod <- gam(conc ~ s(as.numeric(date), bs = "tp"),
                               data = new.data)
                    pred <- predict(mod, new.data)
                    boot.pred[, i] <- pred

                }

                ## calculate percentiles
                percentiles <- apply(boot.pred, 1, function(x)
                                     quantile(x, probs = c(0.025, 0.975)))

                results <- cbind(results, pred = rowMeans(boot.pred),
                                 lower = percentiles[1, ],
                                 upper = percentiles[2, ])
            }
            results
        }
    }

    split.data <- split(mydata, mydata$cond)
    split.data <- lapply(split.data, function(x) process.cond(x))
    split.data <- do.call(rbind, split.data)

    ## define the levels for plotting

    if (type == "wd") {

        layout = c(3, 3)

    }

    if (type == "hour") {
        levels(split.data$cond) <- paste("hour = ", 0:23)

        layout = c(6, 4)
    }

    if (type == "weekday") {
        weekdays <- weekday.name

        split.data$cond <- ordered(split.data$cond, levels = weekdays)

        layout = c(3, 3)
    }

    if (type == "ws"){
        ws.levels = levels(split.data$cond)
        ws.levels <- gsub("[,]", " to ", ws.levels)
        ws.levels <- gsub("[(]|[)]|[[]|[]]", "", ws.levels)
        levels(split.data$cond) <- ws.levels
        layout = c(4, 2)
    }

    strip <- TRUE
    skip <- FALSE
    if (type == "default") 	strip = FALSE ## remove strip
    if (type == "wd") skip <-  c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE,
        FALSE, FALSE)

    xyplot(conc ~ date | cond, data = split.data,
           as.table = TRUE,
           strip = strip,
           layout = layout,
           skip = skip,
           xlab = "year",
           ylab = quick.text(ylab, auto.text),
           main = quick.text(main, auto.text),
           ...,

           panel = function(x, y, subscripts,...) {
               panel.shade(split.data, start.year, end.year)

               x1 <- c(split.data$date[subscripts],
                       rev(split.data$date[subscripts]))
               y1 <- c(split.data$lower[subscripts],
                       rev(split.data$upper[subscripts]))
               if (ci) lpolygon(x1, y1, col = rgb(1, 0, 0, alpha),
                                border = NA)

               panel.xyplot(x, y, type = "b",...)

               llines(split.data$date[subscripts], split.data$pred[subscripts],
                      lwd = 2, col = rgb(1, 0,0))


           })

    ## invisible(results)
}


