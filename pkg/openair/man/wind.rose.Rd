\name{wind.rose}
\alias{wind.rose}
\alias{pollution.rose}

%- Also NEED an '\alias' for EACH other topic documented here.
\title{Traditional wind rose plot and pollution rose variation}
\description{
The traditional wind rose plot that plots wind speed  and wind direction by
different intervals. The pollution rose applies the same plot 
structure but substitutes other measurements, most commonly a pollutant 
time series, for wind speed.
}
\usage{
wind.rose(polar,
ws.int = 2,
breaks = 4, 
angle = 30,
type = "default",
cols = "default",
main = "",
grid.line = 5,
width = 1,
auto.text = TRUE,
units = "(m/s)",
key.name = "",
key.position = "bottom"
key = NULL,
paddle = TRUE,
dig.lab = 5,
pollutant = NULL,
output = "graph",
...)

ans <- wind.rose(...)

pollution.rose(polar, 
pollutant = "nox",
key.name = pollutant,
units = "",
breaks = 6,
paddle = FALSE,
key.position = "right",
...)

ans <- pollution.rose(...)


}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{polar}{A data frame containing fields \code{ws} and \code{wd}}

  \item{ws.int}{The Wind speed interval. Default is 2 m/s but for low met
  masts with low mean wind speeds a value of 1 or 0.5 m/s may be
  better. Note, this argument is superceded in \code{pollution.rose}. See 
  \code{breaks} below.}

  \item{breaks}{The number of break points produced for wind speed in 
  \code{wind.rose} or pollutant in \code{pollution.rose}. For 
  \code{wind.rose} and the \code{ws.int} default of 2 m/s, the default, 4, 
  generates the break points 2, 4, 6, 8 m/s. For \code{pollution.rose}, the 
  default, 6, attempts to breaks the supplied data at approximately 6 
  sensible break points. The argument handles other single numerics 
  similarly or vectorised numerics as fixed break points. For example, the 
  argument \code{breaks = c(1, 10, 100)} breaks the data into segments 
  <1, 1-10, 10-100, >100.}

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
  "black")}.}

  \item{main}{Title of plot.}

  \item{grid.line}{Grid line interval to use.}

  \item{paddle}{Either \code{TRUE} (default) or \code{FALSE}. If
  \code{TRUE} plots rose using `paddle' style spokes. If \code{FALSE} 
  plots rose using `wedge' style spokes.}

  \item{width}{For \code{paddle = TRUE}, the adjustment factor for width 
  of wind speed intervals. For example, \code{width = 1.5} will make the 
  paddle width 1.5 times wider.}

  \item{auto.text}{Either \code{TRUE} (default) or \code{FALSE}. If
  \code{TRUE} titles and axis labels will automatically try and format
  pollutant names and units properly e.g.  by subscripting the `2' in
  NO2.}

  \item{units}{Controls the units shown on the scale e.g. \code{units =
  "knots"}. Note: This argument is passed to \code{draw.openkey} 
  via \code{quick.text}, applying the \code{auto.text} argument, 
  to handle formatting.}

  \item{key.name}{Controls the name shown on the scale, e.g. 
  \code{key.name = "ws"}. Note: This argument is passed to 
  \code{draw.openkey} via \code{quick.text}, applying the 
  \code{auto.text} argument, to handle formatting.}

  \item{key.position}{Location where the scale key is to plotted, 
  Allowed arguments currently include \code{"top"}, \code{"right"}, 
  \code{"bottom"} and \code{"left"}.}

  \item{key}{Fine control of the scale key via \code{draw.openkey}. Note: 
  This argument is in development and currently not enabled.}

  \item{dig.lab}{The number of signficant figures at which scientific 
  number formatting is used in break point and key labelling. Default 
  5.}

  \item{pollutant}{Alternative data series to be sampled 
  instead of wind speed. The \code{wind.rose} default NULL is equivalent 
  to \code{pollutant = "ws"}.}  

  \item{output}{The type of output returned by call. Default, 
  \code{graph}, returns the rose plot itself. Alternative, 
  \code{data}, plots the rose but returns the plot data frame.}

  \item{\dots}{For \code{pollution.rose} other parameters that are 
  passed on to \code{wind.rose}. For \code{wind.rose} other parameters 
  that are passed on to \code{draw.openkey} and 
  \code{lattice:xyplot}. }

}

\details{For \code{wind.rose} data are summarised by direction, 
  typically by 45 or 30 (or 10) degrees and by different wind speed 
  categories. Typically, wind speeds are represented by different 
  width "paddles". The plots show the proportion (here represented 
  as a percentage) of time that the wind is from a certain angle and 
  wind speed range.

  By default \code{wind.rose} will plot a wind rose in using 
  "paddle" style segments and placing the scale key below the plot. 
  
  The argument \code{pollutant} uses the same plotting structure but 
  substiutes another data series, defined by \code{pollutant}, for 
  wind speed. 

  \code{pollution.rose} is a \code{wind.rose} wrapper which brings 
  \code{pollutant} forward in the argument list, and attempts to 
  sensibly rescale break points based on the \code{pollutant} data 
  range by by-passing \code{ws.int}.
 
  By default, \code{pollution.rose} will plot a pollution rose of 
  \code{nox} using "wedge" style segments and placing the scale 
  key to the right of the plot.

}

%\references{ ~put references to the literature/web site here ~ }
\author{David Carslaw (with some additional contributions by Karl 
Ropkins)}

%\note{ ~~further notes~~

\section{Warnings }{Note that \code{wind.rose} and \code{pollution.rose} 
  are designed to work with UK Met Office files. Wind directions of 0 degrees 
  are assumed to be calms. The function will assume any data with 
  wind speed = 0 or wind direction = 0 will be calm.

  Note that \code{wind.rose} and \code{pollution.rose} both use 
  \code{draw.openkey} to produce scale keys. This function is currently 
  in development and specifics of its operation may be subject to
  revision.} 
 
%}
\seealso{See \code{\link{draw.openkey}} for fine control of the scale key. 
 
See \code{\link{polar.freq}} for a more flexible version that
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

# pollution rose of nox
pollution.rose(mydata, pollutant = "nox")

}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

\keyword{methods}% __ONLY ONE__ keyword per line
