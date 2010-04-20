\name{calendar.plot}
\alias{calendar.plot}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Plot time series values in convential calendar format}

\description{ This function will plot one year of data by month laid out
  in a conventional calendar format. The main purpose is to help rapidly
  visualise potentially complex data in a familiar way. Users can also
  choose to show daily mean wind vectors if wind speed and direction are available. }

\usage{
calendar.plot(mydata,
pollutant = "nox",
year = 2003,
type = "default",
annotate = "date",
statistic = "mean",
cols = "heat",
limits = c(0, 100),
main = quick.text((paste(pollutant, "in", year))),
auto.text = TRUE,
...)  }
%- maybe also 'usage' for other objects documented here.

\arguments{ \item{mydata}{A data frame minimally containing \code{date}
  and at least one other numeric variable and a year. The date should be
  in either \code{Date} format or class \code{POSIXct}.}

  \item{pollutant}{Mandatory. A pollutant name corresponding to a
    variable in a data frame should be supplied e.g. \code{pollutant =
      "nox". } }

  \item{year}{Year to plot e.g. \code{year = 2003}.}

  \item{type}{Not yet implemented.}

  \item{annotate}{This option controls what appears on each day of the
  calendar. Can be: "date" - shows day of the month; "wd" -
  shows vector-averaged wind direction, or "ws" - shows
  vector-averaged wind direction scaled by wind speed. }

\item{statistic}{Note currently implemented - only mean is currently
calculated.}

  \item{cols}{Colours to be used for plotting. Options include
    "default", "increment", "heat", "jet" and user defined. For user
    defined the user can supply a list of colour names recognised by R
    (type \code{colours()} to see the full list). An example would be
    \code{cols = c("yellow", "green", "blue")}}

   \item{limits}{Use this option to manually set the colour scale
   limits. This is useful in the case when there is a need for two or
   more plots and a consistent scale is needed on each. Set the limits
   to cover the maximimum range of the data for all plots of
   interest. For example, if one plot had data covering 0--60 and
   another 0--100, then set \code{limits = c(0, 100)}. Note that data
   will be ignored if outside the limits range.}

  \item{main}{The plot title; default is pollutant and year.}

  \item{auto.text}{Either \code{TRUE} (default) or \code{FALSE}. If
    \code{TRUE} titles and axis labels will automatically try and format
    pollutant names and units properly e.g.  by subscripting the `2' in
    NO2.}

  \item{\dots}{Other graphical parameters.}  }

\details{ \code{calendar.plot} will plot one year of data in a
  conventional calendar format i.e. by month and day of the week. The
  main purpose of this function is to make it easy to visualise data in
  a familiar way. Currently the mean value of a variable is plotted
  using a colour scale. Further statistics will be added in due course.

If wind direction are available it is then possible to plot the wind
direction vector on each day. This is very useful for getting a feel for
the meteorological conditions that affect pollutant concentrations. Note
that if hourly or higher time resolution are supplied, then
\code{calendar.plot} will calculate daily averages using
\code{\link{daily.mean}}, which ensures that wind directions are
vector-averaged.

If wind speed is also available, then setting the option \code{annotate
  = "ws"} will plot the wind vectors whose length is scaled to the wind
  speed. Thus information on the daily mean wind speed and direction are
  available.}
%\value{
%  ~Describe the value returned
%  If it is a LIST, use
%  \item{comp1 }{Description of 'comp1'}
% \item{comp2 }{Description of 'comp2'}
% ...
%}
\references{


}

\author{David Carslaw }
%\note{ ~~further notes~~

% ~Make other sections like Warning with \section{Warning }{....} ~
%}

\section{Warning }{This function is under development.}

\seealso{\code{\link{time.plot}}, \code{\link{time.variation}}}

\examples{

# load example data from package
data(mydata)

# basic plot
calendar.plot(mydata, pollutant = "o3", year = 2003)

# show wind vectors
calendar.plot(mydata, pollutant = "o3", year = 2003, annotate = "wd")

# show wind vectors scaled by wind speed and different colours
calendar.plot(mydata, pollutant = "o3", year = 2003, annotate = "ws",
cols = "heat")

# show only specific months with select.by.date
calendar.plot(select.by.date(mydata, month = c(3,6,10), year = 2003),
pollutant = "o3", year = 2003, annotate = "ws", cols = "heat")


}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods} % __ONLY ONE__ keyword per line
