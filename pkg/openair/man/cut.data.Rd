\name{cut.data}
\alias{cut.data}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Function to split data in different ways for conditioning}

\description{Utility function to split data frames up in various ways
  for conditioning plots. Users would generally not be expected to call
  this function directly.  Widely used by many \code{openair} functions
  usually through the option \code{type}.}

\usage{mydata<- cut.data(mydata, type = "default")}


%- maybe also 'usage' for other objects documented here.

\arguments{
\item{mydata}{A data frame containing a field \code{date}. }

\item{type}{A string giving the way in which the data frame should be
  split. Pre-defined values are: "default", "year", "hour", "month",
  "season", "weekday", "ws", "site", "weekend", "monthyear".

\code{type} can also be the name of a numeric or factor. If a numeric
column name is supplied \code{cut.data} will split the data into four
quantiles. Factors levels will be used to split the data without any
adjustment.}



}

\details{This section give a brief description of each of the define
  levels of \code{type}. Note that all time dependent types require a
  column \code{date}.

 "default" does not split the data but will describe the levels as a
 date range in the format "day month year".

 "year" splits the data by each year.

 "month" splits the data by month of the year.

 "hour" splits the data by hour of the day.

 "monthyear" splits the data by year and month. It differs from month in
 that a level is defined for each month of the data set. This is useful
 sometimes to show an ordered sequence of months if the data set starts
 half way through a year; rather than starting in January.

 "weekend" splits the data by weekday and weekend.

 "weekday" splits the data by day of the week - ordered to start Monday.

 "wd" splits the data by 8 wind sectors and requires a column \code{wd}:
 "NE", "E", "SE", "S", "SW", "W", "NW", "N".

 "ws" splits the data by 8 quantiles of wind speed and requires a column
 \code{ws}.

 "site" splits the data by site and therefore requires a column \code{site}.
}


\value{Returns a data frame with a column \code{cond} that is defined by
\code{type}.}

%\references{ ~put references to the literature/web site here ~ }
\author{David Carslaw}

\examples{
## split data by day of the week
mydata <- cut.data(mydata, type = "weekday")

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods}
%\keyword{}% __ONLY ONE__ keyword per line
