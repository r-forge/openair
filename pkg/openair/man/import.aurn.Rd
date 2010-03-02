\name{import.aurn}
\alias{import.aurn}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{AURN data import for openair }

\description{Function for importing hourly mean UK Automatic Urban and
  Rural Network (AURN) air quality archive data files for use with the
  \code{openair} package. Files are imported from a remote server
  operated by AEA that provides air quality data files as R data objects. }

\usage{site = "my1", year = 2009, pollutant = "all"}

%- maybe also 'usages' for other objects documented here.
\arguments{
\item{site}{Site code of the AURN site to import e.g. "my1" is
Marylebone Road. Several sites can be imported with \code{site =
c("my1", "nott")} - to import Marylebone Road and Nottingham for
example.}

  \item{year}{Year or years to import. To import a sequence of years
  from 1990 to 200 use \code{year = 1990:2000}. To import several
  specfic years use \code{year = c(1990, 1995, 2000)} for example.}

  \item{pollutant}{Pollutants to import. If omitted will import all
  pollutants ffrom a site. To import only NOx and NO2 for example use
  \code{pollutant = c("nox", "no2")}.}

}

\details{The \code{import.aurn} function has been written to make it
easy to import data from the UK AURN. AEA have provided .RData files (R
workspaces) of all individual sites and years for the AURN. These files
are updated on a daily basis. This approach requires a link to the
Internet to work.

There are several advantages over the web portal approach where .csv
files are downloaded. First, it is quick to select a range of sites,
pollutants and periods (see examples below). Second, storing the data as
.RData objects is very efficient as they are about four times smaller
than .csv files --- which means the data downloads quickly and saves
bandwidth. Third, the function completely avoids any need for data
manipulation or setting time formats, time zones etc. Finally, it is
easy to import many years of data beyond the current limit of about
64,000 lines. The final point makes it possible to download several long
time series in one go.

The site codes and pollutant names can be upper or lower case. The
function will issue a warning when data less than six months old is
downloaded, which may not be ratified.}

\value{Returns a data frame of hourly mean values with date in POSIXct
  class and time zone GMT. }

\author{David Carslaw}

\section{Warning }{The \code{import.aurn} function is currently released as a
  test version. NOTE - Information is required on the site codes for
  easy use.}

\examples{

## import all pollutants from Marylebone Rd from 1990:2009
\dontrun{mary <- import.aurn(site = "my1", year = 2000:2009)}

## import nox, no2, o3 from Marylebone Road and Nottingham Centre for 2000
\dontrun{thedata <- import.aurn(site = c("my1", "nott"), year = 2000,
pollutant = c("nox", "no2", "o3"))}

## import over 20 years of Mace Head O3 data!
\dontrun{o3 <- import.aurn(site = "mh", year = 1987:2009)}

}
\keyword{methods}


