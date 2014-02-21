##' Get information about airbase sites and instruments
##'
##' This function compiles key information about airbase sites
##' including the site type, species measured and the instruments and
##' techniques used.
##'
##' @title Get information about airbase sites and instruments
##' @param site Site code(s) of the sites to be imported. Can be upper or lower case.
##' @export
##' @return Returns a data frame containing key information about airbase site(s).
##' @seealso \code{\link{importAirbase}},
##' \code{\link{airbaseFindCode}}, \code{\link{airbaseStats}}
##' @author David Carslaw
airbaseInfo <- function(site = "gb0620a") {

    ## get rid of R check annoyances
    meas.config <- NULL; code <- NULL

    site <- toupper(site)

    load(url("http://www.erg.kcl.ac.uk/downloads/Policy_Reports/airbase/meas.config.RData"))

    dat <- subset(meas.config, code %in% site)
    dat
}
