\name{draw.openkey}

\alias{draw.openkey}

\title{ Scale key handling for openair }

\description{
  General function for producing scale keys for other openair functions. 
  Currently, in development and only (nominally) enabled for wind.rose 
  and pollution.rose. 
}


\usage{

draw.openkey(key,
	draw = FALSE,
	vp = NULL)
 
}

\arguments{

  \item{key}{List defining the scale key structure to be produced.}

  \item{draw}{Option to return the key object or plot it directly. 
  The default, FALSE, should always be used within openair calls.}

  \item{vp}{View port to be used when plotting key. The default, 
  NULL, should always be used within openair calls.

  (Note: draw.openkey is currently in development. Arguments and 
  options may be subject to signficant modification. Please use 
  parent openair function control where possible as these are 
  likely to be subject to less change.)}       
}
 

\details{ The \code{draw.openkey} function produces scale keys 
  for other openair functions.

  The function is currently in development. 

  It is not recommended that it be used directly at this stage.  

}

\value{ The function returns a scale key using a similar mechanism 
  to that used in \code{\link{draw.colorkey}} as developed by 
  Deepayan Sarkar. 
}

\section{Warning }{The \code{draw.openkey} function is currently in 
  development and likely to be subject to significant revision.}

\author{ Karl Ropkins. }

\note{ We gratefully acknoweldge the considerable help and advice of 
  Deepayan Sarkar. }

\seealso{Functions using \code{draw.openkey} currently include 
  \code{\link{windRose}}, \code{\link{pollutionRose}}. }


\examples{

##########
#example 1
##########
#To be confirmed

}
\keyword{methods}


