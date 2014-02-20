\name{airbaseStats}
\alias{airbaseStats}
\title{Import pre-calculated airbase statistics}
\usage{
airbaseStats(statistic = "mean", add = c("lat", "lon"))
}
\arguments{
  \item{statistic}{A \emph{single} choice from "P50",
  "Mean", "P95", "P98", "Max", "Max36", "Max8",
  "Days.c.50.", "Max26", "Days.c.120.","SOMO35", "AOT40",
  "Max19", "Hours.c.200.", "Max4", "Days.c.125.", "P99_9",
  "Max25", "Hours.c.350.".}

  \item{add}{Additional fields to add to the returned data
  frame. So far only the latitutde and longitude of the
  site will be returned.}
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

