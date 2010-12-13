\name{openair.class}

\alias{openair.generics}
\alias{names.openair}
\alias{print.openair}
\alias{plot.openair}
\alias{summary.openair}
\alias{results.openair}
\alias{results}


\title{ Generic functions for handling openair outputs }

\description{
  Many openair functions generate outputs of class "openair". These can be 
  manipulated using generic functions like print, plot and summary in a 
  similar fashion to objects of other R classes. 
}

\usage{

\method{names}{openair}(x, ...)

\method{summary}{openair}(object, subset = "all", ...)

\method{plot}{openair}(x, subset = "all", silent = TRUE, ...)

\method{print}{openair}(x, silent = FALSE, plot = TRUE, ...)

\method{results}{openair}(object, subset = "all", silent = FALSE, ...)

}

\arguments{

  \item{x, object}{ Object. For direct use of \code{print}, \code{plot}, \code{summary}, etc, 
  must be an output from an openair function of class ``openair''. }

  \item{subset}{ If \code{x} (or \code{object} in \code{summary}) is a multiple component 
  openair output, the subset of \code{x} (or \code{object} to use. Default \code{"all"} 
  or alternative \code{NULL} extract and use all available subsets.  
  For \code{summary}, \code{subset} can be one or more valid data frame within \code{object}. 
  For plot elements, e.g graphics produced by \code{plot} or 
  \code{print}, only the first valid case in \code{subset} is extracted. } 

  \item{silent}{ Logical (TRUE/FALSE). Do not print output descriptions to console. }

  \item{plot}{ Logical (TRUE/FALSE). For \code{print}, plot 
  graphical components of \code{x} using \code{plot} (or more strictly \code{plot.openair}, 
  default \code{TRUE}.}
   
  \item{...}{ Addition options, typically passed to associated default method(s).}

}

\value{
  Generic functions provide appropriate (conventional) handling of openair function 
  outputs, or objects of ``openair'' class: 

  \code{plot(x)} reproduces the original plot. If the original plot contains multiple components, 
  the option \code{subset} can be used to produce subplots individually.  

  \code{print(x)} provides a (to console) description of \code{x} and reproduces the associated 
  plot. As with \code{plot}, if \code{x} has multiple components, \code{subset} can be used to 
  access individual subsets of data and associated plots.

  \code{results(object)} extracts the data used to generate the original \code{object} 
  plot. If \code{object} contains more than data frame, these are returned as a list 
  of data frames. Alternatively, in such cases the option \code{subset} can be used 
  to extract one or more data frame from the supplied object.

  NOTE: \code{results} is not strictly a generic function. The term and mode of operation 
  is not widely used elsewhere in R. It is, however, convenient to consider it 
  alongside the \code{openair.generics} because it operates on openair objects and because 
  it has been implemented as method in a similar fashion to the generic terms. The 
  default form of \code{results} (that used if \code{object} is not of ``openair'' 
  class) currently returns \code{object} without modification.

  \code{summary(object)} summarises data in \code{object}. If \code{object} contains 
  more than data frame, each data frame is summarised individually and results returned 
  as a list of summaries. As above the option \code{subset} can be used to extract one 
  or more data frame to be summarised.
}

\author{ Karl Ropkins }

\examples{

\dontrun{

#make object
ans <- trendLevel(mydata, pollutant = "nox")

#use generics
print(ans)

#recover data
myresults <- results(ans)
head(myresults)

} 

}

\keyword{methods}
