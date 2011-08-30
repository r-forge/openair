
##' Import pre-calculated HYSPLIT 96-hour back trajectories
##'
##' This function imports pre-calculated back trajectories using the
##' HYSPLIT trajectory model (Hybrid Single Particle Lagrangian
##' Integrated Trajectory Model
##' \url{http://ready.arl.noaa.gov/HYSPLIT.php}). Back trajectories
##' provide some very useful information for air quality data
##' analysis. However, while they are commonly calculated by
##' researchers it is generally difficult for them to be calculated on
##' a routine basis and used easily. In addition, the availability of
##' back trajectories over several years can be very useful, but again
##' difficult to calculate. \cr\cr We are extremely grateful to NOAA
##' for making HYSPLIT available to produce back trajectories in an
##' open way.
##'
##'
##' @param site Site code of the network site to import e.g. "my1" is
##'   Marylebone Road. Several sites can be imported with \code{site = c("my1",
##'   "kc1")} --- to import Marylebone Road and North Kensignton for example.
##' @param year Year or years to import. To import a sequence of years from
##'   1990 to 2000 use \code{year = 1990:2000}. To import several specfic years
##'   use \code{year = c(1990, 1995, 2000)} for example.
##'
##' Access to reliable and free meteorological data is problematic.
##' @export
##' @return Returns a data frame with pre-calculated back trajectories.
##' @author David Carslaw
##' @note The trajectories were run using the February 2011 HYSPLIT model.
##'  The function is primarily written to investigate a single
##' site at a time for a single year. The trajectory files are quite
##' large and care should be exercised when importing several years and/or sites.
##' @seealso \code{\link{trajPlot}}, \code{\link{importAURN}},
##' \code{\link{importKCL}},\code{\link{importADMS}},
##' \code{\link{importSAQN}}
##' @keywords methods
##' @examples
##'
##'
##' ## import trajectory data for London in 2009
##' \dontrun{mytraj <- importTraj(site = "london", year = 2009)}
##'
##'
##'
importTraj <- function(site = "London", year = 2009) {

    site <- tolower(site)

    ## RData files to import
    files <- lapply(site, function (x) paste("http://www.erg.kcl.ac.uk/downloads/Policy_Reports/Traj/", x, year, ".RData", sep = ""))
    files <- do.call(c, files)

    thedata <- suppressWarnings(lapply(files, function(file) tryCatch({get(load(url(file)))}, error = function(ex) {cat(file, "does not exist - ignoring that one.\n")})))
    thedata <- do.call(rbind.fill, thedata)


  #  thedata$code <- thedata$site

  #  thedata$site <- factor(thedata$site, labels = site.name, levels = site)


    ## change names
    names(thedata) <- tolower(names(thedata))



    thedata
}
