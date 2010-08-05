

trend.hour.weekday <-  function(mydata,
                pollutant = "nox",
                limits = c(0, 100),
                line.colour = "darkorange2",
                fill.colour = "lightgoldenrod",
		ylab = pollutant,
		xlab = "hour of day", 
                main = "",
		auto.text = TRUE,...) {
  


    trend.hour.weekday.plot <- function(mydata, pollutant, limits, line.colour,
                fill.colour,...) {

    #extract variables of interest
    vars <- c("date", pollutant)
    mydata <- mydata[, vars]
    mydata <- mydata[order(mydata$date), ]
    
    colnames(mydata)[2] <- "conc"

    year <- as.factor(format(mydata$date,"%Y"))
    hour <- as.numeric(format(mydata$date,"%H"))
    weekday <- format(mydata$date, "%A")
    
    mydata <- cbind(mydata, year, weekday, hour)

    #summarize data
  #  s <- summarize(mydata$conc, llist(year, weekday, hour), smean.cl.normal)

    s <- with(s, aggregate(s, list(year = year, weekday = weekday, hour = hour),
            errorInMean))
    
    s$weekday <- ordered(s$weekday, levels = make.weekday.names())

  xyplot(mydata.conc ~ hour | year + weekday,
      data = s,
      col = line.colour,
      type = "l",
      as.table = TRUE,
	  main = quickText(main, auto.text),
	  ylab = quickText(ylab, auto.text),
      scales = list(x = list(at = seq(0, 24, 6))),
      xlab = xlab,#...,

      panel = function(x, y, subscripts,...) {

      #for polygon
        x1 <- s$hour[subscripts]
        x2 <- x1
        y1 <- s$Lower[subscripts]
        y2 <- s$Upper[subscripts]

        #clever polygon that can handle missing data
          for(i in seq(2, length(x1)))

          if (!any(is.na(y2[c(i - 1, i)]))){
            lpolygon(c(x1[i - 1], x1[i], x2[i], x2[i-1]),
                c(y1[i - 1], y1[i], y2[i], y2[i-1]),
                col = fill.colour, border = 0) }

              panel.grid(h = -1, v = 0, lwd = 0.5, col = "grey85")
              panel.abline(v = seq(0, 24, 6), col = "grey85")
              panel.xyplot(x, y, lwd = 2,...)
         }
    )}

    plt <- trend.hour.weekday.plot(mydata, pollutant, limits, line.colour,
                fill.colour,...)

    useOuterStrips(plt, strip = strip.custom(par.strip.text = list(cex = 0.8)),
    strip.left = strip.custom(par.strip.text = list(cex = 0.8)))
}




