\name{trendLevel}

\alias{trendLevel}
\alias{trendLevelHour}
\alias{trendLevelWd}

\title{ trendLevel }

\description{
  The trendLevel function provides a way of rapidly showing a large amount of 
  data in a condensed form. In one plot, the variation in the concentration of 
  one pollutant can to shown as a function of three other properties. The default 
  version of the plot uses y = time of day, x = month of year and type = year to 
  provide information on trends, seasonal effects and diurnal variations. However, x, 
  y and type and summarising statistics can all be modified to provide a range 
  of other similar plots. 
}

\usage{
trendLevel(mydata,
	pollutant = "nox",
	x = "month", xlab = x,
	y = "hour", ylab = y,
	type = "year",
	limits = c(0, 100),
	statistic = c("mean", "max"),
	cols = "default",
	main = "",
	auto.text = TRUE,
	fun.args = NULL,
	output = c("data", "graph"),
	...)
		
}


\arguments{

  \item{mydata}{ The openair data frame to be used to generate the trendLevel plot. }

  \item{pollutant}{ The \code{pollutant} in \code{mydata} to be sampled to produce the 
  trendLevel plot. }

  \item{x}{ The property or dataseries to use as the trendLevel x-axis. This is used with 
  the \code{y} and \code{type} options to bin the data before applying \code{statistic} (see 
  below). Allowed options currently include \code{"hour"}, \code{"month"}, \code{"year"}, and 
  \code{"wd"}. (Note: \code{trendLevel} does not allow the same \code{x}, \code{y} and/or 
  \code{type} options to be set within a call.) }

  \item{xlab}{ The x-axis label. The option is passed via quickText to handle formatting if 
  enabled (\code{auto.text = TRUE}). }

  \item{y}{ The property or dataseries to use as the trendLevel y-axis. As \code{x} above. }

  \item{ylab}{ The y-axis label. The option is passed via quickText to handle formatting if 
  enabled (\code{auto.text = TRUE}). }

  \item{type}{ The property or dataseries to use for additional conditioning. As \code{x} above. }

  \item{limits}{ The colour scale range to be uesd when generating the trendLevel plot. }

  \item{statistic}{ The statistic method to be use to summarise locally binned \code{pollutant} 
  measurements with. Two options are currently encoded: \code{"mean"} (default) and \code{max}. 
  (Note: Functions can also be sent directly via \code{statistic}. However, this option is still 
  in development and should be used with caution.)  }

  \item{cols}{ The colour set to be used to colour the trendLevel surface. \code{cols} is passed 
  to \code{openColours} for evaluation. }

  \item{main}{ The plot title. The option is passed via quickText to handle formatting if 
  enabled (\code{auto.text = TRUE}).}

  \item{auto.text}{ Automatic routine text formatting. \code{auto.text = TRUE} allows labels 
  (\code{xlab}, \code{ylab}, \code{main}, etc.) to be passed to the plot via quickText. 
  \code{auto.text = FALSE} turns this option off and passes labels directly to the plot. }

  \item{fun.args}{ Any additional args to used with \code{statistic} if this is a function. }

  \item{output}{ Output mode. The default, \code{output = "data"}, generates the trendLevel 
  plot and returns the summary data. This can be retained using, e.g., \code{my.ans <- 
  trendLevel(mydata)} and used in further analysis. The alternative setting (\code{"graph"}) 
  returns just the plot. Using, e.g., \code{my.plot <- trendLevel(mydata, output = "graph")} 
  provides an object that can then be used to add extra labelling and annotation. }

  \item{...}{ Addition options, passed to \code{level.plot} for evaluation. }
}

\value{
  \code{trendLevel} return either a data frame of the summarised information plotted 
  during the trendLevel call or the plot itself, depending on \code{output} settings 
  (see above). In both cases the plot itself is produced as part if this operation.
}

\author{ David Carslaw and Karl Ropkins }

\examples{

#basic use
trendLevel(mydata, pollutant = "nox")

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

\keyword{methods}
