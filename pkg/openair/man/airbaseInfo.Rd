\name{airbaseInfo}
\alias{airbaseInfo}
\title{Get information about airbase sites and instruments}
\usage{
airbaseInfo(site = "gb0620a", instrument = FALSE)
}
\arguments{
  \item{site}{Site code(s) of the sites to be imported. Can
  be upper or lower case.}

  \item{instrument}{Should species/instrument details also
  be returned. When \code{FALSE} only one row per site is
  returned with other information such as site type,
  latitude and logitude. When \code{TRUE} details of the
  individual species and instruments used is also
  returned.}
}
\value{
Returns a data frame containing key information about
airbase site(s).
}
\description{
Get information about airbase sites and instruments
}
\details{
This function compiles key information about airbase sites
including the site type, species measured and the
instruments and techniques used. By default the function
returns one row per sites with basic information concerning
the site e.g. its type, latitude and logitude.

More comprehensive information is returned if
\code{instrument = TRUE}. In this case the species measured
at teh site together with the instruments used will be
returned.
}
\author{
David Carslaw
}
\seealso{
\code{\link{importAirbase}}, \code{\link{airbaseFindCode}},
\code{\link{airbaseStats}}
}

