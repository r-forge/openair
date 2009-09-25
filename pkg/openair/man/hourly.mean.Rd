\name{hourly.mean}
\alias{hourly.mean}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Calculate hourly means from hourly or higher resolution data}
\description{
  Calculate hourly means for a data frame treating wind direction correctly
}
\usage{
mydata <- hourly.mean(mydata)
}


%- maybe also 'usage' for other objects documented here.
\arguments{
\item{mydata}{A data frame containing a \code{date} field with times in
  a higher time resolution of 1 hour.}
}

\details{This function calculates hourly mean values for a data
  frame. It's principal purpose is to deal correctly with wind direction
  averaging. For example, the average of 350 degrees and 10 degrees is
  either 0 or 360 - not 180. The calculations therefore average the wind
  components.

A typical use will be to correctly calculate hourly data from 15 minute
data accounting for wind direction averaging correctly.}

\section{Warning }{Note that the function currently only works with a
  single site.}

%\references{ ~put references to the literature/web site here ~ }
\author{David Carslaw}
%\note{}


\examples{
daily <- hourly.mean(mydata)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods}
%\keyword{}% __ONLY ONE__ keyword per line
