\name{polar.percentile}
\alias{polar.percentile}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Polar percentile plots}
\description{
Shows the concentration of a pollutant in polar coordinates and
information the percentiles.
}
\usage{
polar.percentile(polar,
pollutant = "",
type = "ws",
limits = c(0, 100),
per = c(50, 95),
cols = "default",
auto.smooth = TRUE,
k = 10,
main = "",
auto.text = TRUE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{polar}{Mandatory. The user must supply a data frame with fields
including \code{date}, \code{pollutant, ws} and \code{wd}.}
\item{pollutant}{Mandatory. A pollutant name corresponding to a
    variable in a data frame should be supplied e.g. \code{pollutant =
      "nox"}}
\item{type}{The type can be "ws" (default) "year" or "month", for
plotting by wind speed ranges, year and by month of year. The choice of
year is useful for examining trends and plotting by month can indicate
seasonal influences.}
  \item{limits}{ ~~Describe \code{limits} here~~ }
  \item{per}{The user can provide overall percentile values to
    plot. This is is the form c(50, 95) e.g. to consider the 50th and
    95th percentiles.}
  \item{cols}{Colours to be used for plotting. Options include
    "default", "increment", "heat", "spectral" and user defined.}
  \item{auto.smooth}{ ~~Describe \code{auto.smooth} here~~ }
  \item{k}{ ~~Describe \code{k} here~~ }
  \item{main}{ ~~Describe \code{main} here~~ }
  \item{auto.text}{ ~~Describe \code{auto.text} here~~ }
  \item{...}{ ~~Describe \code{\dots} here~~ }
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{David Carslaw}
%\note{ ~~further notes~~

% ~Make other sections like Warning with \section{Warning }{....} ~
%}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
%\examples{}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
