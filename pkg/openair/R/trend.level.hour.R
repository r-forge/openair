trend.level.hour <-  function(mydata,
                pollutant = "nox",
                limits = c(0, 100),
                statistic = "mean",
                cols = "default",
				main = "",
				auto.text = TRUE,...) {

   

    #extract variables of interest
    vars <- c("date", pollutant)

	# check data
	mydata <- checkPrep(mydata, vars, "default")

    mydata <- mydata[, vars]

    ###Function to deal with completly missing data when doing max ############
    newmax <- function(data) {
              if (all(is.na(data))) {
                  NA
              } else {
                  max(data, na.rm = TRUE)
              }}
    ###########################################################################

    if (statistic == "mean") {
          #average by year/month/wd
          means <- aggregate(mydata[, pollutant], list(format(mydata$date, "%Y-%m"),
             format(mydata$date, "%H")), mean, na.rm = TRUE)
    } else {
          means <- aggregate(mydata[, pollutant], list(format(mydata$date, "%Y-%m"),
             format(mydata$date, "%H")), newmax)
    }

    #change the names to a more readable format
    names(means) <- c("date", "hour", "conc")

    #need to get into year/month/day
    newdate <- as.character(means$date)
    newdate <- paste(newdate,"-01", sep = "")
    newdate <- as.Date(newdate, format = "%Y-%m-%d")
    #add to summary
    means <- cbind(means, newdate)

    month <- as.numeric(format(means$newdate, "%m"))
    year <- as.factor(format(means$newdate, "%Y"))
    means$hour <- as.numeric(means$hour)
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
    breaks = c(breaks, max(means$conc, na.rm = TRUE))

    nlev2 = length(breaks)
    col.scale = breaks

	col <- openColours(cols, (nlev2 - 1))

    levelplot(conc ~ month * hour | year,
            data = means,
			main = quickText(main, auto.text),
            as.table = TRUE,
            col.regions = col,
            at = col.scale,
            scales = list(x = list(labels = make.month.abbs()[c(1, 4, 7, 10)],
                      at = c(1, 4, 7, 10))),...)
}
