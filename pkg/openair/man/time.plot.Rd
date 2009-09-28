\name{time.plot}
\alias{time.plot}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Plot time series}
\description{
  Plot time series quickly, perhaps for multiple pollutants, grouped or
  in separate panels.
}
\usage{
time.plot(mydata,
pollutant = "nox",
group = FALSE,
stack = FALSE,
normalise = FALSE,
avg.time = "default",
type = "default",
layout = c(1, 1),
cols = "brewer1",
main = "",
ylab = pollutant,
lty = 1:length(pollutant),
lwd = 1,
key.columns = 1,
auto.text = TRUE, ...)
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mydata}{A data frame of hourly (or higher temporal resolution
    data). Must include a \code{date} field and at least one variable to
    plot.}

  \item{pollutant}{Name of variable to plot. Two or more pollutants can be
    plotted, in which case a form like \code{pollutant = c("nox", "co")}
    should be used.}

  \item{group}{If more than one pollutant is chosen, should they all be
    plotted on the same graph together? The default is \code{FALSE}, which
    means they are plotted in separate panels with their own scaled. If
    \code{TRUE} then they are plotted on the same plot with the same
    scale.}

  \item{stack}{If \code{TRUE} the time series will be stacked by
    year. This option can be useful if there are several years worth of
    data making it difficult to see much detail when plotted on a single
    plot.}

  \item{normalise}{Should variables be normalised? The default is
    \code{FALSE}. If \code{TRUE} then the variable(s) are divided by
    their mean values. This helps to compare the shape of the diurnal
    trends for variables on very different scales.}

 \item{avg.time}{Averaging time to use. \code{"default"} does not apply
 any averaging to the data. Other valid settings are \code{"hourly"}
 (useful for averging data with less than 1-hour means), \code{"daily"},
 \code{"weekly"}, \code{"monthly"} and \code{"yearly"}.}

  \item{type}{Currently only \code{"default"} or \code{"site"} are
    available options. If \code{type = "site"} then plots for a
    \emph{single} pollutant across several sites will be plotted.}

  \item{layout}{Determines how the panels are laid out. By default,
    plots will be shown in one column with the number of rows equal to the
    number of pollutants, for example. If the user requires 2 columns and
    two rows, layout should be set to \code{layout = c(2, 2)}. In general,
    layout is expressed as number of columns times number of rows.}

  \item{cols}{Colours to be used for plotting. Options include "default",
    "increment", "heat", "spectral", "hue", "brewer1" (default) and user
    defined (see manual for more details). The same line colour can be
    set for all pollutant e.g. \code{cols = "black"}.}

  \item{main}{The plot title; default is no title.}

  \item{ylab}{Name of y-axis variable. By default will use the name of
    \code{pollutant}(s).}

  \item{lty}{The line type used for plotting. Default is to provide
    different line types for different pollutant. If one requires a
    continuous line for all pollutants, the set \code{lty = 1}, for
    example. See \code{lty} option for standard plotting.}

  \item{lwd}{The line width used; default is 1. To set a wider line for
    all pollutant the choose, for example, \code{lwd = 2}. Alternatively,
    varying line widths can be chosen depending on the pollutant. For
    example, if \code{pollutant = c("nox", "no2", "o3")}, and a wider line
    was wanted for ozone, then \code{lwd} can be expressed as \code{lwd =
      c(1, 1, 2)}.}

  \item{key.columns}{Number of columns to be used in the key. With many
  pollutants a single column can make to key too wide. The user can thus
  choose to use several columns by setting \code{columns} to be greater
  than 1.}

  \item{auto.text}{Either \code{TRUE} (default) or \code{FALSE}. If \code{TRUE}
    titles and axis labels will automatically try and format pollutant
    names and units properly e.g.  by subscripting the `2' in NO2.}

  \item{\dots}{Other graphical parameters.}
}

\details{
  The \code{time.plot} is the basic time series plotting function in
  \code{openair}. Its purpose is to make it quick and easy to plot time
  series for pollutants and other variables. The other purpose is to plot
  potentially many variables together in as compact a way as possible.

  The function is flexible enough to plot more than one variable at
  once. If more than one variable is chosen plots it can either show all
  variables on the same plot (with different line types) \emph{on the
    same scale}, or (if \code{group = FALSE}) each variable in its own
  panels with its own scale.

  The general preference is not to plot two variables on the same graph
  with two different y-scales. It can be misleading to do so and
  difficult with more than two variables. If there is in interest in
  plotting several variables together that have very different scales,
  then it can be useful to normalise the data first, which can be down be
  setting \code{normalise = TRUE}. This option ensures that each variable
  is divided by its mean and makes it easy to plot two or more variables
  on the same plot - generally with \code{group = TRUE}.

  The user has fine control over the choice of colours, line width and
  line types used. This is useful for example, to emphasise a particular
  variable with a specific line type/colour/width.

  \code{time.plot} works very well with \code{\link{select.by.date}},
  which is used for selecting particular date ranges quickly and
  easily. See examples below.
}

%\references{ ~put references to the literature/web site here ~ }
\author{David Carslaw}

\seealso{\code{\link{MannKendall}}, \code{\link{smooth.trend}},
  \code{\link{linear.relation}}, \code{\link{select.by.date}}}

\examples{

# basic use, single pollutant
time.plot(mydata, pollutant = "nox")

# two pollutants in separate panels
time.plot(mydata, pollutant = c("nox", "no2"))

# two pollutants in the same panel with the same scale
time.plot(mydata, pollutant = c("nox", "no2"), group = TRUE)

# alternative by normalising concentrations and plotting on the same
  scale
time.plot(mydata, pollutant = c("nox", "no2"), group = TRUE, normalise =
  TRUE)

# examples of selecting by date

# plot for nox in 1999
time.plot(select.by.date(mydata, year = 1999), pollutant = "nox")

# select specific date range for two pollutants
time.plot(select.by.date(mydata, start = "6/8/2003", end = "13/8/2003"),
pollutant = c("no2", "o3"))

# choose different line styles etc
time.plot(mydata, pollutant = c("nox", "no2"), lty = 1)

# choose different line styles etc
time.plot(select.by.date(mydata, year = 2004, month = 6), pollutant =
c("nox", "no2"), lwd = c(1, 2), col = "black")

}
\keyword{methods}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
