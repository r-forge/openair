\name{airbaseFindCode}
\alias{airbaseFindCode}
\title{Helper function to find EEA airbase codes}
\usage{
airbaseFindCode(country = c("AL", "AT", "BA", "BE", "BG", "CH", "CY", "CZ",
  "DE", "DK", "EE", "ES", "FI", "FR", "GB", "GR", "HR", "HU", "IE", "IS", "IT",
  "LI", "LT", "LU", "LV", "ME", "MK", "MT", "NL", "NO", "PL", "PT", "RO", "RS",
  "SE", "SI", "SK", "TR"), site.type = c("Background", "Traffic",
  "Industrial", "Unknown"), local.code = NA, lat = c(-90, 90),
  lon = c(-180, 180))
}
\arguments{
  \item{country}{A character or vector of characters
  representing country code.}

  \item{site.type}{One of \dQuote{Background},
  \dQuote{Traffic}, \dQuote{Industrial}, \dQuote{Unknown}
  representing the type of site.}

  \item{local.code}{A character or vector of characters
  representing the local site code. For example
  \dQuote{MY1} is the UK code for Marylebone Road.}

  \item{lat}{The latitude range to select in the form
  c(lower, upper).}

  \item{lon}{The longitude range to select in the form
  c(lower, upper).}
}
\value{
A vector of airbase site codes that can be used directly in
\code{\link{importAirbase}}.
}
\description{
Helper function to find airbase codes
}
\details{
This function helps to identify airbase site codes based on
one or more criteria. The criteria include country code,
site type, local site code and latitude/longitude ranges.
}
\examples{
## select all sites in Denmark
sites <- airbaseFindCode(country = "DK")

## traffic sites in Germany and the UK
sites <- airbaseFindCode(country = c("DE", "GB"), site.type = "Background")
}
\author{
David Carslaw
}

