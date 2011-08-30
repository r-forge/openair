##' Trajectory plots with conditioning
##'
##' This function plots back trajectories. There are two relation
##' functions: \code{trajPlot} and \code{trajLevel}. These functions
##' require that data are imported using the \code{importTraj}
##' function.
##' @aliases trajPlot trajLevel
##' @usage  trajLevel(mydata, lon = "lon", lat = "lat", pollutant = "pm10",
##'                    method = "level", smooth = TRUE, map = TRUE, lon.inc = 1.5,
##'                       lat.inc = 1.5, aspect = 1, cex = NA,  ...)
##'
##'  trajPlot(mydata, lon = "lon", lat = "lat", pollutant = "pm10",
##'                      method = "scatter", smooth = FALSE, map = TRUE, lon.inc = 1.5,
##'                      lat.inc = 1.5, aspect = 1, cex = 0.1, ...)
##'
##' @param mydata Data frame, the result of importing a trajectory
##' file using \code{importTraj}
##' @param lon Column containing the longitude, as a decimal.
##' @param lat Column containing the latitude, as a decimal.
##' @param pollutant Pollutant to be plotted.
##' @param method For trajectory plots, either "scatter" or
##' "level". The latter option bins the data according to the values
##' of \code{x.inc} and \code{y.inc}.
##' @param smooth Should the trajectory surface be smoothed?
##' @param map Should a base map be drawn? If \code{TRUE} the world
##' base map from the \code{maps} package is used.
##' @param lon.inc The longitude-interval to be used for binning data
##' when \code{method = "level"}.
##' @param lat.inc The latitude-interval to be used for binning data
##' when \code{method = "level"}.
##' @param aspect Aspect for map.
##' @param cex Size of points used to plot back trajectories in
##' \code{trajPlot}, not used in \code{trajLevel}
##' @param ... other arguments to \code{scatterPlot} and \code{cutData}.
##' @export
##' @return NULL
##' @seealso \code{\link{importTraj}}
##' @author David Carslaw
trajLevel <- function(mydata, lon = "lon", lat = "lat", pollutant = "pm10",
                      method = "level", smooth = TRUE, map = TRUE, lon.inc = 1.5,
                      lat.inc = 1.5, aspect = 1, cex = NA,...)  {

    scatterPlot(mydata, x = lon, y = lat, z = pollutant, method = method, smooth = smooth,
                map = map, x.inc = lon.inc, y.inc = lat.inc, aspect = aspect,  ...)

}

trajPlot <- function(mydata, lon = "lon", lat = "lat", pollutant = "pm10",
                     method = "scatter", smooth = FALSE, map = TRUE, lon.inc = 1.5,
                     lat.inc = 1.5, aspect = 1, cex = 0.1, ...)
{

    scatterPlot(mydata, x = lon, y = lat, z = pollutant, method = method, smooth = smooth,
                map = map, x.inc = lon.inc, y.inc = lat.inc, aspect = aspect,
                cex = cex,  ...)

}
