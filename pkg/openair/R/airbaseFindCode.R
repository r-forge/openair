##' Helper function to find airbase site codes
##'
##' This function helps to identify airbase site codes based on one or
##' more criteria. The criteria include country code, site type, local
##' site code and latitude/longitude ranges.
##' @title Helper function to find EEA airbase site codes
##' @param country A character or vector of characters representing country code.
##' @param site.type One of \dQuote{background}, \dQuote{traffic},
##' \dQuote{industrial}, \dQuote{unknown} representing the type of
##' site.
##' @param area.type The type of area in which the site is
##' located. Can be \dQuote{rural}, \dQuote{urban}, \dQuote{suburban},
##' \dQuote{unknown}.
##' @param local.code A character or vector of characters representing
##' the local site code. For example \dQuote{MY1} is the UK code for
##' Marylebone Road.
##' @param city A city name to search --- using character matching
##' (\code{grep}). The search string can be upper or lower case
##' e.g. \code{city = "london"}. It is also possible to use
##' regular expressions. For example, to extract sites in Copenhagen or
##' Barcelona use \code{city = "copenhagen|barcelona"}. Note that by
##' default any matching characters are returned, so \code{city =
##' "london"} would also return Londonderry (Northern Ireland).
##'
##' Regular expression searches are very powerfull and potentially
##' complicated. However there are a few useful tips. To match the
##' beginning of a name use \sQuote{^}. So \code{city = "^london"}
##' would return London and Londonderry (both begin with
##' \sQuote{london}. To match the end of a name use \sQuote{$}, so
##' \code{city = "london$"} would just return London but not
##' Londonderry.
##'
##' The cities chosen are printed to screen to make it easy to check
##' (and refine) the selected sites.
##' @param lat The latitude range to select in the form c(lower, upper).
##' @param lon The longitude range to select in the form c(lower, upper).
##' @return A vector of airbase site codes that can be used directly
##' in \code{\link{importAirbase}}.
##' @export
##' @author David Carslaw
##' @examples
##'
##' ## select all sites in Denmark
##' \dontrun{sites <- airbaseFindCode(country = "DK")
##'
##' ## traffic sites in Germany and the UK
##' sites <- airbaseFindCode(country = c("DE", "GB"), site.type = "traffic")}
airbaseFindCode <- function(country = c("AL", "AT", "BA", "BE", "BG", "CH", "CY", "CZ",
                                "DE", "DK", "EE", "ES", "FI", "FR", "GB", "GR", "HR", "HU",
                                "IE", "IS", "IT", "LI", "LT", "LU","LV", "ME", "MK", "MT",
                                "NL", "NO", "PL", "PT", "RO", "RS", "SE", "SI", "SK", "TR"),
                            site.type = c("background", "traffic", "industrial", "unknown"),
                            area.type = c("rural", "urban", "suburban", "unknown"), 
                            local.code = NA, city = NA, 
                            lat = c(-90, 90), lon = c(-180, 180)) {


    site.info <- NULL
    
    all <- url("http://www.erg.kcl.ac.uk/downloads/Policy_Reports/airbase/site.info.RData")
    load(all)
                
    all <- site.info

    ## country
    id <- which(toupper(all$country.code) %in% toupper(country))
    res <- all[id, ]

    ## site type
    res <- res[toupper(res$site.type) %in% toupper(site.type) , ]

    ## city, using grep
    if (!is.na(city)) {
        id <- grep(city, res$city, ignore.case = TRUE)
        cities <- data.frame(code = res$code[id], city = res$city[id])
        print(cities)
        res <- res[id, ]
        
        
    }

    ## area type
    res <- res[toupper(res$station_type_of_area) %in% toupper(area.type) , ]

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
