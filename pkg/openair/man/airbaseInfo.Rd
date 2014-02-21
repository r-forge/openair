\name{airbaseInfo}
\alias{airbaseInfo}
\title{Get information about airbase sites and instruments}
\usage{
airbaseInfo(site = "gb0620a")
}
\arguments{
  \item{site}{Site code(s) of the sites to be imported. Can
  be upper or lower case.}
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
instruments and techniques used.
}
\author{
David Carslaw
}
\seealso{
\code{\link{importAirbase}}, \code{\link{airbaseFindCode}},
\code{\link{airbaseStats}}
}

