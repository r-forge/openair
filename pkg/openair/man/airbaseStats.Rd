\name{airbaseStats}
\alias{airbaseStats}
\title{Import pre-calculated airbase statistics}
\usage{
airbaseStats(statistic = "Mean", add = c("lat", "lon", "site.type"))
}
\arguments{
  \item{statistic}{A \emph{single} choice from
  \dQuote{P50}, \dQuote{Mean}, \dQuote{P95}, \dQuote{P98},
  \dQuote{Max}, \dQuote{Max36}, \dQuote{Max8},
  \dQuote{Days.c.50.}, \dQuote{Max26},
  \dQuote{Days.c.120.},\dQuote{SOMO35}, \dQuote{AOT40},
  \dQuote{Max19}, \dQuote{Hours.c.200.}, \dQuote{Max4},
  \dQuote{Days.c.125.}, \dQuote{P99_9}, \dQuote{Max25},
  \dQuote{Hours.c.350.}.}

  \item{add}{Additional fields to add to the returned data
  frame. By default the site type, latitude and logitude
  are returned. Other useful options include \dQuote{city},
  \dQuote{site} (site name), \dQuote{country},
  \dQuote{EMEP_station} and \dQuote{altitude}.}
}
\value{
A data frame of airbase sites with the statsitics chosen
and for all species.
}
\description{
Import pre-calculated airbase statistics
}
\details{
The airbase database makes available detailed
pre-calculated statsitics for all species, sites and years.
The \code{airbaseStats} function provides these data.

The data are imported depending on teh statistic chosen ---
see the list of available statistics in the
\code{statistics} option.

Once the data have been imported it is then possible to
subset the data in various ways e.g. by extracting a
particular species with a defined data capture threshold.
}
\author{
David Carslaw
}

