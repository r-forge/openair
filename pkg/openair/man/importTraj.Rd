\name{importTraj}
\alias{importTraj}
\title{Import pre-calculated HYSPLIT 96-hour back trajectories}
\usage{
  importTraj(site = "London", year = 2009)
}
\arguments{
  \item{site}{Site code of the network site to import e.g.
  "my1" is Marylebone Road. Several sites can be imported
  with \code{site = c("my1", "kc1")} --- to import
  Marylebone Road and North Kensignton for example.}

  \item{year}{Year or years to import. To import a sequence
  of years from 1990 to 2000 use \code{year = 1990:2000}.
  To import several specfic years use \code{year = c(1990,
  1995, 2000)} for example.

  Access to reliable and free meteorological data is
  problematic.}
}
\value{
  Returns a data frame with pre-calculated back
  trajectories.
}
\description{
  This function imports pre-calculated back trajectories
  using the HYSPLIT trajectory model (Hybrid Single
  Particle Lagrangian Integrated Trajectory Model
  \url{http://ready.arl.noaa.gov/HYSPLIT.php}). Back
  trajectories provide some very useful information for air
  quality data analysis. However, while they are commonly
  calculated by researchers it is generally difficult for
  them to be calculated on a routine basis and used easily.
  In addition, the availability of back trajectories over
  several years can be very useful, but again difficult to
  calculate. \cr\cr We are extremely grateful to NOAA for
  making HYSPLIT available to produce back trajectories in
  an open way.
}
\note{
  The trajectories were run using the February 2011 HYSPLIT
  model. The function is primarily written to investigate a
  single site at a time for a single year. The trajectory
  files are quite large and care should be exercised when
  importing several years and/or sites.
}
\examples{
## import trajectory data for London in 2009
\dontrun{mytraj <- importTraj(site = "london", year = 2009)}
}
\author{
  David Carslaw
}
\seealso{
  \code{\link{trajPlot}}, \code{\link{importAURN}},
  \code{\link{importKCL}},\code{\link{importADMS}},
  \code{\link{importSAQN}}
}
\keyword{methods}

