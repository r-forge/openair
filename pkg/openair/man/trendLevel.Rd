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
        x = "month", y = "hour", type = "year",
        xlab = x, ylab = y, 
        typelab = paste(type, ": ", sep=""),
        limits = c(0, 100),
        cols = "default",
        main = "", strip = NULL,
        auto.text = TRUE,
        statistic = c("mean", "max"),
        stat.args = NULL, stat.safe.mode = TRUE,
        output = c("data", "graph"),
        ...)		
}


\arguments{

  \item{mydata}{ The openair data frame to be used to generate the trendLevel plot. }

  \item{pollutant}{ The \code{pollutant} in \code{mydata} to be sampled to produce the 
  trendLevel plot. }

  \item{x}{ The dataseries to use as the trendLevel x-axis. This is used with 
  the \code{y} and \code{type} options to bin the data before applying \code{statistic} (see 
  below). Allowed options currently include \code{"hour"}, \code{"month"}, \code{"year"}, and 
  \code{"wd"}. Other data series in \code{mydata} can also be used. (Note: \code{trendLevel} 
  does not allow duplication in \code{pollutant}, \code{x}, \code{y} and \code{type} options 
  within a call.) }

  \item{y}{ The dataseries to use as the trendLevel y-axis. As \code{x} above. }

  \item{type}{ The dataseries to use for additional conditioning. As \code{x} above. }

  \item{xlab}{ The x-axis label. The option is passed via quickText to handle formatting if 
  enabled (\code{auto.text = TRUE}). }

  \item{ylab}{ The y-axis label. The option is passed via quickText to handle formatting if 
  enabled (\code{auto.text = TRUE}). }

  \item{typelab}{ The type conditioning label. The option is passed via quickText to handle formatting if 
  enabled (\code{auto.text = TRUE}). }


  \item{limits}{ The colour scale range to be uesd when generating the trendLevel plot. }

  \item{cols}{ The colour set to be used to colour the trendLevel surface. \code{cols} is passed 
  to \code{openColours} for evaluation. }

  \item{main}{ The plot title. The option is passed via quickText to handle formatting if 
  enabled (\code{auto.text = TRUE}).}

  \item{auto.text}{ Automatic routine text formatting. \code{auto.text = TRUE} allows labels 
  (\code{xlab}, \code{ylab}, \code{main}, etc.) to be passed to the plot via \code{quickText}. 
  \code{auto.text = FALSE} turns this option off and passes labels directly to the plot. }

  \item{statistic}{ The statistic method to be use to summarise locally binned \code{pollutant} 
  measurements with. Two options are currently encoded: \code{"mean"} (default) and \code{"max"}. 
  (Note: Functions can also be sent directly via \code{statistic}. However, this option is still 
  in development and should be used with caution. See Details below.)  }

  \item{stat.args}{ Any additional args to used with \code{statistic} if this is a function. The 
  extra args should be supplied as a list of named parameters. (see Details below.) }

  \item{stat.safe.mode}{ An addition protection that can be applied when using functions with 
  \code{statistic}.  This option returns \code{NA} instead of running \code{statistic}  
  on binned subsamples that are empty. A number of common functions terminate with an error 
  meassage when applied to an empty dataset. So, this options provides a mechanism to work 
  with such functions. In such cases, e.g. for a function that counted missing entries, it might 
  need to be set to \code{FALSE} (see Details below.) }

  \item{output}{ Output mode. The default, \code{output = "data"}, generates the trendLevel 
  plot and returns the summary data. This can be retained using, e.g., \code{my.ans <- 
  trendLevel(mydata)} and used in further analysis. The alternative setting (\code{"graph"}) 
  returns just the plot. Using, e.g., \code{my.plot <- trendLevel(mydata, output = "graph")} 
  provides an object that can then be used to add extra labelling and annotation. }

  \item{...}{ Addition options, passed to \code{levelplot} in \code{lattice} for evaluation. }
}

\value{
  \code{trendLevel} return either a data frame of the summarised information plotted 
  during the trendLevel call or the plot itself, depending on \code{output} settings 
  (see above). In both cases the plot itself is produced as part if this operation.
}

\details{
  \code{trendLevel} allows the use of third party summarising functions via the 
  \code{statistic} option. Any additional function arguments should be supplied as 
  a list of named parameters as \code{stat.args}. 
  For example, the encoded option \code{statistic = "mean"} 
  is equivalent to \code{statistic = mean, stat.args = list(na.rm = TRUE)}. Many R 
  functions and user`s own creations could be applied in a similar fashion, subject to the 
  following restrictions: the first argument send to the function must be the dataseries to 
  be analysed; the name `x' cannot be used for any of the extra options supplied in 
  \code{stat.args}; and the function should return the required answer as a numeric or NA. Note: 
  If the supplied function returns more than one answer, currently only the first of these 
  is retained and used by \code{trendLevel}. 
  If the function terminates with an error when it is sent an empty 
  data series, the \code{stat.safe.mode = TRUE} can be used as this only evaluates populated 
  data series. Note: The option returns an NA without warning for empty data series. 

  (Note: This option is still be development and should be used with care.)
      
}

\author{ David Carslaw and Karl Ropkins }

\examples{

#basic use
trendLevel(mydata, pollutant = "nox")

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

\keyword{methods}
