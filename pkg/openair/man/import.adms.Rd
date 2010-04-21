\name{import.adms...}

\alias{import.adms}
\alias{import.ADMS}
\alias{import.adms.bgd}
\alias{import.ADMS.bgd}

\title{ ADMS data import function(s) for openair }
\description{
  Family of functions to import various ADMS file types into openair. Functions currently handle 
  ".met", ".bgd" and ".mop" file structures. Functions use \code{read.csv} (in \code{utils}) to 
  read in data, format in standard R and include some file structure testing. }


\usage{

mydata <- import.adms(file = file.choose(), 
		file.type="unknown", ...)

mydata <- import.ADMS(file = file.choose(), ...)

mydata <- import.adms.bgd(file = file.choose(), 
		drop.case = TRUE, drop.input.dates = TRUE, keep.units = TRUE, 
		test.file.structure = TRUE, ...)

mydata <- import.ADMS.bgd(file = file.choose(), ...)

 
}

\arguments{

  \item{file}{ The ADMS file to be imported. Default, \code{file.choose()} 
  opens browser. Use of \code{read.csv} (in \code{utils}) also allows this to be 
  a readable text-mode connection or url (although these options are currently not fully
  tested). }

  \item{file.type}{ Type of ADMS file to be imported. With default, "unknown", the import 
  uses the file extension to identify the file type and, where recognised, uses this to 
  identify the correct import.adms... daughter function to complete the import operation. 
  Where file type can not be identifed correctly by the parent import function, the choice 
  can be forced by settting \code{file.type} to "bgd", "met" or "mop" or using calling the 
  daughter import function directly: \code{import.adms.bgd}, \code{import.adms.met} or 
  \code{import.adms.mop}, as required. 

  (NOTE: file.type ignored if used as part of a daughter function call.)}

  \item{drop.case}{ Option to convert all data names to lower case. Default, \code{TRUE}. 
  Alternative, \code{FALSE}, returns data with name cases as defined in file. }

  \item{drop.input.dates}{ Option to remove ADMS "hour", "day", and "year" data columns 
  after generating openair "date" timeseries. Default, \code{TRUE}. Alternative, \code{FALSE}, 
  returns both "date" and the associated ADMS data columns. }

  \item{keep.units}{ Option to retain ADMS data units. Default, \code{TRUE}, 
  retains units as character vector in data frame comment if defined in \code{file}. 
  Alternative, \code{FALSE}, discards units. 

  (NOTE: currently, \code{.bgd} files only.) }

  \item{test.file.structure}{ Option to test file structure before trying to import. Default, 
  \code{TRUE}, tests for expected file structure and halts import operation if not found. 
  Alternative, \code{FALSE}, forces import regardless of structure. 

  (NOTE: currently, \code{.bgd} files only.) }

  \item{simplify.names}{ Option to simplify data names in accordance with common \code{openair} 
  practices. Default, \code{TRUE}. Alternative, \code{FALSE}, returns data with names as 
  interpreted by standard R. 

  (NOTE 1: Some ADMS file data names include symbols or structures that 
  R does not allow, so \code{simplify.names=FALSE} can produce some interesting results.)  

  (NOTE 2: currently, \code{.bgd} files only.)}

  \item{...}{Additional arguments. For \code{import.adms} and \code{import.adms.bgd}, these are passed on to and handled 
  by \code{read.csv}. For \code{import.ADMS} and \code{import.ADMS.bgd}, these are passed onto the associated .adms. function, 
  handled by that or, in turn, passed on to \code{read.csv}. 

  (Note: .ADMS. functions are wrappers for equivalent .adms. functions to 
  allow use of upper and lower ADMS in function calls.)}       

} 

\details{ The \code{import.adms...} function family were developed to help import various 
ADMS file types into openair. In most cases the import function(s) should be used in their 
default configurations, e.g. \code{mydata <- import.adms()}. However, where file variations 
are encountered or more direct control is required, specific functions can be called directly, 
and fine tuned using arguments.   
}

\value{ The function returns a data
frame for use in openair. By comparison to the original file, the
resulting data frame is modified as follows: Time and date information
will combined in a single column "date", formatted as a conventional
timeseries (\code{\link{as.POSIX*}}). If name simplification was requested
(\code{simplify.names = TRUE}), common chemical names may be simplified, and 
some other parameters may be reset to openair standards (e.g. "ws", "wd" and 
"temp"). Data units information may also be retained as part of the data 
frame comment. }

\author{ Karl Ropkins and David Carslaw, with significant input, help and advice 
from Matthew Williams (CERC) also gratefully acknowledged. }

\section{Warning }{The \code{import.adms} function family is currently released as a
test version only.}

\seealso{Generic import function \code{\link{import}}, for possible alternative import methods. 
Other dedicated import functions available for other file types, including
\code{\link{import.LAQN}}, \code{\link{import.aurn}}, etc. }

\examples{

##########
#example 1
##########
#To be confirmed

}
\keyword{methods}


