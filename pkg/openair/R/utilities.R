## TODO: Add comment
                                        #
## Author: David Carslaw
## useful utility functions
###############################################################################
weekday.name <- c("Monday", "Tuesday", "Wednesday",
                  "Thursday", "Friday", "Saturday", "Sunday")

weekday.abb <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")

###############################################################################

## function to find averaging period of data, returns "xx sec"
## for use in filling in gaps in time series data
## it finds the table of values of time gaps and picks the biggest
## can't think of better way unless user specifies what the time interval is meant to be

find.time.interval <- function(dates) {
    ## assumes date is ordered before we get here
    ## id of highest frequency of gaps
    id <- which.max(table(diff(as.numeric(dates))))
    seconds <- as.numeric(names(id))

    if (class(dates)[1] == "POSIXt") seconds <- paste(seconds, "sec")

    if (class(dates)[1] == "Date") {
        seconds <- 3600 * 24
        seconds <- paste(seconds, "sec")
    }

    seconds
}

###############################################################################

#############################################################################################
## Function to pad out missing time data, optionally dealing with conditioning variable "site"
date.pad <- function(mydata, type = "default") {

    date.pad.site <- function(mydata) {
        ## function to fill missing data gaps
        ## assume no missing data to begin with
        if (type == "site" ) site <- mydata$site[1]

        ## pad out missing data for better looking plot
        start.date <- min(mydata$date, na.rm = TRUE)
        end.date <- max(mydata$date, na.rm = TRUE)

        ## find time interval of data
        interval <- find.time.interval(mydata$date)
        all.dates <- data.frame(date = seq(start.date, end.date, by = interval))
        mydata <- merge(mydata, all.dates, all.y = TRUE)
        if (type == "site") mydata$site <- site
        mydata
    }

    if (type == "site") {
        mydata <- split(mydata, mydata$site)
        mydata <- lapply(mydata, date.pad.site)
        mydata <- do.call(rbind, mydata)
    } else {
        mydata <- date.pad.site(mydata)
    }
    mydata
}
#############################################################################################


rolling.mean <- function(mydata, pollutant = "o3", hours = 8, new.name = "rolling",
                         data.capture = 75){
    ## function to calculate rolling means
    ## as fast as rollapply (zoo) but can handle wide "windows" e.g. annual means

    if (missing(new.name)) new.name <- paste("rolling", hours, pollutant, sep = "")

    calc.rolling <- function(mydata, pollutant, hours, new.name, data.capture) {

        roll <- function(x, i, hours, new.name, data.capture) {
            dat <- x[i:(i + hours - 1)]
            if (length(na.omit(dat)) >= round(hours * data.capture / 100)) {
                res <- mean(dat, na.rm = TRUE)
            } else {
                res <- NA
            }
            res
        }
        ## print(nrow(mydata))
        res <- sapply(1:(nrow(mydata) - hours), function(i) roll(mydata[ , pollutant], i,
                                                                 hours, new.name, data.capture))
        res <- c(res, rep(NA, hours)) ## pad missing data
        mydata <- cbind(mydata, res)
        names(mydata)[ncol(mydata)] <- new.name
        mydata
    }

    ## split if several sites
    if ("site" %in% names(mydata)) { ## split by site
        mydata$site <- factor(mydata$site)
        mydata <- split(mydata, mydata$site)
        mydata <- lapply(mydata, function(x) calc.rolling(x, pollutant, hours,
                                                          new.name, data.capture))

        mydata <- do.call(rbind, mydata)
        mydata
    } else {
        mydata <- calc.rolling(mydata, pollutant, hours, new.name, data.capture)
        mydata
    }
}


