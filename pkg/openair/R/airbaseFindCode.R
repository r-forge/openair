##' Helper function to find airbase codes
##'
##' This function helps to identify airbase site codes based on one or
##' more criteria. The criteria include country code, site type, local
##' site code and latitude/longitude ranges.
##' @title Helper function to find EEA airbase codes
##' @param country A character or vector of characters representing country code.
##' @param site.type One of \dQuote{Background}, \dQuote{Traffic},
##' \dQuote{Industrial}, \dQuote{Unknown} representing the type of
##' site.
##' @param local.code A character or vector of characters representing
##' the local site code. For example \dQuote{MY1} is the UK code for
##' Marylebone Road.
##' @param lat The latitude range to select in the form c(lower, upper).
##' @param lon The longitude range to select in the form c(lower, upper).
##' @return A vector of airbase site codes that can be used directly
##' in \code{\link{importAirbase}}.
##' @export
##' @author David Carslaw
##' @examples
##'
##' ## select all sites in Denmark
##' sites <- airbaseFindCode(country = "DK")
##'
##' ## traffic sites in Germany and the UK
##' sites <- airbaseFindCode(country = c("DE", "GB"), site.type = "Background")
airbaseFindCode <- function(country = c("AL", "AT", "BA", "BE", "BG", "CH", "CY", "CZ",
                                "DE", "DK", "EE", "ES", "FI", "FR", "GB", "GR", "HR", "HU",
                                "IE", "IS", "IT", "LI", "LT", "LU","LV", "ME", "MK", "MT",
                                "NL", "NO", "PL", "PT", "RO", "RS", "SE", "SI", "SK", "TR"),
                            site.type = c("Background", "Traffic", "Industrial", "Unknown"),
                            local.code = NA, 
                            lat = c(-90, 90), lon = c(-180, 180)) {

    all <- url("http://www.erg.kcl.ac.uk/downloads/Policy_Reports/airbase/site.info.RData")
    load(all)
                
    all <- site.info

    ## country
    id <- which(all$country.code %in% country)
    res <- all[id, ]

    ## site type
    res <- res[res$site.type %in% site.type, ]

    ## lat/lon
    id <- which(res$lat >= lat[1] & res$lat <= lat[2] & res$lon >= lon[1] &
                res$lon <= lon[2])
    res <- res[id, ]

    if (all(!is.na(local.code))) {
        
        id <- which(toupper(res$station_local_code) %in% toupper(local.code))
        res <- res[id, ]
    }
    
    as.character(res$code)

}
