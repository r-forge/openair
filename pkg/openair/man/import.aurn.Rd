\name{import.aurn}
\alias{import.aurn}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ AURN Data import for openair }
\description{
  Function for importing common hourly (or 1 hour average) UK Automatic Urban and Rural Network (AURN) Air Quality Archive data files for use with the openair package. Argument modification allows the import of other similar file structures. The function uses read.table (in utils) and rbind (in reshape).
}
\usage{
import.aurn(file,
header.at = 5,
data.at = 7,
na.strings = c("No data", "", "NA"),
date.name = "Date",
date.break = "-",
time.name = "time",
 misc.info = c(1, 2, 3, 4),
is.site = 4,
bad.24 = TRUE,
correct.time = -3600,
output = "final",
data.order = c("value", "status", "unit"),
simplify.names = TRUE, ...)
}

%- maybe also 'usages' for other objects documented here.
\arguments{
  \item{file}{ The name of the AURN file to be imported. Use of
    read.table(utils) also allows this to be a readable text-mode
    connection or url (although these options are currently not fully
  tested). }

  \item{header.at}{ The file row holding header information. This is
  used to set names for the resulting imported data frame, but may be
  subject to further modifications depending on following argument
  settings. }

  \item{data.at}{ The first file row holding actual data. When
  generating the data frame, the function will ignore all information
  before this row, and attempt to include all data from this row
  onwards. }

\item{na.strings}{ Strings of any terms that are to be interpreted as
  NA values within the file. }

 \item{date.name}{ Header name of column holding date
  information. Combined with time information as single date column in
  the generated data frame. }

\item{date.break}{ The break character separating days, months and
  years in date information. For example, "-" in "01-01-2009". }

\item{time.name}{ Header name of column holding time
  information. Combined with date information as single date column in
  the generated data frame. }

\item{misc.info}{ Row numbers of any additional information that may
  be required from the original file. Each line retained as a character
  vector in the generated data frame comment. }

\item{is.site}{ Header name of column holding site
  information. Default NULL turns this option off. }

\item{bad.24}{ Reset AURN 24 time stamp. AURN time series are logged
  as 00:00:01 to 24:00:00 as opposed to the more conventional 00:00:00
  to 23:59:59. bad.24 = TRUE resets the time stamp which is not allowed
  in some time series classes or functions.}

\item{correct.time}{ Numerical correction (in seconds) for imported
  date. AURN data is logged retrospectively. For 1 hour average data,
  correct.time = -3600 resets this to the start of the sampling
  period. }

\item{output}{set to "final".}

\item{data.order}{ A vector of names defining the type of order of
  data types. AURN files typically include three data types, actual data
  and associated data quality and measurement unit reports. Here, these
  are defined as "value", "status" and "unit", respectively. }

\item{simplify.names}{ A logical prompting the function to try to
  simply data frame names using common chemical shorthand
  (TRUE/FALSE). FALSE retains names from file, although these may be
  modified if not unique. }

\item{ldots}{Other parameters - not used currently.}


} \details{ The import.aurn() function was developed for use with air
quality monitoring site data files, downloaded in standard hourly (or 1
hour average) format using the Air Quality Archive email
service. Argument defaults are set to common values to simplify both
import and use with openair.  }

\value{ The function returns a data
frame for use in openair. By comparison to the original file, the
resulting data frame is modified as follows: Time and date information
will combined in a single column 'date', formatted as a conventional
timeseries (as.POSIX*). Time adjustments may also be made, subject to
bad.24 and correct.time argument settings.  Using default settings, the
argument correct.time = - 3600 resets the time stamp to the start of the
measurement period Columns identified as wind speed and wind direction
information using 'is.ws' and 'is.wd', respectively, will be renamed
'ws' and 'wd', respectively.  If name simplification was requested
(simplify.names = TRUE), common chemical names will be simplified. For
example, "carbon monoxide" will be reset to "co". Currently, this option
only applies to inorganics and particulates, not organics.  Non-value
information will be rationalised according to data.order. For example,
for the default, data.order = c("value", "status", "unit"), the status
and unit columns following the 'co' column will be automatically renamed
'unit.co' and 'status.co', respectively.  An additional 'site' column
will be generated, which allows mulitple site data frame operations.
Any additional information (as defined in 'misc.info') and data
adjustments (as set in''bad.24' and 'correct.time') will be retained in
the data frame comment.  }

\author{ Karl Ropkins }

\section{Warning }{The import.aurn() function is currently released as a
  test version.}

\examples{

##########
#example 1
##########
#data obtained from email service:
#http://www.airquality.co.uk/archive/data_selector.php
#or
#http://www.airquality.co.uk/archive/data_and_statistics.php?action=step_pre_1
#example file "AirQualityDataHourly.csv" Brighton Roadside and Brighton Preston Park 2008.

#import data as mydata
## mydata <- import.aurn("AirQualityDataHourly.csv")

#read additional information retained by import.aurn
## comment(mydata)

#analysis data by site
## boxplot(nox ~ site, data = mydata)

##########
#example 2
##########
#example using data from url

#import data as otherdata
## otherdata <- import.aurn(
##  "http://www.airquality.co.uk/archive/data_files/site_data/HG1_2007.csv")

#use openair function
## summarise(otherdata)

##########
#example 3
##########
#example of importing other similar data formats

#import 15 min average so2 data from Bexley using url
## so2.15min.data <- import.aurn(
##  "http://www.airquality.co.uk/archive/data_files/15min_site_data/BEX_2008.csv",
##  correct.time = -900)

#note: correct.time amended for 15 min offset/correction.

#additional comments
## comment(so2.15min.data)

#analysis
## diurnal.error(so2.15min.data, pollutant="so2")

#wrapper for above
##(e.g. if you have to do this -or similar- a lot of time)
## import.aurn.wrapper <- function(file, correct.time = -900, ...)
##  { import.aurn(file = file, correct.time = correct.time, ...) }

#same as above
## so2.15min.data.again <- import.aurn.wrapper(
##  "http://www.airquality.co.uk/archive/data_files/15min_site_data/BEX_2008.csv")

#analysis
## diurnal.error(so2.15min.data.again, pollutant="so2")

}
\keyword{methods}