daily.mean <- function(mydata) {

    calc.daily <- function(mydata) { ## function to calculate means
        wd <- FALSE
        if ("wd" %in% names(mydata)) wd <- TRUE

        ## select only numeric/interger values
        dates <- mydata$date
        mydata <- mydata[ , sapply(mydata, class) %in% c("numeric", "integer"), drop = FALSE]
        mydata <- data.frame(date = dates, mydata)

        if (wd) {
            mydata$u <- sin(2 * pi * mydata$wd / 360)
            mydata$v <- cos(2 * pi * mydata$wd / 360)
        }

        mydata$date <- as.numeric(as.Date(mydata$date))

        dailymet <- aggregate(subset(mydata, select = -date),
                              mydata["date"], mean, na.rm = TRUE)

        if (wd) {
            ## mean wd (theta)
            dailymet <- within(dailymet, {wd <- as.vector(atan2(u, v) * 360 /2 / pi) })

            ## correct for negative wind directions
            ids <- which(dailymet$wd < 0)  ## ids where wd < 0
            dailymet$wd[ids] <- dailymet$wd[ids] + 360

            dailymet <- subset(dailymet, select = c(-u, -v))
        }
        class(dailymet$date) <- "Date"  ## change back to date
        dailymet
    }

    ## split if several sites
    if ("site" %in% names(mydata)) { ## split by site
        mydata$site <- factor(mydata$site)
        mydata <- split(mydata, mydata$site)
        mydata <- lapply(mydata, function(x) calc.daily(x))
        mydata <- do.call(rbind, mydata)
        mydata
    } else {
        mydata <- calc.daily(mydata)
        mydata
    }
}


## hourly means
hourly.mean <- function(mydata) {

    calc.hourly <- function(mydata) { ## function to calculate means
        wd <- FALSE
        if ("wd" %in% names(mydata)) wd <- TRUE

        ## select only numeric/interger values
        dates <- mydata$date
        mydata <- mydata[ , sapply(mydata, class) %in% c("numeric", "integer"), drop = FALSE]
        mydata <- data.frame(date = dates, mydata)

        if (wd) {
            mydata$u <- sin(2 * pi * mydata$wd / 360)
            mydata$v <- cos(2 * pi * mydata$wd / 360)
        }

        mydata$date <- as.numeric(trunc(mydata$date, "hour"))
        dailymet <- aggregate(subset(mydata, select = -date),
                              mydata["date"], mean, na.rm = TRUE)

        if (wd) {
            ## mean wd (theta)
            dailymet <- within(dailymet, {wd <- as.vector(atan2(u, v) * 360 /2 / pi) })

            ## correct for negative wind directions
            ids <- which(dailymet$wd < 0)  ## ids where wd < 0
            dailymet$wd[ids] <- dailymet$wd[ids] + 360

            dailymet <- subset(dailymet, select = c(-u, -v))
        }
        class(dailymet$date) <- c("POSIXt", "POSIXct")  ## change back to date
        dailymet
    }

    ## split if several sites
    if ("site" %in% names(mydata)) { ## split by site
        mydata$site <- factor(mydata$site)
        mydata <- split(mydata, mydata$site)
        mydata <- lapply(mydata, function(x) calc.hourly(x))
        mydata <- do.call(rbind, mydata)
        mydata
    } else {
        mydata <- calc.hourly(mydata)
        mydata
    }
}





convert.date <- function(mydata, format = "%d/%m/%Y %H:%M") {
    mydata$date <- as.POSIXct(strptime(mydata$date, format = format), "GMT")
    mydata
}


#############################################################################################
## for processing model output. Given a data frame with two variables (and date + maybe others)
## this function will reshape the data suitable for use in many openair functions

prepare.model <- function(mydata, measured = "obs", modelled = "mod", pollutant = "nox") {
    library(reshape)
    if (missing(mydata)) stop("No data frame was supplied!")

    ## make sure there is not a field called site
    if ("site" %in% names(mydata))  mydata <- subset(mydata, select = -site)
    mydata <- melt(mydata, measure.vars = c(measured, modelled))

    ## change name to "site"
    names(mydata)[names(mydata) == "variable"] <- "site"
    names(mydata)[names(mydata) == "value"] <- pollutant
    mydata
}
#############################################################################################
## splits data frame into date chunks. Allows users to supply simple dates and labels
## useful for type = "site", interventions

