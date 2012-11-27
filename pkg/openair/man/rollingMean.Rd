\name{rollingMean}
\alias{rollingMean}
\title{Calculate rollingMean values}
\usage{
  rollingMean(mydata, pollutant = "o3", hours = 8,
    new.name = "rolling", data.thresh = 75,
    align = "centre", ...)
}
\arguments{
  \item{mydata}{A data frame containing a \code{date}
  field.}

  \item{pollutant}{The name of a pollutant e.g.
  \code{pollutant = "o3"}.}

  \item{hours}{The averaging period to use e.g. \code{hours
  = 8} will generate 8-hour rollingMean values.}

  \item{new.name}{The name given to the new rollingMean
  variable. If not supplied it will create a name based on
  the name of the pollutant and the averaging period used.}

  \item{data.thresh}{The data capture threshold in %. No
  values are calculated if data capture over the period of
  interest is less than this value. For example, with
  \code{hours = 8} and \code{data.thresh = 75} at least 6
  hours are required to calculate the mean, else \code{NA}
  is returned.}

  \item{align}{specifyies how the moving window should be
  aligned. \code{"right"} means that the previous
  \code{hours} (including the current) are averaged. This
  seems to be the default for UK air quality rolling mean
  statistics. \code{"left"} means that the forward
  \code{hours} are averaged, and \code{"centre"} or
  \code{"center"}, which is the default.}

  \item{...}{other arguments, currently unused.}
}
\description{
  Calculate rollingMean values taking account of data
  capture thresholds
}
\details{
  This is a utility function mostly designed to calculate
  rolling mean statistics relevent to some pollutant limits
  e.g. 8 hour rolling means for ozone and 24 hour
  rollingMeans for PM10.
}
\examples{
## rolling 8-hour mean for ozone
mydata <- rollingMean(mydata, pollutant = "o3", hours = 8, new.name =
"rollingo3", data.thresh = 75, align = "right")
}
\author{
  David Carslaw
}
\keyword{methods}

