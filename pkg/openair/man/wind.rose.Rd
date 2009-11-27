\name{wind.rose}
\alias{wind.rose}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Traditional wind rose plot}
\description{
Traditional wind rose plot that plots wind speed  and wind direction by
different intervals
}
\usage{
wind.rose(polar,
ws.int = 2,
angle = 30,
type = "default",
cols = "default",
main = "",
grid.line = 5,
width = 1,
units = "(m/s)",
auto.text = TRUE,
 ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{polar}{A data frame containing fields \code{ws} and \code{wd}}

  \item{ws.int}{Wind speed interval. Default is 2 m/s but for low met
  masts with low mean wind speeds a value of 1 or 0.5 m/s may be
  better.}

\item{angle}{Default angle of "spokes" is 30. Other potentially useful
  angles are 45 and 10. Note that the width of the wind speed interval
  may need adjusting using \code{width}.}

  \item{type}{Default is \code{default}, which will plot all data on one
  wind rose. Other useful options are \code{year}, \code{month} and \code{hour} for
  one wind rose for each year or each month respectfully. Many more
  types are shown in the function \code{cut.data}. }

  \item{cols}{Colours to be used for plotting. Options include
  \code{default}, \code{increment}, \code{heat}, \code{jet}, \code{hue}
  and user defined. For user defined the user can supply a list of
  colour names recognised by R (type \code{colours()} to see the full
  list). An example would be \code{cols = c("yellow", "green", "blue",
  "black")}}

\item{main}{Title of plot.}

\item{grid.line}{Grid line interval to use.}

\item{width}{Adjustment factor for width of wind speed intervals. For
  example, \code{width = 1.5} will make the width 1.5 times wider.}

\item{units}{Controls the units shown on the scale e.g. \code{units =
"knots"}.}

  \item{auto.text}{Either \code{TRUE} (default) or \code{FALSE}. If
  \code{TRUE} titles and axis labels will automatically try and format
  pollutant names and units properly e.g.  by subscripting the `2' in
  NO2.}

  \item{\dots}{Other graphical parameters to pass to \code{wind.rose}.}
}

\details{Data are summarised by direction, typically by 45 or 30 (or
  10) degrees and by different wind speed categories. Typically, wind
  speeds are represented by different width "paddles". The plots show
  the proportion (here represented as a percentage) of time that the
  wind is from a certain angle and wind speed range.

The \code{wind.rose} function plots the frequency of wind
directions/speeds in 30 degree intervals of wind direction by
default. By default the function will show a wind rose using all the
data. Sometimes it is useful to set the wind speed interval to < 2 m/s
if wind speeds are from a met mast that is lower than 10 m height.  }

%\references{ ~put references to the literature/web site here ~ }
\author{David Carslaw}
%\note{ ~~further notes~~

% ~Make other sections like Warning with \section{Warning }{....} ~
%}
\seealso{\code{\link{polar.freq}} for a more flexible version that
considers other statistics and pollutant concentrations.}

\examples{
# load example data from package data(mydata)

# basic plot
wind.rose(mydata)

# one wind rose for each year
wind.rose(mydata,type = "year")

# plot wind roses by month of the year
wind.rose(mydata, type = "month")

# wind rose in 10 degree intervals with gridlines and width adjusted
wind.rose(mydata, angle = 10, width = 0.3, grid.line = 1)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

\keyword{methods}% __ONLY ONE__ keyword per line
