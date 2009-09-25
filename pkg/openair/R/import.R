import <- function(file = file.choose(),
file.type="csv",
header.at = 1, data.at = 2,
eof.report = NULL,
na.strings = c("", "NA"),
date.name = "date", date.break = "/", date.order = "dmy",
time.name = "date", time.break = ":", time.order = "hm", time.format ="GMT",
is.ws = NULL, is.wd = NULL,
is.site = NULL,
misc.info = NULL,
bad.24 = FALSE, correct.time = NULL,
output = "final"
){

######################
#import() 0.0.2 kr 07-06-2009
#generic import function for openair data
#also intended to act as workhorse for import.wrappers
######################
#history
#bug fix from 0.0.1 (bad.24 POSIXlt enforced to time.format)
######################
#active wrappers:
#import.aurn;
######################
#coding notes
#format over-complex to allow use with multiple similar formats

#####################
#to do:
#robust error handling
#####################
#options:
#more functionality in site args
#call record to comments import(), etc.
#log actions options, e.g. silent, screen, comments, both - current comments only
#is.ws vs date.name rationalisation?
#extra option for is.site (use the is.site as the site name and generate a column replicating this name)

#requires
#na - base packages only

#basics
# sep default csv, ","
if(file.type == "txt") { sep <- "\t" } else { sep <- "," }
#date and time made r names
date.name <- make.names(date.name)
time.name <- make.names(time.name)

#misc info
if(!is.null(misc.info[1])) {
if(is.numeric(misc.info)) {
file.misc <- readLines(file, n = max(misc.info))
file.misc <- file.misc[misc.info]
} else { file.misc <- misc.info }
}

#import names
file.names <- read.table(file, header = FALSE, sep = sep, skip = (header.at - 1), nrows = 1, colClasses = "character")
file.names <- as.character(file.names)

#reset ws, wd, site names if assigned
#before any unique or make.name to simplify in case it conflicts with changes
if(!is.null(is.ws)) { file.names <- gsub(is.ws, "ws", file.names, ignore.case = FALSE) }
if(!is.null(is.wd)) { file.names <- gsub(is.wd, "wd", file.names, ignore.case = FALSE) }
if(!is.null(is.site)) { file.names <- gsub(is.site, "site", file.names, ignore.case = FALSE) }

#import data
file.data <- read.table(file, header = FALSE, sep = sep, skip = (data.at - 1), nrows = -1, na.strings = na.strings, fill = TRUE)

#check for eof (if required)
if(!is.null(eof.report)) {
if(is.na(match(eof.report, as.character(file.data$V1)))==FALSE) {
file.data <- file.data[1:(match(eof.report, as.character(file.data$V1)) - 1),]
}
}

#names reset
names(file.data) <- make.names(file.names, unique =TRUE)

#date and time timeseries

#date
date.order <- gsub("d", paste("%d", date.break, sep=""), date.order, ignore.case = TRUE)
date.order <- gsub("m", paste("%m", date.break, sep = ""), date.order, ignore.case = TRUE)
date.order <- gsub("y", paste("%Y", date.break, sep = ""), date.order, ignore.case = TRUE)
date.order <- substr(date.order, 1, (nchar(date.order) - 1))

#time
time.order <- gsub("h", paste("%H", time.break, sep=""), time.order, ignore.case = TRUE)
time.order <- gsub("m", paste("%M", time.break, sep = ""), time.order, ignore.case = TRUE)
time.order <- gsub("s", paste("%S", time.break, sep = ""), time.order, ignore.case = TRUE)
time.order <- substr(time.order, 1, (nchar(time.order) - 1))

#bad.24 code

#might want to rationalise this bit
#########################
#check in/out if()
#check how bad.time generated

if(date.name==time.name) {
a <- as.POSIXct(strptime(as.character(file.data[,date.name]), format = paste(date.order, time.order, sep=" ")), time.format)
if(bad.24==TRUE) {
bad.time <- gsub("%H", "24", time.order, ignore.case = TRUE)
bad.time <- gsub("%M", "00", bad.time, ignore.case = TRUE)
bad.time <- gsub("%S", "00", bad.time, ignore.case = TRUE)
a[grep(bad.time, file.data[, date.name], ignore.case = TRUE)] <- as.POSIXct(as.POSIXlt(strptime(as.character(file.data[,date.name][grep(bad.time, file.data[, date.name], ignore.case = TRUE)]), format = date.order, tz = time.format))) + (86400)
}
} else {
a <- as.POSIXct(strptime(paste(as.character(file.data[,date.name]),as.character(file.data[,time.name]),sep=" "), format = paste(date.order, time.order, sep=" ")), time.format)
if(bad.24==TRUE) {
bad.time <- gsub("%H", "24", time.order, ignore.case = TRUE)
bad.time <- gsub("%M", "00", bad.time, ignore.case = TRUE)
bad.time <- gsub("%S", "00", bad.time, ignore.case = TRUE)
a[grep(bad.time, file.data[, time.name], ignore.case = TRUE)] <- as.POSIXct(as.POSIXlt(strptime(as.character(file.data[,date.name][grep(bad.time, file.data[, time.name], ignore.case = TRUE)]), format = date.order, tz = time.format))) + (86400)
}
}

#####################
#might want to rationalise
#reports when applied even if it does nothing

if(bad.24==TRUE) {
if(is.null(misc.info)){
misc.info <- 1
file.misc <- "import operation: bad.24 applied (reset 24:00:00 to 00:00:00 next day)"
} else {
file.misc <- c(file.misc, "import operation: bad.24 applied (reset 24:00:00 to 00:00:00 next day)")
}
}

#correct.time

#####################
#might want to rationalise
#reports when applied even if it does nothing

if(!is.null(correct.time)) {
a <- a + correct.time
if(is.null(misc.info)){
misc.info <- 1
file.misc <- paste("import operation: correct.time applied (", correct.time, " seconds)", sep="")
} else {
file.misc <- c(file.misc, paste("import operation: correct.time applied (", correct.time, " seconds)", sep=""))
}
}

#strip out old time and date info
file.data <- file.data[!names(file.data)==date.name]
file.data <- file.data[!names(file.data)==time.name]
file.names2 <- file.names[!(file.names==date.name)]
file.names2 <- file.names2[!(file.names2==time.name)]

#output

##############
#might rething this

#"final" version or "working" to use with wrappers, etc.
#default "final"

if(!output=="working") {
if(!is.null(misc.info)) { comment(file.data) <- file.misc }
ans <- cbind(date = a, file.data)

##  catch missing dates
ids <- which(is.na(ans$date))

if (length(ids) > 0) { ##missing data

    ans <- ans[-ids, ]
    warning(paste("Missing dates detected, removing", length(ids), "lines"))
}

return(ans)
} else {
ans <- list(data = file.data, names = file.names, names2 = file.names2, date = a, ops = list(sep = sep))
if(!is.null(misc.info)) { ans$misc <- file.misc }
return(ans)
}

}
