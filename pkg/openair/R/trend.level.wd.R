

trend.level.wd <-  function(mydata,
                pollutant = "nox",
                limits = c(0, 100),
                statistic = "mean",
                cols = "default",
				main = "",
				auto.text = TRUE,...) {

    library(lattice)
    library(Hmisc)

    #extract variables of interest
    vars <- c("date", "wd", pollutant)

	# check data
	mydata <- check.prep(mydata, vars, "default")
    mydata <- mydata[, vars]


    ###Function to deal with completly missing data when doing max ############
    newmax <- function(data)  if (all(is.na(data)))  NA else  max(data, na.rm = T)

    #average by year/month/wd
    if (statistic == "mean") {
          #average by year/month/wd
          means <- summarize(mydata[, pollutant], llist(format(mydata$date, "%Y-%m"),
             cut2(mydata$wd, seq(0, 360, 10))), mean, na.rm = TRUE)
    } else {
          means <- summarize(mydata[, pollutant], llist(format(mydata$date, "%Y-%m"),
             cut2(mydata$wd, seq(0, 360, 10))), newmax)
    }


    #change the names to a more readable format
    names(means) <- c("date", "wd", "conc")

    #need to get into year/month/day
    newdate <- as.character(means$date)
    newdate <- paste(newdate,"-01", sep = "")
    newdate <- as.Date(newdate, format = "%Y-%m-%d")
    #add to summary
    means <- cbind(means, newdate)

    month <- as.numeric(format(means$newdate, "%m"))
    year <- as.factor(format(means$newdate, "%Y"))
    means$wd <- as.numeric(means$wd)*10
    means <- cbind(means, month, year)

    means$conc <- means$conc

    #use user defined or own; own based on distribution, with upper limit
     if(missing(limits)) {
                #range between lower and 95th percentile
                breaks = seq(min(means$conc, na.rm = TRUE),
                         quantile(means$conc, probs = 0.95, na.rm = TRUE),
                         length = 100)
         } else {
                breaks = seq(limits[1], limits[2], length = 100)
        }
    #add max at end
    breaks = c(breaks, max(means$conc, na.rm = T))

    nlev2 = length(breaks)
    col.scale = breaks

	col <- open.colours(cols, (nlev2 - 1))

    levelplot(conc ~ month * wd | year,
            data = means,
			main = quick.text(main, auto.text),
            ylab = expression("wind direction (" *degree * ")"),
            as.table = T,
            col.regions = col,
            at = col.scale,
            scales = list(x = list(labels = c("Jan", "Apr", "Jul", "Oct"),
                      at = c(1, 4, 7, 10))),...)
}

