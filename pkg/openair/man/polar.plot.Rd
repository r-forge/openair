\name{polar.plot}
\alias{polar.plot}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Bivariate polar plot with smoothing}

\description{ Function for
  plotting pollutant concentration in polar coordinates showing
  concentration by wind speed and direction. Mean concentrations are
  calculated for wind speed-direction \sQuote{bins} (0-1, 1-2 m/s,... and
  0-10, 10-20 degrees etc.).  To aid interpretation, gam smoothing is
  carried out using \code{mgcv}.  }

\usage{
polar.plot(polar,
pollutant = "nox",
type = "default",
resolution = "normal",
limits = c(0, 100),
exclude.missing = TRUE,
cols = "default",
min.bin = 1,
upper = 10,
force.positive = TRUE,
k = 100, main = "",
auto.text = TRUE, ...)  }
%- maybe also 'usage' for other objects documented here.

\arguments{ \item{polar}{A data frame minimally containing \code{ws},
    \code{wd} and a pollutant. Can also contain \code{date} if plots by
    time period are required.}

  \item{pollutant}{Mandatory. A pollutant name corresponding to a
    variable in a data frame should be supplied e.g. \code{pollutant =
      "nox"} }

  \item{type}{The type of analysis to be done. The default is will
    produce a single plot using the entire data. Other types include
    "hour" (for hour of the day), "weekday" (for day of the week) and
    "month" (for month of the year), "year" for a polar plot for each
    year. There is also an option "site", which requires users to format
    their data in the form: \code{date, ws, wd, site}. It is also
    possible to choose \code{type} as another variable in the data
    frame. For example, \code{type = "o3"} will plot four wind roses
    for different levels of ozone, split into four quantiles
    (approximately equal numbers of counts in each of the four
    splits). This offers great flexibility for understanding the
    variation of different variables dependent on another. See function 
    \code{cut.data} for further details.}

  \item{resolution}{Two plot resolutions can be set: "normal" (the
    default) and "fine", for a smoother plot. It should be noted
    that plots with a "fine" resolution can take longer to render
    and the default option should be sufficient or most circumstances.}

  \item{limits}{The function does its best to choose sensible limits
    automatically. However, there are circumstances when the user will
    wish to set different ones. An example would be a series of plots
    showing each year of data separately. The limits are set in the form
    \code{c(lower, upper)}, so \code{limits = c(0, 100)} would force the
    plot limits to span 0-100.}

  \item{exclude.missing}{Setting this option to \code{TRUE} (the
    default) removes points from the plot that are too far from the
    original data. The smoothing routines will produce predictions at
    points where no data exist i.e. they predict. By removing the points
    too far from the original data produces a plot where it is clear where
    the original data lie. If set to \code{FALSE} missing data will be
    interpolated.}

  \item{cols}{Colours to be used for plotting. Options include
    "default", "increment", "heat", "jet" and user defined. For user
    defined the user can supply a list of colour names recognised by R
    (type \code{colours()} to see the full list). An example would be
    \code{cols = c("yellow", "green", "blue")}}

  \item{min.bin}{The minimum number of points allowed in a wind
    speed/wind direction bin.  The default is 1. A value of two requires
    at least 2 valid records in each bin an so on; bins with less than 2
    valid records are set to NA. Care should be taken when using a value
    > 1 because of the risk of removing real data points. It is
    recommended to consider your data with care. Also, the
    \code{polar.freq} function can be of use in such circumstances.}

  \item{upper}{This sets the upper limit wind speed to be used. Often
    there are only a relatively few data points at very high wind speeds
    and plotting all of them can reduce the useful information in the
    plot. }

  \item{force.positive}{The default is \code{TRUE}. Sometimes if
    smoothing data with streep gradients it is possible for predicted
    values to be negative. \code{force.positive = TRUE} ensures that
    predictions remain postive. This is useful for several reasons. First,
    with lots of missing data more interpolation is needed and this can
    result in artefacts because the predictions are too far from the
    original data. Second, if it is known beforehand that the data are all
    postive, then this option carries that assumption through to the
    prediction. The only likley time where setting \code{force.positive =
      FALSE} would be if background concentrations were first subtracted
    resulting in data that is legitimately negative. For the vast majority
    of situations it is expected that the user will not need to alter the
    default option.}

  \item{k}{This is the smoothing parameter that is set if auto.smooth is
    set to \code{FALSE}. Typically, value of around 100 (the default)
    seems to be suitable and will resolve more features in the plot.}

  \item{main}{The plot title; default is no title.}

  \item{auto.text}{Either \code{TRUE} (default) or \code{FALSE}. If
    \code{TRUE} titles and axis labels will automatically try and format
    pollutant names and units properly e.g.  by subscripting the `2' in
    NO2.}

  \item{\dots}{Other graphical parameters.}  }

\details{ The bivariate polar plot is a useful diagnostic tool for
  quickly gaining an idea of potential sources. Wind speed is one of the
  most useful variables to use to separate source types (see
  references). For example, ground-level concentrations resulting from
  buoyant plumes from chimney stacks tend to peak under higher wind speed
  conditions. Conversely, ground-level, non-buoyant plumes such as from
  road traffic, tend to have highest concentrations under low wind speed
  conditions. Other sources such as from aircraft engines also show
  differing characteristics by wind speed.

  The plots can vary considerably depending on how much smoothing is
  done. The approach adopted here is based on the very flexible and
  capable \code{mgcv} package that uses \emph{Generalized Additive
    Models}. While methods do exist to find an optimum level of
  smoothness, they are not necessarily useful. The principal aim of
  \code{polar.plot} is as a graphical analysis rather than for
  quantitative purposes. In this respect the smoothing aims to strike a
  balance between interesting (real) features and overly noisy data. The
  defaults used in \code{polar.plot} are based on the analysis of data
  from many different sources. More advanced users may wish to modify
  the code and adopt other smoothing approaches.

  Variants on \code{polar.plot} include \code{polar.annulus} and
  \code{polar.freq}.  }
%\value{
%  ~Describe the value returned
%  If it is a LIST, use
%  \item{comp1 }{Description of 'comp1'}
% \item{comp2 }{Description of 'comp2'}
% ...
%}
\references{

  Carslaw, D.C., Beevers, S.D, Ropkins, K and M.C. Bell (2006).
  Detecting and quantifying aircraft and other on-airport contributions to
  ambient nitrogen oxides in the vicinity of a large international airport.
  Atmospheric Environment. 40/28 pp 5424-5434.

  Henry, R.C., Chang, Y.S., Spiegelman, C.H., 2002. Locating nearby
  sources of air pollution by nonparametric regression of atmospheric
  concentrations on wind direction. Atmospheric Environment 36 (13),
  2237-2244.

  Westmoreland, E.J., N. Carslaw, D.C. Carslaw, A. Gillah and E. Bates
  (2007).  Analysis of air quality within a street canyon using
  statistical and dispersion modelling techniques.  Atmospheric
  Environment. Vol. 41(39), pp. 9195-9205.

  Yu, K.N., Cheung, Y.P., Cheung, T., Henry, R.C., 2004.
  Identifying the impact of large urban airports on local air
  quality by nonparametric regression. Atmospheric Environment
  38 (27), 4501-4507.
}

\author{David Carslaw }
%\note{ ~~further notes~~

% ~Make other sections like Warning with \section{Warning }{....} ~
%}

\section{Warning }{Some plots can take a long time to produce e.g. if
  there are many years of data and \code{type = "year"} is chosen. The
  function may fail if there are insufficient data to smooth the
  surface.}

\seealso{\code{\link{polar.annulus}}, \code{\link{polar.freq}}}

\examples{

# load example data from package
data(mydata)

# basic plot
polar.plot(mydata, pollutant = "nox")

# polar plots by year on same scale
\dontrun{polar.plot(mydata, pollutant = "so2", type = "year", main = "polar plot of so2")}

# set minimum number of bins to be used to see if pattern remains similar
polar.plot(mydata, pollutant = "nox", min.bin = 3)

# plot by day of the week

\dontrun{polar.plot(mydata, pollutant = "pm10", type = "weekday")}

}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods} % __ONLY ONE__ keyword per line
