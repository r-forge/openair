\name{mydata}

\alias{mydata}

\title{ mydata }

\description{
  The mydata dataset is provided as an example dataset as part of the openair 
  package. The dataset contains 1 hour average measurements of air pollutant 
  concentrations, wind speed and wind direction collected at the Marylebone 
  (London) air quality monitoring supersite between 1998 and 2005. 
}

\usage{
mydata		
}

\format{
  \item{date}{Measurement date/time stamp as POSIX object.}
  \item{ws}{Wind speed.}
  \item{wd}{Wind direction.}
  \item{nox}{Oxides of nitrogen.}  
  \item{no2}{Nitrogen dioxide.}  
  \item{o3}{Ozone.}
  \item{pm10}{Pariculate PM10 size fraction.} 
  \item{so2}{Sulphur dioxide.}  
  \item{co}{Carbon monoxide}   
  \item{pm25}{Pariculate PM2.5 size fraction.}
}

%\source{}

%\references{}

\examples{

#basic structure
head(mydata)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

\keyword{methods}
