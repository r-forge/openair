
import.ADMS.met <- function(...) { import.adms.met(...) }

import.adms.met <- function(file = file.choose()
         , drop.case=TRUE, drop.input.dates=TRUE
         , test.file.structure = TRUE
         , simplify.names=TRUE
         , ...
) {
    met <- read.csv(file, nrows = 2, header = FALSE)

    test <- as.character(met[1,1])[1]
    variables <- suppressWarnings(as.numeric(as.character(met[2,1])))

    #file structure test 1
    allowed.formats <- c("VARIABLES:")
    if(test.file.structure){
      #check a number
      if( !test %in% allowed.formats | is.na(variables) ) {
        stop("File not recognised ADMS.met structure\n       [please contact openair if valid]"
          , call. = FALSE
        )
      }
    }

    met <- read.csv(file, nrows= variables + 2, header = TRUE)

    test <- as.character(met[variables+2,1])[1]
    variables <- as.character(met[2:(variables +1),])

    #file structure test 2
    if(test.file.structure){
      #check data where should be
      if( test!="DATA:" ) {
        stop("File not recognised ADMS.met structure\n       [please contact openair if valid]"
          , call. = FALSE
        )
      }
    }

    met <- read.csv(file, skip = length(variables) + 3, header = FALSE,
                    na.strings = c("-999", "-999.0"))
    ## remove variables where all row are NA
    met <- met[ , sapply(met, function(x) !all(is.na(x)))]
    names(met) <- make.names(variables, unique=TRUE) 
    met <- cbind(date = paste(met$YEAR, met$TDAY, met$THOUR, sep = "-"), met)
    met$date <- as.POSIXct(strptime(met$date, format = "%Y-%j-%H"), "GMT")

    if(drop.input.dates){
      met <- met[,!names(met) %in% c("YEAR", "TDAY", "THOUR")]
    }

    if(simplify.names){
      if ("T0C" %in% names(met)) {
        id <- which(names(met) == "T0C")
        names(met)[id] <- "temp"
      }
      if ("U" %in% names(met)) {
        id <- which(names(met) == "U")
        names(met)[id] <- "ws"
      }
      if ("PHI" %in% names(met)) {
        id <- which(names(met) == "PHI")
        names(met)[id] <- "wd"
      }
    }

    if(drop.case){
      names(met) <- tolower(names(met))
    } 
   

   #tidy for export
    met[] <- lapply(met, function(x){replace(x, x == -999, NA)})
    ##error handling for bad days
    ids <- which(is.na(met$date))
    if (length(ids) > 0) {
      if(length(ids)==nrow(met)) {
        stop("Invalid date (and time) format requested\n       [compare openair import settings and data structure]"
          , call. = FALSE
        )
      }
      met <- met[-ids, ]
      reply <- paste("Missing dates detected, removing", length(ids), "line", sep=" ")
      if(length(ids)>1) { reply <- paste(reply,"s",sep="") }
      warning(reply, call. = FALSE)
    }

    #report met stucture   
    print(unlist(sapply(met, class)))
    met
}
