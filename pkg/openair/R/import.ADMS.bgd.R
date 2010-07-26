import.ADMS.bgd <- function(...) { import.adms.bgd(...) }

import.adms.bgd <- function(file=file.choose()
    , drop.case=TRUE, drop.input.dates=TRUE
    , keep.units=TRUE, test.file.structure=TRUE
    , simplify.names=FALSE
    , ...
){
    bgd <- readLines(file, n = -1)
    bgd <- sub('[[:space:]]+$', '', bgd) #strip out tail spaces
    
    loc.start <- which(tolower(bgd) == "backgroundversion2")
    if(test.file.structure){
        if(length(loc.start)==0){
            stop("File not recognised ADMS.bgd structure\n       [please contact openair if valid]", 
                call. = FALSE)
        }
    }
    if(length(loc.start) > 1){
        warning("Multiple possible variable starts, taking last\n       [please contact openair problems encountered]", 
            call. = FALSE)
        loc.start <- loc.start[length(loc.start)]
    }
    no.var <- suppressWarnings(as.numeric(bgd[loc.start + 1]))[1]
    if(test.file.structure & is.na(no.var)) {
        stop("File not recognised ADMS.bgd structure\n       [please contact openair if valid]", 
            call. = FALSE)
    }
    variables <- bgd[(loc.start + 2) : (loc.start + 1 + no.var)]

    if(simplify.names) {variables <- simplify.names.adms(variables)}

    #drop messy name handling
    variables <- gsub("[.][.]", ".", variables)
    variables <- gsub("^[.]", "", variables)

    if(drop.case) { variables <- tolower(variables) }

    units.start <- which(substr(bgd, 1, 6) == "UNITS:")
    if(length(units.start)==0){
        warning("Data units not extracted from ADMS.bgd\n       [please contact file structure if problems encountered]", 
            call. = FALSE)
        units <- "units: undefined"
    } 
    if(length(units.start) > 1){
        warning("Multiple possible unit starts, taking last\n       [please contact openair problems encountered]", 
            call. = FALSE)
        units.start <- units.start[length(units.start)]
    }
    units <- bgd[(units.start + 1) : (units.start + no.var)]
    if(length(units)==0){
        units <- "units: undefined"
    } else {
        units <- paste("units: ",paste(units, sep = "", collapse = ", "), sep="")
    }
    data.start <- which(substr(bgd, 1, 5) == "DATA:")
    if(length(data.start)==0){
        stop("Data start not not located ADMS.bgd\n       [please contact file structure if problems encountered]", 
            call. = FALSE)
    }
    if(length(data.start) > 1){
        warning("Multiple possible data starts, taking last\n       [please contact openair problems encountered]", 
            call. = FALSE)
        data.start <- data.start[length(data.start)]
    }

    ans <- read.csv(file, header = FALSE, skip = data.start 
        , na.strings = c("", "NA", "-999", "-999.0") 
        , ...)
    ans[] <- lapply(ans, function(x) { replace(x, x == -999, NA) })
    ########################
    #screening for missing data
    #confirm formats, if they get any with bgd files, etc.
    #might not be necessary

    date<- paste(ans[,1], ans[,2], ans[,3], sep = "-")
    date <- as.POSIXct(strptime(date, format = "%Y-%j-%H"), "GMT")
    ans <- cbind(date = date, ans)
    if(length(variables) != ncol(ans) - 4){
        warning("Variable data mismatch, taking shortest\n       [please contact if openair problems encountered]", 
            call. = FALSE)
        variables <- variables[1: min(c(length(variables), ncol(ans) - 4), na.rm = TRUE)]
        ans <- ans[, 1:(length(variables) + 4)]
    }

    names(ans) <- c("date", "bgd.year", "bgd.day", "bgd.hour", variables)
    if(drop.input.dates==TRUE){
        ans <- ans[, c(1, 5:ncol(ans))]
    } 
    if(keep.units) { 
        comment(ans) <- c(comment(ans), units)
    }

    #error handling for bad days
    ids <- which(is.na(ans$date))
    if (length(ids) > 0) {
        if(length(ids)==nrow(ans)) {
            stop("Invalid date (and time) format requested\n       [compare openair import settings and data structure]"
                , call. = FALSE)
        }
        ans <- ans[-ids, ]
        reply <- paste("Missing dates detected, removing", length(ids), "line", sep=" ")
        if(length(ids) > 1) { reply <- paste(reply, "s", sep = "") }
        warning(reply, call. = FALSE)
    }
    print(unlist(sapply(ans, class)))
    ans
}
