cut.data <- function(mydata, type = "default") {

    ## function to cut data depending on choice of variable
    ## pre-defined types and user-defined types
    ## If another added, then amend check.prep

    ## adds a column "cond"
    conds <- c("default", "year", "hour", "month", "season", "weekday", "ws", "site", "weekend", "monthyear",
               "bstgmt", "gmtbst")

    if (type %in% conds == FALSE) { ## generic, user-defined
        ## split by four quantiles unless it is a factor, in which case keep as is

        if (is.factor(mydata[, type]) | is.character(mydata[, type])) {

            mydata$cond <- as.character(mydata[, type])


        } else {

            mydata$cond <- cut(mydata[, type], unique(quantile(mydata[, type],
                                                               probs = seq(0, 1, length = 5),
                                                               na.rm = TRUE)), include.lowest = TRUE,
                               labels = FALSE)

            temp.levels <- levels(cut(mydata[, type], unique(quantile(mydata[, type],
                                                                      probs = seq(0, 1, length = 5),
                                                                      na.rm = TRUE)),
                                      include.lowest = TRUE))

            mydata$cond <- as.factor(mydata$cond)
            temp.levels <- gsub("[(]|[)]|[[]|[]]", "", temp.levels)
            temp.levels <- gsub("[,]", " to ", temp.levels)
            levels(mydata$cond) = temp.levels
        }

    }

    if (type == "default") {
        ## shows dates (if available)
        ## not always available e.g. scatter.plot
        if ("date" %in% names(mydata)) {

            mydata$cond <- paste(format(min(mydata$date), "%d %B %Y"), " to ",
                                 format(max(mydata$date), "%d %B %Y"), sep = "")
            ## order the data by date
            mydata <- mydata[order(mydata$date), ]

        } else {
            mydata$cond <- "all data"
        }

    }

    if (type == "year") mydata$cond <- format(mydata$date, "%Y")

    if (type == "hour") mydata$cond <- format(mydata$date, "%H")

    if (type == "month") {mydata$cond <- format(mydata$date, "%B")
                          mydata$cond <- ordered(mydata$cond, levels = month.name)
                          period <- "annual"} #does not make sense otherwise

    if (type == "monthyear") {
        mydata$cond <- format(mydata$date, "%B %Y")
        mydata$cond <- ordered(mydata$cond, levels = unique(mydata$cond))
    }

    if (type == "season") {
        mydata$cond <- "winter" ## define all as winter first, then assign others
        ids <- which(as.numeric(format(mydata$date, "%m")) %in% 3:5)
        mydata$cond[ids] <- "spring"
        ids <- which(as.numeric(format(mydata$date, "%m")) %in% 6:8)
        mydata$cond[ids] <- "summer"
        ids <- which(as.numeric(format(mydata$date, "%m")) %in% 9:11)
        mydata$cond[ids] <- "autumn"
        mydata$cond <- ordered(mydata$cond, levels =c("spring", "summer", "autumn", "winter"))
        period <- "annual"
    } #does not make sense otherwise

    if (type == "weekend") {
        ## split by weekend/weekday
        weekday <- select.by.date(mydata, day = "weekday")
        weekday$cond <- "weekday"
        weekend <- select.by.date(mydata, day = "weekend")
        weekend$cond <- "weekend"

        mydata <- rbind(weekday, weekend)

    }

    if (type == "weekday") {
        mydata$cond <- format(mydata$date, "%A")
        mydata$cond <- ordered(mydata$cond, levels = weekday.name)
    }

    if (type == "wd") {

        mydata$cond <- cut(mydata$wd, breaks = seq(22.5, 382.5, 45),
                           labels =c("NE", "E", "SE", "S", "SW", "W", "NW", "N"))
        mydata$cond[is.na(mydata$cond)] <- "N" # for wd < 22.5
        mydata$cond <- ordered(mydata$cond, levels = c("NW", "N", "NE",
                                            "W", "E", "SW", "S", "SE"))}

    if (type == "ws") {mydata$cond <- cut(mydata$ws, breaks = quantile(mydata$ws,
                                                     probs = 0:8/8, na.rm = TRUE))
                       ws.levels = levels(mydata$cond)
                       ws.levels <- gsub("[,]", " to ", ws.levels)
                       ws.levels <- gsub("[(]|[)]|[[]|[]]", "", ws.levels)
                       levels(mydata$cond) <- ws.levels
                   }

    if (type == "site") mydata$cond <- mydata$site

    if (type == "gmtbst" | type == "bstgmt") {
        ## how to extract BST/GMT
        ## first format date in local time
        mydata$date <- format(mydata$date, usetz = TRUE, tz = "Europe/London")
        ## extract ids where BST/GMT
        id.BST <- grep("BST", mydata$date)
        id.GMT <- grep("GMT", mydata$date)

        bst <- mydata[id.BST, ]
        bst$cond <- "BST hours"

        gmt <- mydata[id.GMT, ]
        gmt$cond <- "GMT hours"
        
        mydata <- rbind.fill(bst, gmt)
        mydata$date <- as.POSIXct(mydata$date, "GMT")
        mydata <- mydata[order(mydata$date), ]

    }

    mydata

}
