\name{fourier}
\alias{fourier}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
fourier(mydata, pollutant = "nox", ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mydata}{ ~~Describe \code{mydata} here~~ }
  \item{pollutant}{ ~~Describe \code{pollutant} here~~ }
  \item{\dots}{ ~~Describe \code{\dots} here~~ }
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
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(mydata, pollutant = "nox",...) {
{    library(RODBC)
    library(lattice)
    
    #order by date
    mydata <- mydata[order(mydata$date),]
    
    means <- tapply(mydata[, pollutant], format(mydata$date,"\%Y-\%j"), 
                    mean, na.rm = TRUE)
    means <- as.vector(means)
    
    #simple fill of missing data
    means[which(is.nan(means))] <- mean(means, na.rm = T)
    means[which(is.na(means))] <- mean(means, na.rm = T)
    
    #sort out dates here!!
    dates <- seq(mydata$date[1], mydata$date[nrow(mydata)], length = length(means))
    
    decomp <- tsdecomp(means, dates)
    # plotting code in lattice below
    plot.decomp(decomp, dates,...)
  }

###PLOT data ##################################################################
plot.decomp <- function(decomp, dates,...) {
    decomp <- stack(as.data.frame(decomp))
    period.name <- c("Long-term", "Seasonal", "2-12 months", "1-2 months",
                    "2-4 weeks", "1-2 weeks", "3.5 days to 1 week", "< 3.5 days")
    
    decomp <- data.frame(date = rep(dates, 8), decomp = decomp, 
              period = rep(period.name, each = length(dates)))
     
    decomp$period <- ordered(decomp$period, levels = period.name)
    
    #find year
    year <- as.factor(format(mydata$date, "\%Y"))
    mydata <- cbind(mydata, year)
    
    #determine begin/end year (+1) for gridlines and axis
    begin.year <- ISOdate(levels(year)[1], 1, 1, 0, 0)
    end.year <- ISOdate(as.numeric(levels(year)[length(levels(year))]) 
                + 1, 1, 1, 0, 0)
                
    xyplot(decomp.values ~ date|period, data = decomp, 
            type = "l", 
            as.table = T,
            layout = c(2, 4),
            scales = list(relation = "free", x = list(format = "\%Y", 
                    at = seq(begin.year, end.year, by = "2 year"))),...,
            
            panel = function(x, y,...) {
                    panel.abline(v = seq(begin.year, end.year, by = "year"), 
                                col = "grey85")
                    panel.grid(h = -1, v = 0)
                    panel.xyplot(x, y,...)
            }
    )
  }
###############################################################################        

######################################################################
## Decompose a vector into a matrix of "fourier" components
##
## Author:  Aidan McDermott (AMcD), modified by Roger Peng <rpeng@jhsph.edu>
## Date  :  Dec 8, 2000
## Adapted by David Carslaw Feb 2008
######################################################################

tsdecomp <- function(x, dates) {
    #consider fixed breaks
    breaks <- c(1, 2, round(length(x)/c(345, 60, 30, 14, 7, 3.5)), length(x))

    ## Check for missing values
    nax <- is.na(x)
    if(nas <- any(nax))
        x <- x[!nax]

    ## Need to be careful if length(x) is even or odd
    is.even <- !length(x) \%\% 2

    xf  <- fft(x) / length(x)
    xf1 <- xf[1]   # first bit is the sum of x
    xf.first <- xf[2:(1 + floor(length(xf) / 2))]

    ## Break xf.first into various components
    cuts  <- cut(seq(length(xf.first)), breaks, include.lowest = TRUE)
    lcuts <- levels(cuts)
    ncuts <- length(lcuts)

    mat <- matrix(0, nrow = length(x), ncol = ncuts)

    for(i in 1:ncuts) {
        xf.temp <- rep(0, length(xf.first))
        xf.temp[cuts == lcuts[i]] <- xf.first[cuts == lcuts[i]]

        d <- if(is.even)
            c(xf1 / ncuts, xf.temp, rev(Conj(xf.temp[-length(xf.temp)])))
        else
            c(xf1 / ncuts, xf.temp, rev(Conj(xf.temp)))
        mat[, i] <- Re(fft(d, inverse = TRUE))
    }
    if(nas) {
        nmat <- matrix(NA, length(nax), NCOL(mat))
        nmat[!nax, ] <- mat
        mat <- nmat
    }
    structure(mat, breaks = breaks, class = c("tsdecomp", "matrix"))
  }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
