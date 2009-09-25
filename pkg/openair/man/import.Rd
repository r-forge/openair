\name{import}
\alias{import}
%- NEED to check '\alias' working.
\title{ Data import for openair }
\description{Family of function(s) for importing and formatting data
for use with the openair package. Currently supported are: import, a
generic (workhorse) function, and import.aurn, a function for importing
UK Automatic Urban and Rural Network (AURN) Air Quality Archive hourly
(or 1 hour average) data. Both functions use read.table (in utils) and
import.aurn uses rbind (in reshape).  }

\usage{ import(file =
file.choose(), file.type="csv", header.at = 1, data.at = 2, eof.report =
NULL, na.strings = c("", "NA"), date.name = "date", date.break = "/",
date.order = "dmy", time.name = "date", time.break = ":", time.order =
"hm", time.format ="GMT", is.ws = NULL, is.wd = NULL, is.site = NULL,
misc.info = NULL, bad.24 = FALSE, correct.time = NULL, output = "final")
import.aurn(file = file.choose(), header.at = 5, data.at = 7, na.strings
= c("No data", "", "NA"), date.name = "Date", date.break = "-",
time.name = "time", misc.info = c(1, 2, 3, 4), is.site = 4, bad.24 =
TRUE, correct.time = -3600, output = "final", data.order = c("value",
"status", "unit"), simplify.names = TRUE, ...)  }

%- maybe also 'usages' for other objects documented here.
\arguments{
\item{file}{ The name of the file to be imported. Default, file =
file.choose(), opens browser. Alternatively, the use of read.table (in
utils) also allows this to be a character vector to be used as file
path, connection or url (although use as url currently not fully
tested). }

\item{file.type}{ The file format, defaults to common "csv"
  (comma delimited) format, but also allows "txt" (tab delimited). }

\item{header.at}{ The file row holding header information. This is used
  to set names for the resulting imported data frame. }

\item{data.at}{The file row to start reading data from. When generating the data frame,
the function will ignore all information before this row, and attempt to
include all data from this row onwards unless eof.report enabled. }

\item{eof.report}{ End of file marker. When genearating the data frame,
the function will ignore all information after eof.report is
encountered. The default setting (NULL) turns this argument off. }

\item{na.strings}{ Strings of any terms that are to be interpreted as NA
  values within the file. }

\item{date.name}{ Header name of column
holding date information. Combined with time information as single date
column in the generated data frame. }

\item{date.break}{ The break
character separating days, months and years in date information. For
example, "-" in "01-01-2009". }

\item{date.order}{ The order of date
information, using d for days, m for months and y for years. So, "dmy"
or "mdy" for common UK or US logger date stamp formats. Allows any
logical combination ("y", "ymd", etc). }

\item{time.name}{ Header name
of column holding time information. Combined with date information as
single date column in the generated data frame. }

\item{time.break}{ The
break character separating hours, minutes and seconds in time
information. For example, ":" in "12:00:00". }

\item{time.order}{ The
order of time information, using h for hours, m for minutes and s for
seconds. The argument allows any logical combination ("hm", "hms",
etc). }

\item{time.format}{ The time format the data was logged in,
"GMT" (default), "UTC", etc. See as.POSIX* functions for further
information. }

\item{is.ws}{ Wind speed information identifier. Default
NULL turns this option off. When set to valid header/data column name,
used to select wind speed data. Note: data renamed "ws" as part of this
operation. }

\item{is.wd}{ Wind direction information
identifier. Default NULL turns this option off. When set to valid
header/data column name, used to select wind direction data. Note: data
renamed "wd" as part of this operation. }

\item{is.site}{ Site
information identifier. Default NULL turns this option off. When set,
the standard (import) method uses this a site name and appends it to all
time intervals. Because AURN files include site in a fixed row,
import.aurn handles this uniquely, expecting the row number conatining
this information. It also restructures the data frame in accordance this
information using rbind (in reshape).}

\item{misc.info}{ Row numbers of
any additional information that may be required from the original
file. Each line retained as a character vector in the generated data
frame comment. }

\item{bad.24}{ Reset time stamp. Some time series are
logged as 00:00:01 to 24:00:00 as opposed to the more conventional
00:00:00 to 23:59:59. bad.24 = TRUE resets the time stamp for the
latter, which is not allowed by some R time series classes or
functions. }

\item{correct.time}{ Numerical correction (in seconds) for
imported date. Default NULL turns this option off. When enables, used to
offset file time entries. }

\item{output}{ Type of data object to be
exported to R. Default "final" returns a standard data set for use in
openair. Alternative "working" returns a list of file components for
further formatting, e.g. by wrappers such as import.aurn. }

\item{data.order}{ Unique to import.aurn. A vector of names defining the
type and order of data columns. AURN files typically include three data
types, actual data and associated data quality and measurement unit
reports. Here, these are defined as "value", "status" and "unit",
respectively. }

\item{simplify.names}{ Unique to import.aurn. A logical
prompting the function to try to simply data frame names using common
chemical shorthand (TRUE/FALSE). FALSE retains names from file, although
these may be modified if not unique. }

\item{...}{ Employed by wrapper
functions, e.g. import.aurn, to pass any other arguments to import to be
handled using standard methods. } }

