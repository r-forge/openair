\name{splitByDate}
\alias{splitByDate}
\title{Divide up a data frame by time}
\usage{
  splitByDate(mydata, dates = "1/1/2003", labels =
  c("before", "after"))
}
\arguments{
  \item{mydata}{A data frame containing a \code{date} field
  in hourly or high resolution format.}

  \item{dates}{A date or dates to split data by.}

  \item{labels}{Labels for each time partition.}
}
\description{
  Utility function to prepare input data for use in openair
  functions
}
\details{
  This function partitions a data frame up into different
  time segments. It produces a new column called
  \code{site} that can be used in many \code{openair}
  functions. Note that there must be one more label than
  there are dates. See examples below and in full
  \code{openair} documentation.
}
\examples{
## split data up into "before" and "after"
mydata <- splitByDate(mydata, dates = "1/04/2000",
labels = c("before", "after"))

## split data into 3 partitions:
mydata <- splitByDate(mydata, dates = c("1/1/2000", "1/3/2003"),
labels = c("before", "during", "after"))
}
\author{
  David Carslaw
}
\keyword{methods}

