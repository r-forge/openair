\name{import.ADMS.met}
\alias{import.ADMS.met}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Import an ADMS format hourly meteorological file}
\description{
  Function to make it easy to import an AMDS met file to \code{openair} format
}
\usage{
mydata <- import.ADMS.met(x)
}


%- maybe also 'usage' for other objects documented here.
\arguments{
\item{x}{File path to file to import. If the file names is missing, the
  user will be promted for one.}

}

\details{This function makes it easier to import ADMS met files. A
  typical pattern of usage is given in the manual and below.

  A typical met files looks like:

  VARIABLES:

  10

  STATION DCNN

  YEAR

  TDAY

  THOUR

  T0C

  U

  PHI

  P

  CL

  RH

  DATA:

  3772.0, 1997.0, 1.0, 0.0, -2.8, 7.2, 30.0, 0.0, 8.0, 78.0,

  3772.0, 1997.0, 1.0, 1.0, -2.2, 7.2, 50.0, 0.0, 8.0, 74.0,

  3772.0, 1997.0, 1.0, 2.0, -2.2, 7.2, 40.0, 0.0, 8.0, 74.0,

  3772.0, 1997.0, 1.0, 3.0, -2.8, 6.2, 30.0, 0.0, 7.0, 75.0,

  3772.0, 1997.0, 1.0, 4.0, -2.8, 6.7, 30.0, 0.0, 7.0, 75.0,

  3772.0, 1997.0, 1.0, 5.0, -2.8, 7.2, 30.0, 0.0, 7.0, 66.0,

  3772.0, 1997.0, 1.0, 6.0, -3.3, 7.2, 20.0, 0.0, 4.0, 69.0,

  ...

}

%\references{ ~put references to the literature/web site here ~ }
\author{David Carslaw}
\note{Times are assumed to be in GMT.}

\seealso{See \code{\link{import}} and \code{\link{import.aurn}}.}

\examples{
## the examples depend the user having met files in a specfic directory
## of their choosing
# met <- import.ADMS.met() ## dialog box comes up
## give a file path
# met <- import.ADMS.met("d:/temp/heath01.met")

## can also import a whole load at once and combine them:

## all.met <- lapply(list.files(path = "d:/temp", pattern = ".met",
##                                full.names = TRUE),
##                    function(.file) import.ADMS.met(.file))
## all.met <- do.call(rbind.fill, test.data)

## note that this imports all files with a .met extension and then
## combines them into one data frame all.met

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods}
%\keyword{}% __ONLY ONE__ keyword per line
