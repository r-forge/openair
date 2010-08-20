\name{mydata}

\alias{mydata}

\docType{data}

\title{
Example data for openair
}

\description{
The mydata dataset is provided as an example dataset as part of the openair 
  package. The dataset contains 1 hour average measurements of air pollutant 
  concentrations, wind speed and wind direction collected at the Marylebone 
  (London) air quality monitoring supersite between 1998 and 2005. 
}

\usage{data(mydata)}

\format{
  A data frame with 65533 observations on the following 10 variables.
  \describe{
    \item{\code{date}}{Measurement date/time stamp as a POSIX object.}
    \item{\code{ws}}{Wind speed as as a numeric vector.}
    \item{\code{wd}}{Wind direction as a numeric vector.}
    \item{\code{nox}}{Oxides of nitrogen concentration as a numeric vector.}
    \item{\code{no2}}{Nitrogen dioxide concentration as a numeric vector.}
    \item{\code{o3}}{Ozone concentration as a numeric vector.}
    \item{\code{pm10}}{Particulate PM10 fraction measurement as a numeric vector.}
    \item{\code{so2}}{Sulfur dioxide concentration as a numeric vector.}
    \item{\code{co}}{Carbon monoxide concentration as a numeric vector.}
    \item{\code{pm25}}{Particulate PM2.5 fraction measurement as a numeric vector.}
  }
}

\details{
\code{mydata} is supplied with the openair package as an example data set. The same data is 
also provide in \code{'.csv'} format via the openair project web site.
}

\source{
\code{mydata} was compiled from data archived in the LAQA.
}

%\references{
%%  ~~ possibly secondary sources and usages ~~
%website link for .csv and database versions?
%}

\examples{

#basic structure
head(mydata)

}

\keyword{datasets}