split.by.date <- function(mydata, dates = "1/1/2003", labels = c("before", "after")) {
    ## if date in format dd/mm/yyyy hh:mm (basic check)
    if (missing(mydata)) stop("No data frame was supplied!")

    if ("site" %in% names(mydata)) {
        if (length(levels(factor(mydata$site))) > 1 & any(duplicated(mydata$date))) {
            stop("More than one site detected - can only deal with a single site at the moment!")
        }
    }

    mydata <- check.prep(mydata, names(mydata), "default")
    ## check there are sufficent labels for number of dates
    if (length(dates) != length(labels) - 1) {
        stop("There is a mis-match between dates and labels. There should be
one more label than date")
    }

    if (length(grep("/", as.character(dates))) > 0) {

        dates <- as.POSIXct(strptime(dates, "%d/%m/%Y"), "GMT")

    } else { ## asume format yyyy-mm-dd

        dates <- as.POSIXct(dates, "GMT")

    }

    mydata$site <- cut(as.numeric(mydata$date), breaks = c(0, as.numeric(dates),
                                                max(mydata$date)), labels = labels,
                       ordered_result = TRUE)
    mydata
}
#############################################################################################

## function to make it easy to use d/m/y format for subsetting by date
select.by.date <- function(mydata, start = "1/1/2008", end = "31/12/2008", year = 2008,
                           month = 1, hour = 1, day = "weekday") {

    if (!missing(start) & !missing(end)) {
        start <- as.POSIXct(strptime(start, format = "%d/%m/%Y"), "GMT")
        end <- as.POSIXct(strptime(end, format = "%d/%m/%Y"), "GMT") + (23 * 3600)
        mydata <- subset(mydata, date >= start & date <= end)
    }

    if (!missing(year)) {
        mydata <- mydata[as.numeric(format(mydata$date, "%Y")) %in% year, ]

    }

    if (!missing(month)) {
        if (is.numeric(month)) {

            mydata <- mydata[as.numeric(format(mydata$date, "%m")) %in% month, ]
        } else {
            mydata <- subset(mydata, substr(tolower(format(date, "%B")), 1, 3) %in%
                             substr(tolower(month), 1, 3))
        }
    }

    if (!missing(hour)) {
        mydata <- mydata[as.numeric(format(mydata$date, "%H")) %in% hour, ]

    }

    if (!missing(day)) {
        days <- day
        if (day == "weekday") days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
        if (day == "weekend") days <- c("Saturday", "Sunday")
        mydata <- subset(mydata, substr(tolower(format(date, "%A")), 1, 3) %in%
                         substr(tolower(days), 1, 3))
    }

    mydata
}


#############################################################################################
## function to import LAQN data from ERG website

import.LAQN <- function(x) {
    aq <- import(x, date.name = "ReadingDateTime", time.name = "ReadingDateTime")
    names(aq)[2] <- "site"
    aq <- subset(aq, select = c(site, date, Species, Value))
    aq <- melt(aq, meas= "Value")
    aq <- cast(aq, ... ~ Species)
    aq <- subset(aq, select = -variable)
    ## if met data
    if (length(which(names(aq) %in% c("WDIR", "WSPD"))) == 2) {
        ids <- which(names(aq) %in% c("WDIR", "WSPD"))
        names(aq)[ids] <- c("wd", "ws")
        aq <- subset(aq, select = -site)
    }
    names(aq) <- tolower(names(aq))
    aq
}
#############################################################################################

useOuterStrips <-function (x, strip = strip.default, strip.left = strip.custom(horizontal = FALSE),
                           strip.lines = 1, strip.left.lines = strip.lines)
                                        # direct copy from latticeExtra
{
    dimx <- dim(x)
    stopifnot(inherits(x, "trellis"))
    stopifnot(length(dimx) == 2)
    opar <- if (is.null(x$par.settings))
        list()
    else x$par.settings
    par.settings <- modifyList(opar, list(layout.heights = if (x$as.table) list(strip = c(strip.lines,
                                                                                rep(0, dimx[2] - 1))) else list(strip = c(rep(0, dimx[2] -
                                                                                                                1), 1)), layout.widths = list(strip.left = c(strip.left.lines,
                                                                                                                                              rep(0, dimx[1] - 1)))))
    if (is.character(strip))
        strip <- get(strip)
    if (is.logical(strip) && strip)
        strip <- strip.default
    new.strip <- if (is.function(strip)) {
        function(which.given, which.panel, var.name, ...) {
            if (which.given == 1)
                strip(which.given = 1, which.panel = which.panel[1],
                      var.name = var.name[1], ...)
        }
    }
    else strip
    if (is.character(strip.left))
        strip.left <- get(strip.left)
    if (is.logical(strip.left) && strip.left)
        strip.left <- strip.custom(horizontal = FALSE)
    new.strip.left <- if (is.function(strip.left)) {
        function(which.given, which.panel, var.name, ...) {
            if (which.given == 2)
                strip.left(which.given = 1, which.panel = which.panel[2],
                           var.name = var.name[2], ...)
        }
    }
    else strip.left
    update(x, par.settings = par.settings, strip = new.strip,
           strip.left = new.strip.left, par.strip.text = list(lines = 0.5),
           layout = dimx)
}

#############################################################################################
### Function to import ERG data from MySQL database airpol
import.ERG <- function(site = "my1", pollutant = "no2",
                       start.date = "2007-01-01", end.date = "2008-01-01") {
    library(RODBC)
    Sys.setenv(tz = "GMT")
    con <- odbcConnect("airpol", uid="root", pwd="scotland")

    getAirpol <- function(site = "my1", pollutant = "no2",
                          start.date = "2007-01-01", end.date = "2008-01-01", type = "site") {

        sqlstr <- paste("select * from ", pollutant, " where date >= '", start.date,
                        "' and date <= '", end.date, "' and site = '",
                        site, "'order by date", sep = "")

        mydata <- sqlQuery(con, sqlstr)

        mydata <- data.frame(date = mydata$date, no2 = mydata[pollutant], site = site)

        mydata
    }

    import.pollutant.airpol <- function(site = "my1", pollutant = "no2",
                                        start.date = "2007-01-01", end.date = "2008-01-01",
                                        type = "pollutant") {

        ## combine pollutants from same site first
        mydata <- lapply(pollutant, function(x) getAirpol(site, x, start.date,
                                                          end.date, type = "pollutant"))

        ## combine into columns
        mydata <- Reduce(function(x, y) merge(x, y, all = TRUE), mydata)

        mydata

    }


    ## combine pollutants from same site first
    mydata <- lapply(site, function(x) import.pollutant.airpol(x, pollutant,
                                                               start.date, end.date,
                                                               type = "site"))
    close(con)
    ## combine into columns
    mydata <- do.call(rbind, mydata)

}

#############################################################################################
make.package <- function(x) {
    detach(package:openair)
    setwd("d:/openair")
    system("R CMD build --binary openair")
    install.packages("d:/openair/openair_0.1.zip", repos = NULL)
    library(openair)
}

#############################################################################################
## make a connection to DCC MySQL db
connectdb <- function(){
    library(RODBC)
    Sys.setenv(tz = "GMT")
    con <- odbcConnect("airpol", uid="root", pwd="scotland")
}

## from Deepayan Sarkar
panel.smooth.spline <-
    function(x, y,
             w = NULL, df, spar = NULL, cv = FALSE,
             lwd = plot.line$lwd, lty = plot.line$lty,col, col.line = plot.line$col,
             type, horizontal = FALSE, all.knots = TRUE,... )
{
    x <- as.numeric(x)
    y <- as.numeric(y)
    ok <- is.finite(x) & is.finite(y)
    if (sum(ok) < 1)
        return()
    if (!missing(col)) {
        if (missing(col.line))
            col.line <- col
    }
    plot.line <- trellis.par.get("plot.line")
    if (horizontal) {
        spline <-
            smooth.spline(y[ok], x[ok],
                          w=w, df=df, spar = spar, cv = cv)
        panel.lines(x = spline$y, y = spline$x, col = col.line,
                    lty = lty, lwd = lwd, ...)
    }
    else {
        spline <-
            smooth.spline(x[ok], y[ok],
                          w=w, df=df, spar = spar, cv = cv)
        panel.lines(x = spline$x, y = spline$y, col = col.line,
                    lty = lty, lwd = lwd, ...)
    }

}




