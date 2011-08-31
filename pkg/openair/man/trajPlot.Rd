\name{trajLevel}
\alias{trajLevel}
\alias{trajPlot}
\title{Trajectory plots with conditioning}
\usage{
  trajLevel(mydata, lon = "lon", lat = "lat", pollutant =
  "pm10", method = "level", smooth = TRUE, map = TRUE,
  lon.inc = 1.5, lat.inc = 1.5, aspect = 1, ...)

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

  \item{...}{other arguments to \code{scatterPlot} and
  \code{cutData}.}

  \item{cex}{Size of points used in \code{trajPlot} for
  individual back trajectory points}
}
\value{
  NULL
}
\description{
  This function plots back trajectories. There are two
  related functions: \code{trajPlot} and \code{trajLevel}.
  These functions require that data are imported using the
  \code{importTraj} function.
}
\details{
  Several types of trajectory plot are available.
  \code{trajPlot} by default will plot each lat/lon
  location, colour-coded by the concentration of
  \code{pollutant}. With a long time series there can be
  lots of overplotting making it difficult to gauge the
  overall concentration pattern. In these cases setting
  \code{alpha} to a low value e.g. 0.1 can help.

  For the investigation of a few days it can be useful to
  use \code{plot.type = "l"}, which shows the back
  trajectories as continuous lines rather than individual
  points. Note that points help to show the duration an air
  mass spend in a particular location, whereas lines do
  not.

  An alternative way of showing the trajectories is to bin
  the points into latitude/longitude intervals and average
  the corresponding concentrations. For these purposes
  \code{trajLevel} should be used. A further useful
  refinement is to smooth the resulting surface, which is
  possible by setting \code{smooth = TRUE}.
}
\note{
  This function is under active development and is likely
  to change
}
\examples{
# To be added
}
\author{
  David Carslaw
}
\seealso{
  \code{\link{importTraj}}
}

