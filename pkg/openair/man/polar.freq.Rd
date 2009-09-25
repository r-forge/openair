\name{polar.freq}
\alias{polar.freq}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Function to plot wind speed/direction frequencies and other statistics}

\description{ \code{polar.freq} primarily plots wind speed-direction
frequencies in \sQuote{bins}. Each bin is colour-coded depending on the
frequency of measurements. Bins can also be used to show the
concentration of pollutants using a range of commonly used statistics.
}

\usage{
polar.freq(polar,
pollutant = "",
statistic = "frequency",
ws.int = 1,
breaks = seq(0, 5000, 500),
cols = "default",
trans = TRUE,
type = "default",
min.bin = 1,
border.col = "transparent",
main = "",
auto.text = TRUE, ...)
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{polar}{A data frame minimally containing \code{ws}, \code{wd} and \code{date}.}

  \item{pollutant}{Mandatory. A pollutant name corresponding to a variable in a data frame should be supplied e.g. \code{pollutant = "nox"} }

  \item{statistic}{The statistic that should be applied to each wind
speed/direction bin. Can be "frequency", "mean", "median", "max"
(maximum), "stdev" (standard deviation) or "weighted.mean". The option
"frequency" (the default) is the simplest and plots the frequency of
wind speed/direction in different bins. The scale therefore shows the
counts in each bin. The option "mean" will plot the mean concentration
of a pollutant (see next point) in wind speed/direction bins, and so
on. Finally, "weighted.mean" will plot the concentration of a pollutant
weighted by wind speed/direction. Each segment therefore provides the
percentage overall contribution to the total concentration.  More
information is given in the examples. Note that for options other than
"frequency", it is necessary to also provide the name of a pollutant.}

  \item{ws.int}{Wind speed interval assumed. In some cases e.g. a low met mast, an interval of 0.5 may be more appropriate.}

  \item{breaks}{The user can provide their own scale. \code{breaks}
  expects a sequence of numbers that define the range of the scale. The
  sequence could represent one with equal spacing e.g. \code{breaks =
  seq(0, 100, 10)} - a scale from 0-10 in intervals of 10, or a more
  flexible sequence e.g. \code{breaks = c(0, 1, 5, 7, 10)}, which may be
  useful for some situations.}

  \item{cols}{Colours to be used for plotting. Options include
  "default", "increment", "heat", "jet" and user defined. For user
  defined the user can supply a list of colour names recognised by R
  (type \code{colours()} to see the full list). An example would be
  \code{cols = c("yellow", "green", "blue")}}

  \item{trans}{Should a transformation be applied? Sometimes when
producing plots of this kind they can be dominated by a few high
points. The default therefore is \code{TRUE} and a square-root transform
is applied. This results in a non-linear scale and (usually) a better
representation of the distribution. If set to \code{FALSE} a linear
scale is used.}

  \item{type}{The type of analysis to be done. The default is will
produce a single plot using the entire data. Other types include "hour"
(for hour of the day), "weekday" (for day of the week), "month" (for
month of the year) and "year". There is an option "site", which
requires a slightly different format. If "site" is used a data frame
with headings \code{date}, a pollutant and \code{site} is required. It is also
possible to choose \code{type} as another variable in the data frame. For
example, \code{type = "o3"} will plot four wind roses for different
levels of ozone, split into four quantiles (approximately equal numbers
of counts in each of the four splits). This offers great flexibility for
understanding the variation of different variables dependent on
another.}

  \item{min.bin}{The minimum number of points allowed in a wind
  speed/wind direction bin.  The default is 1. A value of two requires
  at least 2 valid records in each bin (units of 1 m/s and 10 degrees)
  an so on; bins with less than 2 valid records are set to NA. Care
  should be taken when using a value > 1 because of the risk of removing
  real data points. It is recommended to consider your data with
  care. Also, the \code{\link{polar.plot}} function can be of use in
  such circumstances.}

  \item{border.col}{The colour of the boundary of each wind
speed/direction bin. The default is transparent. Another useful choice
sometimes is "white".}

  \item{main}{Title of plot.}

  \item{auto.text}{Either \code{TRUE} (default) or \code{FALSE}. If
  \code{TRUE} titles and axis labels will automatically try and format
  pollutant names and units properly e.g.  by subscripting the
  \sQuote{2} in NO2.}

  \item{\dots}{Other graphical parameters.}  } \details{
\code{polar.freq} is its default use provides details of wind speed and
direction frequencies. In this respect it is similar to
\code{\link{wind.rose}}, but considers wind direction intervals of 10
degrees and a user-specified wind speed interval. The frequency of wind
speeds/directions formed by these \sQuote{bins} is represented on a
colour scale.

The \code{polar.freq} function is more flexible than either
\code{\link{wind.rose}} or \code{\link{polar.plot}}. It can, for
example, also consider pollutant concentrations (see examples
below). Instead of the number of data points in each bin, the
concentration can be shown. Further, a range of statistics can be used
to describe each bin - see \code{statistic} above. Plotting mean
concentrations is useful for source identification and is the same as
\code{\link{polar.plot}} but without smoothing, which may be preferable
for some data. Plotting with \code{statistic = "weighted.mean"} is
particularly useful for understanding the relative importance of
different source contributions. For example, high mean concentrations
may be observed for high wind speed conditions, but the weighted mean
concentration may well show that the contribution to overall
concentrations is very low.

\code{polar.freq} also offers great flexibility with the scale used and
the user has fine control over both the range, interval and colour.  }

\references{ ~put references to the literature/web site here ~ }
\author{David Carslaw}
%\note{ ~~further notes~~

% ~Make other sections like Warning with \section{Warning }{....} ~
%}
\seealso{See Also as \code{\link{wind.rose}}, \code{\link{polar.plot}}}
\examples{

# basic wind frequency plot
polar.freq(mydata)

# wind frequencies by year
polar.freq(mydata, type = "year")

# drop the date strip at the top
polar.freq(mydata, strip = FALSE)

# mean SO2 by year, showing only bins with at least 2 points
polar.freq(mydata, pollutant = "so2", type = "year", statistic = "mean", min.bin = 2)

# weighted mean SO2 by year, showing only bins with at least 2 points
polar.freq(mydata, pollutant = "so2", type = "year", statistic = "weighted.mean", min.bin = 2)

#wind rose for just 2000 and 2003 with different colours
polar.freq(subset(mydata, format(date, "\%Y") \%in\% c(2000, 2003)), type = "year", cols = "jet")

# user defined breaks from 0-700 in intervals of 100 (note linear scale)
polar.freq(mydata, breaks = seq(0, 700, 100))

# more complicated user-defined breaks - useful for highlighting bins with a certain number of data points
polar.freq(mydata, breaks = c(0, 10, 50, 100, 250, 500, 700))

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{wind frequency}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
