
stl.plot <- function(mydata, pollutant = "nox", s.wind = 17,
    xlab = "year", ...)  {
    #Does seasonal trend decompostion based on loess smoothing (STL)
    #NOTE! Currently this procedure will fill missing values by the mean of the whole
    # time series

   
    #extract variables of interest
    vars <- c("date", pollutant)
    mydata <- mydata[, vars]
    mydata <- mydata[order(mydata$date), ]
    #rename pollutant to keep code consistent
    colnames(mydata)[2] <- "conc"

    means <- tapply(mydata$conc, format(mydata$date,"%Y-%m"), mean, na.rm = TRUE)

    means <- as.vector(means)

    #simple fill of missing data
    means[which(is.nan(means))] <- mean(means, na.rm = TRUE)

    start.year <- as.numeric(format(mydata$date[1], "%Y"))
    end.year <- as.numeric(format(mydata$date[nrow(mydata)], "%Y"))
    start.month <- as.numeric(format(mydata$date[1], "%m"))
    end.month <- as.numeric(format(mydata$date[nrow(mydata)], "%m"))

    myts <- ts(means, start = c(start.year, start.month),
        end = c(end.year, end.month), frequency = 12)

    ssd <- stl(myts, s.window = s.wind, robust = TRUE, s.degree = 1)

    stlplot <- xyplot(ssd, xlab = xlab, ...,
                panel = function(x, y) {
                panel.abline(v = start.year:end.year, col = "grey85")
                panel.abline(h = 0, col = "grey85")
                panel.xyplot(x, y, type = "l")
                panel.xyplot(x, y, distribute.type = c("p", "h"), cex = 0.2, col = "red")
                })

    print(stlplot)
    invisible(ssd)
}

