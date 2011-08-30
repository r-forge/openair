\name{trajLevel}
\alias{trajLevel}
\alias{trajPlot}
\title{Trajectory plots with conditioning}
\usage{
  trajLevel(mydata, lon = "lon", lat = "lat", pollutant =
  "pm10", method = "level", smooth = TRUE, map = TRUE,
  lon.inc = 1.5, lat.inc = 1.5, aspect = 1, cex = NA, ...)

  trajPlot(mydata, lon = "lon", lat = "lat", pollutant =
  "pm10", method = "scatter", smooth = FALSE, map = TRUE,
  lon.inc = 1.5, lat.inc = 1.5, aspect = 1, cex = 0.1, ...)
}
\arguments{
  \item{mydata}{Data frame, the result of importing a
  trajectory file using \code{importTraj}}

  \item{lon}{Column containing the longitude, as a
  decimal.}

  \item{lat}{Column containing the latitude, as a decimal.}

  \item{pollutant}{Pollutant to be plotted.}

  \item{method}{For trajectory plots, either "scatter" or
  "level". The latter option bins the data according to the
  values of \code{x.inc} and \code{y.inc}.}

  \item{smooth}{Should the trajectory surface be smoothed?}

  \item{map}{Should a base map be drawn? If \code{TRUE} the
  world base map from the \code{maps} package is used.}

  \item{lon.inc}{The longitude-interval to be used for
  binning data when \code{method = "level"}.}

  \item{lat.inc}{The latitude-interval to be used for
  binning data when \code{method = "level"}.}

  \item{aspect}{Aspect for map.}

  \item{cex}{Size of points used to plot back trajectories
  in \code{trajPlot}, not used in \code{trajLevel}}

  \item{...}{other arguments to \code{scatterPlot} and
  \code{cutData}.}
}
\value{
  NULL
}
\description{
  This function plots back trajectories. There are two
  relation functions: \code{trajPlot} and \code{trajLevel}.
  These functions require that data are imported using the
  \code{importTraj} function.
}
\author{
  David Carslaw
}
\seealso{
  \code{\link{importTraj}}
}

