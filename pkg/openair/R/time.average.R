

## Function to flexibly calculate different averagring times for data frames with
## option to also set data.thresh threshold.
## Note that "period" uses those defined in cut.POSIXct e.g. "days", "5 days", and
## is therefore extremely flexible.
## The function will also work with mutiple sites.
## NOTE - will only return numeric data apart from site name

time.average <- function(mydata, period = "days", data.thresh = 0) {
    library(plyr)

    ## pad out missing data
    mydata <- date.pad(mydata)
    
    calc.mean <- function(mydata) { ## function to calculate means
        
        if ("wd" %in% names(mydata)) {
            mydata$u <- sin(2 * pi * mydata$wd / 360)
            mydata$v <- cos(2 * pi * mydata$wd / 360)
        }

        ## cut into sections dependent on period
        mydata$cuts <- cut(mydata$date, period)
        
        newMean <- function(x, data.thresh) {
            ## calculate mean only if above data capture threshold
            if (length(na.omit(x)) >= round(length(x) * data.thresh / 100)) {
                res <- mean(x, na.rm = TRUE)
            } else {
                res <- NA
            }
            res
        }
      
        ## mean date as numeric, to get mean date rather than start date
        mydata$MeanDate <- as.numeric(mydata$date)
        dailymet <- aggregate(mydata[ , sapply(mydata, class) %in% c("numeric", "integer"),
                         drop = FALSE], list(date = mydata$cuts), newMean,
                              data.thresh = data.thresh)

        dailymet$date <- as.POSIXct(dailymet$MeanDate, origin = "1970-01-01", "GMT")     

        if ("wd" %in% names(mydata)) {
            ## mean wd 
            dailymet <- within(dailymet, wd <- as.vector(atan2(u, v) * 360 /2 / pi))

            ## correct for negative wind directions
            ids <- which(dailymet$wd < 0)  ## ids where wd < 0
            dailymet$wd[ids] <- dailymet$wd[ids] + 360

            dailymet <- subset(dailymet, select = c(-u, -v, -MeanDate))
        }

         if ("site" %in% names(mydata)) dailymean$site <- mydata$site[1]
        
        dailymet
    }

    ## split if several sites
    if ("site" %in% names(mydata)) { ## split by site
        mydata$site <- factor(mydata$site)
        mydata <- ddply(mydata, .(site), calc.mean)
        mydata
    } else {
        mydata <- calc.mean(mydata)
        mydata
    }
}
