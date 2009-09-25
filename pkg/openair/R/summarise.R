

summarise <- function(mydata,
                      na.len = 24,
                      clip = TRUE,
                      percentile = 0.99,
                      type = "histogram",
                      pollutant = "nox",
                      period = "year",
                      breaks = 20,
                      col.trend = "lightgoldenrod2",
                      col.data = "lightblue",
                      col.mis = rgb(0.65, 0.04, 0.07),
                      col.hist = "forestgreen",
                      main = "",
                      auto.text = TRUE,...) {

    library(lattice)
    library(reshape)

    ## if date in format dd/mm/yyyy hh:mm (basic check)
    if (length(grep("/", as.character(mydata$date[1]))) > 0) {

	mydata$date <- as.POSIXct(strptime(mydata$date, "%d/%m/%Y %H:%M"), "GMT")
    }

    ## check to see if there are any missing dates, stop if there are
    if (any(is.na(mydata$date))) {
        stop (cat("There are some missing dates on line(s)", which(is.na(mydata$date))),"\n")
    }

    ## check to see if there is a field site and >1 site
    ## if several sites and no pollutant supplied, use first numeric

    if ("site" %in% names(mydata)) {
        if (length(levels(mydata$site)) > 1) {
            ## get rid of unused factor levels if subset previously used
            mydata$site <- factor(mydata$site)
            ## id of first numeric column (pollutant)
            id <- which(sapply(mydata, class) %in% c("numeric", "integer"))[1]
            if (missing(pollutant)) pollutant <- names(mydata)[id]

            if (pollutant %in% names(mydata) == FALSE) {
                stop(cat("Can't find the variable", pollutant, "\n"))
            }

            mydata <- subset(mydata, select = c("date", "site", pollutant))
            names(mydata) <- c("date", "variable", "value")
            mydata <- cast(mydata, ... ~ variable)
            warning(paste("More than one site detected, using", pollutant))
        }
    }

    ## make sure only numeric data are selected
    dates <- mydata$date
    mydata <- mydata[ , sapply(mydata, class) %in% c("numeric", "integer"), drop = FALSE]
    mydata <- data.frame(date = dates, mydata)

    ## remove variables where all are NA
    mydata <- mydata[ , sapply(mydata, function(x) !all(is.na(x)))]

    ## make sure data are ordered
    mydata <- mydata[order(mydata$date), ]

    ## force to be date/time class, even if orginally Date class
    mydata$date <- as.POSIXct(mydata$date, "GMT")

    ## proper names of labelling
    pol.name <- sapply(names(subset(mydata, select = -date)),
                       function(x) quick.text(x, auto.text))

    ## round the dates depending on period
    min.year <- as.numeric(min(format(mydata$date, "%Y")))
    max.year <- as.numeric(max(format(mydata$date, "%Y")))
    start.date <- as.POSIXct(trunc(min(mydata$date), period))
    end.date <- as.POSIXct(ceil(max(mydata$date), period) - 3600)

    ## find time interval of data and pad any missing times
    interval <- find.time.interval(mydata$date)
    all.dates <- data.frame(date = seq(start.date, end.date, by = interval))
    mydata <- merge(mydata, all.dates, all.y = TRUE)

    mydata <- melt(mydata, id.var = "date")

    plot.missing <- function(mydata, na.len, col = "red") {
        dat <- ifelse(is.na(mydata[, "value"]), 1, 0)
        rle.seq = rle(dat)
        cumsum.seq <- cumsum(rle.seq$lengths)
        myruns <- which(rle.seq$values == 1 & rle.seq$lengths >= na.len)

        ends <- cumsum.seq[myruns] #+ 1 # to get whole hour
        newindex <- ifelse(myruns > 1, myruns - 1, 0)
        starts <- cumsum.seq[newindex] + 1
        if (0 %in% newindex) starts = c(1, starts)

        ## plot missing only if there are missing data of sufficient length
        if (length(myruns > 0)){
            with(mydata, lrect(as.numeric(date[starts]), 0, as.numeric(date[ends]),
                  1, col = col, border = NA))}
    }

    sum.stats <- function(mydata) {

        value <- mydata$value
        mis.dat <- sum(is.na(value))
        mis.per <- round(100 * mis.dat / nrow(mydata), 1)
        min.dat <- round(min(value, na.rm = TRUE), 1)
        max.dat <- round(max(value, na.rm = TRUE), 1)
        mean.dat <- round(mean(value, na.rm = TRUE), 1)
        median.dat <- round(median(value, na.rm = TRUE), 1)
        percentile <- round(quantile(value, probs = 0.95, na.rm = TRUE), 1)

        if (period == "year") format.t <- "%Y" else format.t <- "%Y-%m"
        all.hours <- aggregate(value, list(year = format(mydata$date, format.t)), length)
        data.hours <- aggregate(value, list(year = format(mydata$date, format.t)),
                                function(x) length(na.omit(x)))

        data.cap <- round(100 * data.hours$x / all.hours$x, 1)  ## data capture %
        res <- list(results = c(mis.dat, mis.per, min.dat, max.dat, mean.dat, median.dat,
                    percentile), data.cap = data.cap)
        return(res)
    }

    ## range in data
    range01 <- function(x) {
        y <- c(x, 0) ## to get sensible range
        rng <- range(y, na.rm = TRUE)
        (x - rng[1]) / diff(rng)
    }

    plt1 <- xyplot(value ~ date | variable , data = mydata, type = "n",
                   ylim = c(0, 5.5),
                   ylab = "",
                   xlab = date,
                   xlim = c(start.date - 60, end.date + 60),

                   ## override scaling for more sensible date/time breaks
                   scales = list(y = list(draw = FALSE), x = list(at =
                                                         date.breaks(mydata$date)$major, format =
                                                         date.breaks(mydata$date)$format)),
                   layout = c(1, length(unique(mydata$variable))),
                   strip = FALSE,
                   strip.left = strip.custom(horizontal = FALSE, factor.levels = pol.name),

                   par.strip.text = list(cex = 0.7),...,
                   panel = function(x, y, subscripts)  {

                       seq.year <- seq(start.date, end.date, by = period)

                       panel.abline(v = date.breaks(mydata$date)$major, col = "grey85")

                       sub.dat <- mydata[subscripts, c("date", "value")]

                       monthly.mean <- aggregate(sub.dat, list(dates = format(sub.dat$date,
                                                               "%Y-%j")),  mean, na.rm = TRUE)

                       ## plot the monthly mean data as a line
                       monthly.mean$value <- 1 + range01(monthly.mean$value) * 4

                       panel.xyplot(monthly.mean$date, monthly.mean$value, type = "l",
                                    col = col.trend)

                       ## plot all data region
                       with(mydata, lrect(as.numeric(min(date)), 0,
                             as.numeric(max(date)), 1, col = col.data, border = NA))

                       ## over-plot missing data
                       plot.missing(mydata[subscripts,], na.len, col = col.mis)
                       stats <- sum.stats(mydata[subscripts,])$results

                       min.x <- as.numeric(min(mydata$date))
                       max.x <- as.numeric(max(mydata$date))

                       ltext(min.x, 4, paste("missing = ", stats[1], " (", stats[2], "%)",
                                             sep = ""), cex = 0.6, pos = 4)

                       ltext(min.x, 3, paste("min =", stats[3]), cex = 0.6, pos = 4)

                       ltext(min.x, 2, paste("max =", stats[4]), cex = 0.6, pos = 4)

                       ltext(max.x, 4, paste("mean =", stats[5]), cex = 0.6, pos = 2)

                       ltext(max.x, 3, paste("median =", stats[6]), cex = 0.6, pos = 2)

                       ltext(max.x, 2, paste("95th percentile =", stats[7]), cex = 0.6, pos = 2)

                       ltext(seq.year, 5 , paste(sum.stats(mydata[subscripts,])$data.cap, "%")
                             , cex = 0.6, col = "darkgreen", pos = 4)
                   })

    print(plt1, position = c(0, 0, 0.7, 1), more = TRUE)

    ## clip data to help show interesting part of distribution
    if (clip) {
        DFsplit <- split(mydata, mydata$variable)

        result <- lapply(DFsplit, function(.df) {
            subset(.df, value < quantile(value, probs = percentile, na.rm = TRUE))
        })

        mydata <- do.call(rbind, result)
        row.names(mydata) <- NULL
    }

    if (type == "histogram") {
        plt2 <- histogram(~ value | variable, data = mydata,
                          par.strip.text = list(cex = 0.7),
                          breaks = breaks,
                          layout = c(1, length(unique(mydata$variable))),
                          scales = list(relation = "free", y = list(rot = 0), xcex = 0.7),
                          strip = FALSE,

                          panel = function(x,...) {
                              panel.grid(-1, -1)
                              panel.histogram(x,  col = col.hist, border = NA,...)
                          })
    } else {

        plt2 <- densityplot(~ value | variable, data = mydata,
                            par.strip.text = list(cex = 0.7),
                            layout = c(1, length(unique(mydata$variable))),
                            scales = list(relation = "free", y = list(rot = 0), cex = 0.7),
                            strip = FALSE,

                            panel = function(x,...) {
                                panel.grid(-1, -1)
                                panel.densityplot(x, lwd = 2, plot.points = FALSE,
                                                  col = col.hist,...)
                            })
    }

    print(plt2, position = c(0.7, 0, 1, 0.975))

    ## use grid to add an overall title
    grid.text(quick.text(main, TRUE), 0.5, 0.975, gp = gpar(fontsize = 14))
}

