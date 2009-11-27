\name{MannKendall}
\alias{MannKendall}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Mann-Kendall trend tests}

\description{
Mann-Kendall tests for trend with Sen-Theil slope estimates.
}

\usage{
MannKendall(mydata,
pollutant = "nox",
deseason = FALSE,
type = "default",
period = "monthly",
simulate = FALSE,
alpha = 0.05,
dec.place = 2,
ylab = pollutant,
main = "",
auto.text = TRUE,
autocor = FALSE, ...)
}

%- maybe also 'usage' for other objects documented here.
\arguments{
\item{mydata}{A data frame containing the field \code{date} and at least
one other parameter for which a trend test is required; typically (but
not necessarily) a pollutant.}

  \item{pollutant}{The parameter for which a trend test is
  required. Mandatory.}

  \item{deseason}{Should the data be de-deasonalized first? If
  \code{TRUE} the function \code{stl} is used (seasonal trend
  decomposition using loess). Note that if \code{TRUE} missing data are
  first linearly interpolated because \code{stl} cannot handle missing
  data.}

  \item{type}{The type of analysis to be done. The default is will
produce a single plot using the entire data. Other types include
\code{hour} (for hour of the day), \code{weekday} (for day of the week),
\code{month} (for month of the year), \code{wd} (wind direction split
into eight sectors and \code{ws} (wind speed split into eight
quantiles). There is an option \code{site}, which requires a slightly
different format. If \code{site} is used a data frame with headings
\code{date}, a pollutant and \code{site} is required. It is also
possible to choose \code{type} as another variable in the data
frame. For example, \code{type = "o3"} will plot four wind roses for
different levels of ozone, split into four quantiles (approximately
equal numbers of counts in each of the four splits). This offers great
flexibility for understanding the variation of different variables
dependent on another. See function\code{cut.data} for more details on
the flexibility here.}

  \item{period}{Either \code{monthly} (the default), or
\code{annual}. Determines whether monthly mean or annual mean trends are
plotted. Note that for \code{annual}, six or more years are required.}

  \item{simulate}{Should simulations be carried out to determine the
Mann-Kendall tau and p-value. The default is \code{FALSE}. If
\code{TRUE}, bootstrap simulations are undertaken, which also account
for autocorrelation.}

  \item{alpha}{For the confidence interval calculations of the
slope. The default is 0.05. To show 99\% confidence intervals for the
value of the trend, choose alpha = 0.01 etc.}

  \item{dec.place}{The number of decimal places to display the trend
  estimate at. The default is 2.}

  \item{ylab}{y-axis label.}

  \item{main}{Title of plot, if required.}

  \item{auto.text}{Either \code{TRUE} (default) or \code{FALSE}. If
  \code{TRUE} titles and axis labels will automatically try and format
  pollutant names and units properly e.g.  by subscripting the
  \sQuote{2} in NO2.}

  \item{autocor}{Should autocorrelation be considered in the trend
uncertainty estimates? The default is \code{FALSE}. Generally,
accounting for autocorrelation increases the uncertainty of the trend
estimate - sometimes by a large amount.}

  \item{\dots}{Other graphical parameters.}
}

\details{The \code{Mann-Kendall} function provides a collection of
functions to analyse trends in air pollution data. The Mann-Kendall test
is a commonly used test in environmental sciences to detect the presence
of a trend. It is often used with the Sen-Theil (or just Sen) estimate
of slope. See references.  The \code{Mann-Kendall} function is flexible
in the sense that it can be applied to data in many ways e.g. by day of
the week, hour of day and wind direction. This flexibility makes it much
easier to draw inferences from data e.g. why is there a strong downward
trend in concentration from one wind sector and not another, or why
trends on one day of the week or a certain time of day are unexpected.

The Mann-Kendall test from trend is for data that are \emph{monotonic} -
see \url{http://en.wikipedia.org/wiki/Monotonic_function}. The most
appropriate use for this function is for data that are
\sQuote{well-behaved} i.e. tend to be steadily increasing or decreasing
or steady. For data that are strongly seasonal, perhaps from a
background site, or a pollutant such as ozone, it will be important to
deseasonalise the data (using the option \code{deseason =
TRUE}.Similarly, for data that increase, then decrease, or show sharp
changes it may be better to use \code{\link{smooth.trend}}.

Mann-Kendall code from Rand Wilxox
\url{http://www-rcf.usc.edu/~rwilcox/} has been modified to take account
of correlated data.

The slope estimate and confidence intervals in the slope are plotted and
numerical information presented.

The basic function have been adapted to take account of auto-correlated
data using block bootstrap simulations (Kunsch, 1989). The principal
reason for doing so is to gain a better estimate of trend uncertainty.
}

\references{

Helsel, D., Hirsch, R., 2002. Statistical methods in water resources. US
Geological Survey.  \url{http://pubs.usgs.gov/twri/twri4a3/}. Note that
this is a very good resource statistics as applied to environmental
data.

Hirsch, R. M., Slack, J. R., Smith, R. A., 1982. Techniques of trend analysis for monthly
water-quality data. Water Resources Research 18 (1), 107-121.

Kunsch, H. R., 1989. The jackknife and the bootstrap for general stationary observations.
Annals of Statistics 17 (3), 1217-1241.

\dots see also several of the Air Qulaity Expert Group (AQEG) reports
for the use of similar tests applied to UK/European air quality data,
see \url{http://www.defra.gov.uk/ENVIRONMENT/airquality/panels/aqeg/}.

}
\author{David Carslaw with trend code from Rand Wilcox}
%\note{ ~~further notes~~


\section{Warning }{If \code{deseason = TRUE}, missing data will be
linearly interpolated.}

\seealso{See \code{\link{smooth.trend}} for a flexible approach to
estimating trends using nonparametric regression. The
\code{smooth.trend} function is suitable for cases where trends are not
monotonic and is probably better for exploring the shape of trends.}
\examples{

# load example data from package
data(mydata)

# trend plot for nox
MannKendall(mydata, pollutant = "nox")

# trend plot for ozone with p=0.01 i.e. uncertainty in slope shown at
# 99 % confidence interval

MannKendall(mydata, pollutant = "o3", ylab = "o3 (ppb)", alpha = 0.01)

# trend plot by each of 8 wind sectors
\dontrun{MannKendall(mydata, pollutant = "o3", type = "wd", ylab = "o3 (ppb)")}

# and for a subset of data (from year 2000 onwards)
\dontrun{MannKendall(select.by.date(mydata, year = 2000:2005), pollutant = "o3", ylab = "o3 (ppb)")}

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods}
%\keyword{trend}% __ONLY ONE__ keyword per line
