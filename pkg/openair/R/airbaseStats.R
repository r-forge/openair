##' Import pre-calculated airbase statistics
##'
##' The airbase database makes available detailed pre-calculated
##' statsitics for all species, sites and years. The
##' \code{airbaseStats} function provides these data.
##'
##' The data are imported depending on teh statistic chosen --- see
##' the list of available statistics in the \code{statistics} option.
##'
##' Once the data have been imported it is then possible to subset the
##' data in various ways e.g. by extracting a particular species with
##' a defined data capture threshold.
##' @title Import pre-calculated airbase statistics
##' @param statistic A \emph{single} choice from \dQuote{P50},
##' \dQuote{Mean}, \dQuote{P95}, \dQuote{P98}, \dQuote{Max},
##' \dQuote{Max36}, \dQuote{Max8}, \dQuote{Days.c.50.},
##' \dQuote{Max26}, \dQuote{Days.c.120.},\dQuote{SOMO35},
##' \dQuote{AOT40}, \dQuote{Max19}, \dQuote{Hours.c.200.},
##' \dQuote{Max4}, \dQuote{Days.c.125.}, \dQuote{P99_9},
##' \dQuote{Max25}, \dQuote{Hours.c.350.}.
##' @param add Additional fields to add to the returned data frame. By
##' default the site type, latitude and logitude are returned. Other
##' useful options include \dQuote{city}, \dQuote{site} (site name),
##' \dQuote{country}, \dQuote{EMEP_station} and \dQuote{altitude}.
##' @return A data frame of airbase sites with the statsitics chosen
##' and for all species.
##' @export
##' @author David Carslaw
airbaseStats <- function(statistic = "Mean", add = c("lat", "lon", "site.type")) {

    site.type <- code <- lat <- lon <- site.info <- NULL

    stat.name <- match.arg(statistic, c("P50", "Mean", "P95", "P98", "Max", "Max36",
                                        "Max8", "Days.c.50.", "Max26", "Days.c.120.",
                                        "SOMO35", "AOT40", "Max19", "Hours.c.200.",
                                        "Max4", "Days.c.125.", "P99_9", "Max25",
                                        "Hours.c.350."))
    

    fileName <- paste0("http://www.erg.kcl.ac.uk/downloads/Policy_Reports/airbase/",
                       stat.name, ".RData")

    con <- url(fileName)
    load(con) ## brings in data frame dat
    close(con)

    if (length(add) > 0 ) {
        ## add other fields
        fileName <- "http://www.erg.kcl.ac.uk/downloads/Policy_Reports/airbase/site.info.RData"

        con <- url(fileName)
        load(con) ## brings in data frame site.info
        close(con)

        site.info <- site.info[, c("code", add)] ## just the fields needed
        
        dat <- merge(dat, site.info, by = "code")
    }
    
    dat
    
}