\details{ The import() function was
developed as a generic function to import and format data for direct use
with the openair package. The main intention was simplify initial data
handling for those unfamilar with R, and, in particular, it time series
formatting requirements. Using deafult settings, import() imports files
configured like example file "example data long.csv" (supplied with
openair or available from the openair website). Other similar file
structures can be readily imported by modifying the function
arguments. More complex data importing and formatting can be achieved
using an import wrapper.  The import.aurn() function is an import
wrapper that uses import() with modified arguments to import the initial
data frame and rbind (in reshape) to complete additional
reformatting. The wrapper enforces unique handling of is.site and
employs two additional arguments, data.order and simplify.names handled
by the wrapper itself.  }

\value{ Using the default output = "final"
setting, the function(s) return a data frame for use in openair. By
comparison to the original file, the resulting data frame is modified as
follows: Time and date information will combined in a single column
'date', formatted as a conventional timeseries (as.POSIX*). Time
adjustments may also be made, subject to bad.24 and correct.time
argument settings.  Any additional time/date adjustment (e.g. by
'correction.time' or 'bad.24') will be logged to the data frame comment.
Columns identified as wind speed and wind direction information using
'is.ws' and 'is.wd', respectively, will be renamed 'ws' and 'wd',
respectively.  An additional 'site' column will be generated in
accordance with 'is.site' setting and associated function handling.  Any
additional information (as defined in 'misc.info') and data adjustments
(as set in''bad.24' and 'correct.time') will be retained in the data
frame comment.  Additional import.aurn() operations: If name
simplification was requested (simplify.names = TRUE), common chemical
names will be simplified. For example, "carbon monoxide" will be reset
to "co". Currently, this option only applies to inorganics and
particulates, not organics.  Likewise, any non-value information will be
rationalised according to data.order. For example, for the import.aurn
default, data.order = c("value", "status", "unit"), the status and unit
columns following the 'co' column will be automatically renamed
'unit.co' and 'status.co', respectively.  }
\author{ Karl Ropkins }

\note{ \section{Warning }{The import.aurn() function is currently
released as a test version.} ~ }

\seealso{See \code{\link{import}} and \code{\link{import.LAQN}}.}
\examples{

##########
#example 1
##########
#data obtained from http://www.openair-project.org

#import data as mydata
mydata <- import("example data long.csv")

#use openair function
polar.plot(mydata, pollutant="nox")

##########
#example 2
##########
#data obtained from email service:
#http://www.airquality.co.uk/archive/data_selector.php
#or
#http://www.airquality.co.uk/archive/data_and_statistics.php?action=step_pre_1
#example file "AirQualityDataHourly.csv" Brighton Roadside and Brighton Preston Park 2008.

#import data as mydata
mydata <- import.aurn("AirQualityDataHourly.csv")

#read additional information retained by import.aurn
comment(mydata)

#analysis data by site using R
boxplot(nox ~ site, data = mydata)

##########
#example 3
##########
#example using data from url

#import data as otherdata
otherdata <- import.aurn(
  "http://www.airquality.co.uk/archive/data_files/site_data/HG1_2007.csv")

#use openair function
summarise(otherdata)

##########
#example 4
##########
#example of importing other similar data formats

#import 15 min average so2 data from Bexley using url
so2.15min.data <- import.aurn(
  "http://www.airquality.co.uk/archive/data_files/15min_site_data/BEX_2008.csv",
  correct.time = -900)

#note: correct.time amended for 15 min offset/correction.

#additional comments
comment(so2.15min.data)

#analysis
diurnal.error(so2.15min.data, pollutant="so2")

#wrapper for above
##(e.g. if you have to do this -or similar- a lot of time)
import.aurn.wrapper <- function(file = file.choose(), correct.time = -900, ...)
  { import.aurn(file = file, correct.time = correct.time, ...) }

#same as above
so2.15min.data.again <- import.aurn.wrapper(
  "http://www.airquality.co.uk/archive/data_files/15min_site_data/BEX_2008.csv")

#analysis
diurnal.error(so2.15min.data.again, pollutant="so2")

}
\keyword{ ~import }
\keyword{ ~import.aurn }
\keyword{ ~UK Air Quality Archive }
\keyword{ ~AURN data importing }

