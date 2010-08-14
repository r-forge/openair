\name{trend.hour.weekday}
\alias{trend.hour.weekday}

\title{ trend.hour.weekday }
\description{
  openair function for plotting diurnal profiles
}
\usage{
trend.hour.weekday(mydata, 
		pollutant = "nox", 
		limits = c(0, 100), 
		line.colour = "darkorange2", 
		fill.colour = "lightgoldenrod", 
		ylab = pollutant, xlab = "hour of day", 
		main = "", 
		auto.text = TRUE, 
		...)
}

\arguments{
  \item{mydata}{ \code{openair} data set to used to produce trend.hour.weekday plot. }
  \item{pollutant}{ data-series in \code{mydata} to use to plot diurnal profiles. }
  \item{limits}{ If set, the range limits for displaying diurnal profiles over. }
  \item{line.colour}{ Colour of the diurnal profile line. }
  \item{fill.colour}{ Colour of the associated uncertainty region. }
  \item{ylab}{ The y-axis label. }
  \item{xlab}{ The x-axis label. }
  \item{main}{ If set, the plot title. }
  \item{auto.text}{ If set, passes \code{ylab}, \code{xlab} and \code{main} to plot 
  via \code{quickText}, which automatically formats openair terms. }
  \item{\dots}{ Extra options. }
}

\details{
  This function produces a plot similar to \code{timeVariation(mydata, poll="nox", 
  type = "year")}.
}

\author{ David Carslaw }

\examples{
#to be confirmed
}

\keyword{methods}

