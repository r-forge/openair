trendLevelHour <- function(mydata, ...) {
   trendLevel(mydata, ...)
}

trendLevelWd <- function(mydata, 
   y = "wd", ylab = "wind direction (degrees)", ...) {
   trendLevel(mydata, y = y, ylab = ylab, ...)
}

trendLevel <- function(mydata, 
    pollutant = "nox",
    x = "month", xlab = x,
    y = "hour", ylab = y,
    type = "year", 
    limits = c(0, 100), 
    statistic = c("mean", "max"), 
    cols = "default", 
    main = "", 
    auto.text = TRUE,
    fun.args = NULL,
    output = c("data", "graph"),
    ...) 
{

   #Generic levelplot function for summarises large data sets
   #kr v.01
   #based on previous trend.level.hour and trend.level.wd functions by dcc

   #examples
   ##trendLevel(mydata) #old trend.level.hour
   ##trendLevel(mydata, y = "wd") #old trend.level.wd nearly
   ##trendLevel(mydata, y = "wd", ylab = "wind direction (degrees)")
   ##stupid stuff you can now do
   ##trendLevel(mydata, x=hour, y=wd)
   ##trendLevel(mydata, x=hour, y=wd, type=month)

   #suggestions 
   ############
   #check.valid handles robustly without warning
   ##could add an extra message to say: I'm treating this as that...?
   #fun not statistic because these do not have to be statistics
   ##rethink?
   #pollutant handling currently treats all as character and looks in mydata
   ##might want to rethink this
   #x, y and type current only allow presets.
   ##see allowed.cond below ####2
   ##could allow pollutant with appropriate handling
   ##that could significantly extend this scope of this function
   #pollutant, x, y, type cannot match 
   ##see ####3
   ##the error messaging could be tighter

   #update notes 
   ##############
   #if you add statistic options above
   ## add in associated stat.fun above ####1
   #if you add x,y,type options
   ## make sure checkPrep knows ####4
   #removed substitute from second check.valid option
   #multi enviornment calls mucking up
   ## compare with pems variation

   #to do
   ###############
   #output newdata should be labelled in a more user-friendly format

   #setup
   check.valid <- function(a, x, y){
      if(length(x)>1) x <- x[1] #take first as default
      if(is.null(x)){
         stop(paste("\ttrendLevel does not allow 'NULL' ", a, " option.",
            "\n\t[suggest one of following: ", paste(y, collapse=", "),"]", sep="")
         , call.=FALSE)
      } 
      out <- y[pmatch(x, y)] #match to options
      if(is.na(out)){
         stop(paste("\ttrendLevel did not recognise ", a, " term '", x,
            "'.\n\t[suggest one of following: ", paste(y, collapse=", "),"]", sep="")
         , call.=FALSE)
      }
      #code here for shorten cases x != out
      out
   }

   ##output handling
   output <- check.valid("output", output, eval(formals(trendLevel)$output))

   ##pollutant handling
   pollutant <- check.valid("pollutant", 
                            pollutant, 
                            names(mydata)[names(mydata) != "date"])

   ##x, y, type handling
   ####2
   allowed.cond <- c("hour", "month", "year", "wd")
   x <- check.valid("x", 
                    x, 
                    allowed.cond)
   y <- check.valid("y", 
                    y, 
                    allowed.cond)
   type <- check.valid("type", 
                    type, 
                    allowed.cond)

   #check pollutant, x, y and type do not match
   ##including pollutant in case we allow pollutants as conditioning options later
   ####3
   temp <- unique(c(pollutant, x, y, type)[duplicated(c(pollutant, x, y, type))])
   if(length(temp)>0){
      stop(paste("\ttrendLevel could not rationalise plot structure.",
         "\n\t[duplicate term(s) in pollutant, x, y, type structure]",
         "\n\t[term(s): ", paste(temp, collapse=", "),"]", sep="")
      , call.=FALSE)
   }

   ##statistic handling
   if(any(is(statistic) == "character") | any(is(statistic) == "function")){
      if(any(is(statistic) == "character")){
         #character settings
         statistic <- check.valid("statistic", 
                                  statistic, 
                                  eval(formals(trendLevel)$statistic))
         if(statistic=="mean") {
            stat.fun <- mean
            fun.args <- list(na.rm=TRUE)
         }
         if(statistic=="max") {
            stat.fun <- function(x, ...){
                           if(all(is.na(x))) { NA } else { max(x, ...) }
                        }
            fun.args <- list(na.rm=TRUE)
         }
   ####1
      } else {
         #functions
         ##robustly handles functions that return more than 1 value
         stat.fun <- function(x, ...) { statistic(x, ...)[1] }       
      }     
   } else {
      stop(paste("\ttrendLevel could not apply statistic option '", substitute(statistic),
         "'.\n\t[suggest valid function or character vector]", 
         "\n\t[currect character vectors options: '", 
         paste(eval(formals(trendLevel)$statistic), collapse="', '"),"']", sep="")
      , call.=FALSE)
   }

   #checkPrep
   ####4
   vars <- c("date", pollutant)
   if("wd" %in% c(x,y,type)) vars <- c(vars, "wd")
   mydata <- checkPrep(mydata, vars, "default")
   mydata <- mydata[, vars] #why?

   #x, y, type settings for summarize
   make.plot.object <- function(x){
      if(x=="year") {
         a <- format(mydata$date, "%Y")
         labels.at <- pretty(a)
         labels <- labels.at
      }
      if(x=="month") {
         a <- format(mydata$date, "%m")
         labels.at <- c(1, 4, 7, 10)
         labels <- make.month.abbs()[labels.at]
      }
      if(x=="hour") {
         a <- format(mydata$date, "%H")
         labels.at <- pretty(a)
         labels <- labels.at
       }
      if(x=="wd") {
         a <- cut(mydata$wd, seq(0, 360, 10))
         labels.at <- c(9, 18, 27)
         labels <- labels.at * 10
      }
      return(list(a=a, labels=labels, labels.at = labels.at))
      stop("ICK")
   }

   y.f <- make.plot.object(y)
   x.f <- make.plot.object(x)

   #restructure/aggregate data
   ##use do.call/function to handle fun.args
   ##using ... may cause conflicts 
   ##So, here that is reserved for graphic terms to lattice 
   temp.fun <- function(...){
                  aggregate(mydata[, pollutant], 
                  list(paste(make.plot.object(type)$a, x.f$a, sep="-"), y.f$a), 
                  stat.fun, ...)
               }
   newdata <- do.call(temp.fun, fun.args)

   names(newdata) <- c("type", "y", "value")
   temp <- unlist(strsplit(newdata$type,"-"))
   newdata$x <- as.numeric(temp[seq(2, length(temp), by = 2)])
   newdata$type <- as.factor(temp[seq(1, length(temp), by = 2)])
   newdata$y <- as.numeric(newdata$y)

   #this needs fixing
   ######################
   #does work as code would suggest
   ##ie ignores formals setting because it is looking in ...

   if (missing(limits)) {
       breaks = seq(min(newdata$value, na.rm = TRUE), quantile(newdata$value, 
           probs = 0.95, na.rm = TRUE), length = 100)
   } else {
       breaks = seq(limits[1], limits[2], length = 100)
   }
   breaks = c(breaks, max(newdata$value, na.rm = TRUE))
   nlev2 = length(breaks)
   col.scale = breaks
   col <- openColours(cols, (nlev2 - 1))
   ##########################

   plt <- levelplot(value ~ x * y | type, data = newdata, main = quickText(main, 
                    auto.text), as.table = TRUE, col.regions = col, at = col.scale,
                    xlab = quickText(xlab, auto.text), ylab = quickText(ylab, auto.text),
                    scales = list(
                       x = list(labels = x.f$labels, at = x.f$labels.at),
                       y = list(labels = y.f$labels, at = y.f$labels.at))
                    , ...
   )

   if(output=="data") {
      print(plt)
      invisible(newdata)
   } else {
      print(plt)
   }

}
