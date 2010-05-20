import.ADMS.met <- function(...) { import.adms.met(...) }

import.adms.met <- function (file = file.choose(), drop.case = TRUE, drop.input.dates = TRUE, 
    test.file.structure = TRUE, simplify.names = TRUE, ...) 
{
    met <- readLines(file, n = -1)
    met <- sub('[[:space:]]+$', '', met) #strip out tail spaces
    loc.start <- which(met == "VARIABLES:")
    if(test.file.structure){
        if(length(loc.start)==0){
            stop("File not recognised ADMS.met structure\n       [please contact openair if valid]", 
                call. = FALSE)
        }
    }
    if(length(loc.start) > 1){
        warning("Multiple possible variable starts, taking last\n       [please contact openair problems encountered]", 
            call. = FALSE)
        loc.start <- loc.start[length(loc.start)]
    }
    variables <- suppressWarnings(as.numeric(met[loc.start + 1]))[1]
    if(test.file.structure & is.na(variables)) {
        stop("File not recognised ADMS.met structure\n       [please contact openair if valid]", 
            call. = FALSE)
    }
    variables <- met[(loc.start + 2) : (loc.start + 1 + variables)]

    data.start <- which(met == "DATA:")
    if(test.file.structure){
        if(length(data.start)==0){
            stop("File not recognised ADMS.met structure\n       [please contact openair if valid]", 
                call. = FALSE)
        }
    }
    if(length(data.start) > 1){
        warning("Multiple possible data starts, taking last\n       [please contact openair if problems encountered]", 
            call. = FALSE)
        data.start <- data.start[length(data.start)]
    }

    met <- read.csv(file, skip = data.start, header = FALSE, na.strings = c("-999", 
        "-999.0"))
    met[] <- lapply(met, function(x) {
        replace(x, x == -999, NA)
    })
    met <- met[, sapply(met, function(x) !all(is.na(x)))]
    if(length(variables) != ncol(met)){
        warning("Variable data mismatch, taking shortest\n       [please contact if openair problems encountered]", 
            call. = FALSE)
        variables <- variables[1: min(c(length(variables), ncol(met)), na.rm = TRUE)]
        met <- met[, 1:length(variables)]
    }
    names(met) <- make.names(variables, unique = TRUE)

    #multiple year day hour name options
    fun.temp <- function(x, y, z){
        if(all(!y %in% names(x))){
            stop(paste(z, 
                " not extracted\n       [please contact openair if valid file]", 
                sep = ""), call. = FALSE)
        } 
        ans <- x[, y[y %in% names(x)]]
        if(!is.null(ncol(ans))) { ans <- ans[, 1] }
        ans
    }
    year <- fun.temp(met, c("YEAR"), "year")
    day <- fun.temp(met, c("DAY", "TDAY"), "day")
    hour <- fun.temp(met, c("HOUR", "THOUR"), "hour")

    met <- cbind(date = paste(year, day, hour, sep = "-"), met)
    met$date <- as.POSIXct(strptime(met$date, format = "%Y-%j-%H"), 
        "GMT")
    if (drop.input.dates) {
        met <- met[, !names(met) %in% 
            c("YEAR", "TDAY", "THOUR", "DAY", "HOUR", "MONTH", "DAY.OF.MONTH")]
    }
    if (simplify.names) {
        fun.temp <- function(x, y, z){
             if(y %in% names(x)){
                  names(x)[which(names(x) == y)] <- z
             }
             x
        }
        met <- fun.temp(met, "T0C", "temp") 
        met <- fun.temp(met, "TEMPERATURE..C.", "temp") 
        met <- fun.temp(met, "TEMPERATURE", "temp") 
        met <- fun.temp(met, "U", "ws")
        met <- fun.temp(met, "WIND.SPEED", "ws")
        met <- fun.temp(met, "PHI", "wd")
        met <- fun.temp(met, "WIND.DIRECTION..DEGREES.", "wd")
        met <- fun.temp(met, "WIND.DIRN", "wd")
    }

    #drop messy name handling
    names(met) <- gsub("[.][.]", ".", names(met))
    names(met) <- gsub("^[.]", "", names(met))

    if (drop.case) {
        names(met) <- tolower(names(met))
    }
    met[] <- lapply(met, function(x) {
        replace(x, x == -999, NA)
    })
    ids <- which(is.na(met$date))
    if (length(ids) > 0) {
        if (length(ids) == nrow(met)) {
            stop("Invalid date (and time) format requested\n       [compare openair import settings and data structure]", 
                call. = FALSE)
        }
        met <- met[-ids, ]
        reply <- paste("Missing dates detected, removing", length(ids), 
            "line", sep = " ")
        if (length(ids) > 1) {
            reply <- paste(reply, "s", sep = "")
        }
        warning(reply, call. = FALSE)
    }
    print(unlist(sapply(met, class)))
    met
}