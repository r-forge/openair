\name{time.average}
\alias{time.average}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Function to calculate time averages for data frames}

\description{Function to flexibly aggregate data frames by different
time averages, calculating vector-averaged wind direction where
appropriate. The averaged periods can also take account of data capture
rates.  }

\usage{newdata <- time.average(mydata, period = "days",
data.thresh = 0)}


%- maybe also 'usage' for other objects documented here.

\arguments{
\item{mydata}{A data frame containing a \code{date} field . Can be class
\code{POSIXct} or \code{Date}.}

\item{period}{This defines the time period to average to. Can be "secs",
  "mins", "hours", "days", "DSTdays", "weeks", "months", "quarters" or
  "years". For much increased flexibility a number can precede these
  options followed by a space. For example, a time-average of 2 months
  would be \code{period = "2 months"}. See \code{\link{cut.POSIXt}} for
  further details on this.}

\item{data.thresh}{The data capture threshold to use (\%). A value of
  zero means that all available data will be used in a particular period
  regardless if of the number of values available. Conversely, a value
  of 100 will mean that all data will need to be present for the average
  to be calculated, else it is recorded as \code{NA}.}

}

\details{This function calculates time averages for a data frame. It
  also treats wind direction correctly through vector-averaging
  averaging. For example, the average of 350 degrees and 10 degrees is
  either 0 or 360 - not 180. The calculations therefore average the wind
  components.

\code{time.average} should be useful in many circumstances where it is
necessary to work with different time-average data. For example, hourly
air pollution data and 15-minute meteorological data. To merge the two
data sets \code{time.average} can be used to make the meteorological
data 1-hour means first.

For the research community \code{time.average} should be useful for
dealing with outputs from instruments where there are a range of time
averages used.

It is also very useful for plotting data using
\code{\link{time.plot}}. Often the data are too dense to see patterns
and setting different averaging periods easily helps with interpretation.
}

\section{Warning }{\code{time.average} will remove any character or
  factor columns - except if a column "site" is available. This is
  necessary because characters/factors cannot be sensibly averaged.}

\value{Returns a data frame with date in class \code{POSIXct} and will
  remove any non-numeric columns except a column "site".}

%\references{ ~put references to the literature/web site here ~ }
\author{David Carslaw}
\note{Note that \code{time.average} calculates the average of the dates
  in a period also and returns date as \code{POSIXct}.}

\seealso{See \code{\link{time.plot}} that plots time series data and
  uses \code{time.average} to aggregate data where necessary.}

\examples{
## daily average values
daily <- time.average(mydata, period = "days")

## daily average values ensuring at least 75 \% data capture
## i.e. at least 18 valid hours
daily <- time.average(mydata, period = "days", data.thresh = 75)

## 2-weekly averages
fortnight <- time.average(mydata, period = "2 weeks")

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods}
%\keyword{}% __ONLY ONE__ keyword per line
