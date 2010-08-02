\name{calc.percentile}
\alias{calc.percentile}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Calculate percentile values from a time series}
\description{
  Calculates multiple percentile values from a time series, with
  flexible time aggregation.
}
\usage{
calc.percentile(mydata, pollutant = "o3", period = "month", percentile = 50,
                            data.thresh = 0, start = NA)
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mydata}{A data frame of data with a \code{date} field in the
    format \code{Date} or \code{POSIXct}. Must have one variable to
    apply calculations to.}

  \item{pollutant}{Name of variable to process. Mandatory.}

  \item{period}{Averaging period to use. See \code{time.average} for details.}

  \item{percentile}{A vector of percentile values. For example
  \code{percentile = 50} for median values, \code{percentile = c(5, 50,
  95} for multiple percentile values.}

  \item{data.thresh}{Data threshold to apply when aggregating data. See
  \code{time.average} for details.}

 \item{start}{Start date to use - see \code{time.average} for details.}


}

\details{
  This is a utility function to calculate percentiles and is used in,
  for example, \code{time.plot}. Given a data frame with a \code{date}
  field and one other numeric variable, percentiles are calculated.

}

\value{Returns a data frame with new columns for each percentile
  level. New columns are given names like percentile.95 e.g. when
  percentile = 95 is chosen. See examples below.}
%\references{ ~put references to the literature/web site here ~ }
\author{David Carslaw}

\seealso{\code{\link{time.plot}}, \code{\link{time.average}}}

\examples{

# 95th percentile monthly o3 concentrations
percentiles <- calc.percentile(mydata, pollutant ="o3",
period = "month", percentile = 95)

head(percentiles)

# 5, 50, 95th percentile monthly o3 concentrations
percentiles <- calc.percentile(mydata, pollutant ="o3",
period = "month", percentile = c(5, 50, 95))

head(percentiles)
}
\keyword{methods}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
