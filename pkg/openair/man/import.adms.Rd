\name{import.adms...}

\alias{import.adms}
\alias{import.ADMS}
\alias{import.adms.bgd}
\alias{import.ADMS.bgd}
\alias{import.adms.met}
\alias{import.ADMS.met}
\alias{import.adms.mop}
\alias{import.ADMS.mop}

\title{ ADMS data import function(s) for openair }
\description{
  Family of functions to import various ADMS file types into openair. Functions currently handle 
  ".met", ".bgd" and ".mop" file structures. Functions use \code{read.csv} (in \code{utils}) to 
  read in data, format in standard R and include some file structure testing. }


\usage{

mydata <- import.adms(file = file.choose(), 
		file.type="unknown", ...)

mydata <- import.ADMS(...)

mydata <- import.adms.bgd(file = file.choose(), 
		drop.case = TRUE, drop.input.dates = TRUE, keep.units = TRUE, 
		simplify.names = TRUE, test.file.structure = TRUE, ...)

mydata <- import.ADMS.bgd(...)

mydata <- import.adms.met(file = file.choose(), 
		drop.case = TRUE, drop.input.dates = TRUE, keep.units = TRUE, 
		simplify.names = TRUE, test.file.structure = TRUE, ...)

mydata <- import.ADMS.met(...)

mydata <- import.adms.mop(file = file.choose(), 
		drop.case = TRUE, drop.input.dates = TRUE, keep.units = TRUE, 
		simplify.names = TRUE, test.file.structure = TRUE, 
		drop.delim = TRUE, add.prefixes = TRUE, ...)

mydata <- import.ADMS.mop(...)
 
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
  Alternative, \code{FALSE}, forces import regardless of structure. } 

  \item{simplify.names}{ Option to simplify data names in accordance with common \code{openair} 
  practices. Default, \code{TRUE}. Alternative, \code{FALSE}, returns data with names as 
  interpreted by standard R. 

  (NOTE 1: currently, \code{.met} files only.)

  (NOTE 2: Some ADMS file data names include some symbols and structures that R does not allow as 
  part of a name, so some renaming is automatic regardless of \code{simplify.names} setting. 
  For example, brackets or symbols are removed from names or repaced with ".", and names in the 
  form "1/x" are returned as "recip.x".) }  

  \item{drop.delim}{ Option to remove delim columns from the data frame. ADMS .mop files include 
  two columns, "INPUT_DATA:" and "PROCESSED_DATA:", to separate model input and output types. 
  Default, \code{TRUE}, removes these. Alternative, \code{FALSE}, retains them as part of import. 

  (NOTE: currently, \code{.mop} files only.)}

  \item{add.prefixes}{ Option to add prefixes to data names. ADMS .mop files include a number of
  input and process data types with shared names. Prefixes can be automatically added to these so 
  individual data can be readily identified in the R/openair environment. Default, \code{TRUE}, 
  adds "process." as a prefix to processed data. Other options include: \code{FALSE} which uses no 
  prefixes and leave all name rationalisation to R, and character vectors which are treated as the 
  required prefixes. If one vector is sent, this is treated as processed data prefix. If two (or more) 
  vectors are sent, the first and second are treated as the input and processed data prefixes, 
  respectively. For example, the argument (\code{add.prefixes="out"}) would add the "out" prefix to 
  processed data names, while the argument (\code{add.prefixes=c("in","out")}) would add "in" and 
  "out" prefixes to input and output data names, respectively. 

  (NOTE: currently, \code{.mop} files only.)}

  \item{...}{Additional arguments. For \code{import.adms} and \code{import.adms...} daughters, these are passed on to and handled 
  by \code{read.csv}. For \code{import.ADMS} and \code{import.ADMS...} daughters, these are passed onto the associated .adms. function, 
  and handled by that function or, in turn, passed on the associated import function or \code{read.csv}. 

  (Note: ...ADMS... functions are wrappers for equivalent ...adms... functions to 
  allow use of upper and lower ADMS in function calls.)}       

} 

\details{ The \code{import.adms...} function family were developed to help import various 
ADMS file types into openair. In most cases the parent import function should work in 
default configuration, e.g. \code{mydata <- import.adms()}. However, where file variations 
are encountered or more direct control is required, specific functions can be called using the 
\code{file.type} argument and fine tuned using arguments, or used directly. }

\value{ The function returns a data
frame for use in openair. By comparison to the original file, the
resulting data frame is modified as follows: Time and date information
will combined in a single column "date", formatted as a conventional
timeseries (\code{as.POSIX*}). If name simplification was requested
(\code{simplify.names = TRUE}), common chemical names may be simplified, and 
some other parameters may be reset to openair standards (e.g. "ws", "wd" and 
"temp"). Data units information may also be retained as part of the data 
frame comment. }

\note{Times are assumed to be in GMT.}

\section{Warning }{The \code{import.adms} function family is currently released as a
test version only.}

\author{ Karl Ropkins and David Carslaw, with significant input, help and advice 
from Matthew Williams (CERC) also gratefully acknowledged. }

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


