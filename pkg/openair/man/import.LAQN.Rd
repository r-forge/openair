\name{import.LAQN}
\alias{import.LAQN}
\alias{import.laqn}
\title{Import data from the London Air Quality Network (LAQN)}
\description{
  Function to help import LAQN air quality and meteorological data for
  use in \code{openair}
}
\usage{
mydata <- import.LAQN(file = file.choose())

mydata <- import.laqn(file = file.choose())
}

%- maybe also 'usage' for other objects documented here.
\arguments{
\item{file}{File to be imported. Default, \code{file.choose()}, 
opens browser. Alternatively, can be a character vector setting 
file (and path), R connection, or url. }


}

\details{This function makes it easier to import data from the LAQN. A
  typical pattern of usage is given in the manual and below.

Typically the user will separately download files that contain air
quality and meteorological data. Each is read in separately and then
merged. The air quality data can conists of severa polluants from one
site or one pollutant from up to six sites.

Data can be downloaded from \url{http://www.londonair.org}.}

%\references{ ~put references to the literature/web site here ~ }
\author{David Carslaw}
\note{Times are assumed to be in GMT.}

\seealso{See \code{\link{import}} and \code{\link{import.aurn}}.}

\examples{
## the examples depend on the user downloading data
## met data first
# met <- import.LAQN("d:/temp/met.csv")
## air quality data
# aq <- import.LAQN("d:/temp/LaqnData.csv")
## merge the two together and call it mydata
# mydata <- merge(met, aq, by = "date", all = TRUE)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods}
%\keyword{}% __ONLY ONE__ keyword per line
