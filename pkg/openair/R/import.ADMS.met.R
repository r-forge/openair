
import.ADMS.met <- function(filename = file.choose()) {
    met <- read.csv(filename, nrows = 1, header=T)
    variables <- met[1,1]
    met <- read.csv(filename, nrows= variables + 1, header = TRUE)
    variables <- met[2:(variables +1),]

    met <- read.csv(filename, skip = length(variables) + 3, header = FALSE,
                    na.strings = c("-999", "-999.0"))

    names(met) <- tolower(variables)
    met$date <- paste(met$year, met$tday, met$thour, sep = "-")
    met$date <- as.POSIXct(strptime(met$date, format = "%Y-%j-%H"), "GMT")

    if ("t0c" %in% names(met)) {
        id <- which(names(met) == "t0c")
        names(met)[id] <- "temp"
    }

    if ("u" %in% names(met)) {
        id <- which(names(met) == "u")
        names(met)[id] <- "ws"
    }

    if ("phi" %in% names(met)) {
        id <- which(names(met) == "phi")
        names(met)[id] <- "wd"
    }

    met[] <- lapply(met, function(x){replace(x, x == -999, NA)})
     ## remove variables where all are NA
    met <- met[ , sapply(met, function(x) !all(is.na(x)))]
    met

}
