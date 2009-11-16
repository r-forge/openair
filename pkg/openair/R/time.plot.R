time.plot <- function(mydata,
                      pollutant = "nox",
                      group = FALSE,
                      stack = FALSE,
                      normalise = FALSE,
                      avg.time = "default",
                      data.thresh = 0,
                      type = "default",
                      layout = c(1, 1),
                      cols = "brewer1",
                      main = "",
                      ylab = pollutant,
                      lty = 1:length(pollutant),
                      lwd = 1,
                      key.columns = 1,
                      auto.text = TRUE, ...)   {

    library(Hmisc)
    library(lattice)
    library(reshape)
    ## basic function to plot single/multiple time series in flexible ways
    ## optionally includes several pre-deifined averaging periods
    ## can deal with wide range of date/time formats e.g. minute, 15-min, hourly, daily

    ## Author: David Carslaw 11 Sep. 09
    ## CHANGES:

    if (type == "default") {
        vars <- c("date", pollutant)
    } else {
        vars <- c("date", pollutant, type)
    }

    ## data checks
    mydata <- check.prep(mydata, vars, type)

    ## pad out any missing date/times so that line don't extend between areas of missing data
    mydata <- date.pad(mydata, type)

    ## average the data if necessary (default does nothing)
    if (avg.time != "default") mydata <- time.average(mydata, period = avg.time,
        data.thresh = data.thresh)

    mydata <- cut.data(mydata, type)

    ## don't need type, now a condition
    vars <-  c(vars, "cond")
    vars <- vars[vars != type]
    mydata <- mydata[, vars]
    names(mydata)[names(mydata) == "cond"] <- "site" ## change to name "site"

    if (type == "default") {
        mydata <- melt(mydata, id.var = c("date", "site"))
    } else {
        ## should always be in this order
        names(mydata)[2:3] <- c("value", "variable")
        mylab <- levels(factor(mydata$variable))
    }


    ## layout - stack vertically
    if (missing(layout) & !group) layout <- c(1, length(pollutant))

    ## function to normalise data ##################################
    divide.by.mean <- function(x) {
        Mean <- mean(x$value, na.rm = TRUE)
        x$value <- x$value / Mean
        x
    }

    if (normalise) {
        ylab <- "normalised level"
        mydata <-  ddply(mydata, .(variable), divide.by.mean)
    }

    ## ylabs for more than one pollutant
    if (missing(ylab)) ylab <-  paste(pollutant, collapse = ", ")

    mylab <- sapply(seq_along(pollutant), function(x)
                    quick.text(pollutant[x], auto.text))

    if (type == "site") {
        mylab <- levels(mydata$variable)
        if (!group) layout <- c(1, length(factor(levels(mydata$variable))))
        if (group) layout <- c(1, 1)
    }

    ## set up colours
    npol <- length(unique(mydata$variable)) ## number of pollutants
    myColors <- open.colours(cols, npol)

    ## basic function for lattice call + defaults
    myform <- formula("value ~ date")
    strip <- TRUE
    strip.left <- FALSE
    dates <- date.breaks(mydata$date)$major ## for date scale
    formats <- date.breaks(mydata$date)$format
    scales <- list(x = list(at = dates, format = formats, relation = "free"))
    xlim <- range(mydata$date)

    ## layout changes depening on plot type

    if (!group) { ## sepate panels per pollutant
        strip <- FALSE
        myform <- formula("value ~ date | variable")
        ## proper names of labelling
        pol.name <- sapply(unique(mydata$variable), function(x) quick.text(x, auto.text))

        if (length(pollutant) == 1) {
            strip.left <- FALSE
        } else {
            strip.left <- strip.custom(par.strip.text = list(cex = 0.9), horizontal = FALSE,
                                       factor.levels = pol.name)
        }
        scales <- list(x = list(at = dates, format = formats), y = list(relation = "free",
                                                               rot = 0))

        if (missing(lty)) lty <- 1 ## don't need different line types here

    }

    ## if stacking of plots by year is needed
    if (stack) {
        mydata$year <- format(mydata$date, "%Y")
        layout <- c(1, length(unique(mydata$year)))
        strip = FALSE
        myform <- formula("value ~ date | year")
        strip.left = strip.custom(par.strip.text = list(cex = 0.9), horizontal = FALSE)
        dates <- as.POSIXct(unique(trunc(mydata$date, "months")), "GMT")
        scales <- list(x = list(at = dates, format = "%d-%b", relation = "free"))
        xlim <- dlply(mydata, .(year), function (x) range(x$date))

    }

    if (missing(key.columns)) key.columns <- npol

    xyplot(myform,  data = mydata, groups = variable,
           as.table = TRUE,
           layout = layout,
           lty = lty,
           lwd = lwd,
           xlim = xlim,
           main = quick.text(main),
           ylab = quick.text(ylab, auto.text),
           scales = scales,

           key = list(lines = list(col = myColors[1:npol], lty = lty, lwd = lwd),
           text = list(lab = mylab),  space = "bottom", columns = key.columns),

           strip = strip,
           strip.left = strip.left,

           panel =  panel.superpose,...,
           panel.groups = function(x, y, col.line, type, group.number, subscripts,...) {
               if (group.number == 1) {
                   panel.grid(-1, 0)
                   panel.abline(v = dates, col = "grey90")

               }
               if (!group & !stack) {
                   panel.abline(v = dates, col = "grey90")
                   panel.grid(-1, 0)
               }
               panel.xyplot(x, y, type = "l", col.line = myColors[group.number],...)

           }
           )
}
