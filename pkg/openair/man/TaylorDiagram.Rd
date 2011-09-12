\name{TaylorDiagram}
\alias{TaylorDiagram}
\title{Taylor Diagram for model evaluation with conditioning}
\usage{
  TaylorDiagram(mydata, newdata = NULL, obs = "obs", mod =
  "mod", group = NULL, type = "default", normalise = FALSE,
  layout = NULL, cols = "brewer1", main = "", ylab = NULL,
  xlab = NULL, pch = 20, cex = 2, rms.col =
  "darkgoldenrod", cor.col = "black", arrow.lwd = 3, key =
  TRUE, key.title = group, key.columns = 1, key.pos =
  "bottom", strip = TRUE, auto.text = TRUE, ...)
}
\arguments{
  \item{mydata}{A data frame minimally containing a column
  of observations and a column of predictions.}

  \item{newdata}{Optional second data frame in the same
  format as \code{mydata} that can be used for comparison
  with \code{mydata}. By supplying a second data from,
  \code{TaylorDiagram} can be used to show how one model
  output compares with another. This is useful, for example
  for model development when changes to the model or input
  data can easily be compared with a previous version. If
  \code{newdata} is supplied then arrows are drawn on the
  Diagram connecting the first set of model statistics
  (using \code{mydata}) with the second set (using
  \code{newdata}).}

  \item{obs}{A column of observations with which the
  predictions (\code{mod}) will be compared.}

  \item{mod}{A column of model predictions.}

  \item{group}{The \code{group} column is used to
  differentiate between different models and can be a
  factor or character. The total number of models compared
  will be equal to the number of unique values of
  \code{group}.}

  \item{type}{\code{type} determines how the data are split
  i.e. conditioned, and then plotted. The default is will
  produce a single plot using the entire data. Type can be
  one of the built-in types as detailed in \code{cutData}
  e.g. "season", "year", "weekday" and so on. For example,
  \code{type = "season"} will produce four plots --- one
  for each season.

  It is also possible to choose \code{type} as another
  variable in the data frame. If that variable is numeric,
  then the data will be split into four quantiles (if
  possible) and labelled accordingly. If type is an
  existing character or factor variable, then those
  categories/levels will be used directly. This offers
  great flexibility for understanding the variation of
  different variables and how they depend on one another.

  Type can be up length two e.g. \code{type = c("season",
  "weekday")} will produce a 2x2 plot split by season and
  day of the week. Note, when two types are provided the
  first forms the columns and the second the rows.}

  \item{normalise}{Should the data be normalised by
  dividing the standard deviation of the observations? The
  statistics can be normalised (and non-dimensionalised) by
  dividing both the RMS difference and the standard
  deviation of the \code{mod} values by the standard
  deviation of the observations (\code{obs}). In this case
  the "observed" point is plotted on the x-axis at unit
  distance from the origin. This makes it possible to plot
  statistics for different species (maybe with different
  units) on the same plot.}

  \item{layout}{Determines how the panels are laid out. By
  default, plots will be shown in one column with the
  number of rows equal to the number of pollutants, for
  example. If the user requires 2 columns and two rows,
  layout should be set to \code{layout = c(2, 2)}. In
  general, layout is expressed as number of columns times
  number of rows.}

  \item{cols}{Colours to be used for plotting. Options
  include "default", "increment", "heat", "spectral",
  "hue", "brewer1", "greyscale" and user defined (see
  \code{openColours} for more details). The same line
  colour can be set for all pollutant e.g. \code{cols =
  "black"}.}

  \item{main}{The plot title; default is no title.}

  \item{ylab}{Name of y-axis variable. By default will use
  the name of \code{y}.}

  \item{xlab}{Name of x-axis variable. By default will use
  the name of \code{x}.}

  \item{pch}{The symbol type used for plotting. Default is
  to provide different symbol types for different
  pollutant. If one requires a single symbol for all
  pollutants, the set \code{pch = 1}, for example.}

  \item{cex}{Size of symbol used.}

  \item{rms.col}{Colour for centred-RMS lines and text.}

  \item{cor.col}{Colour for correlation coefficient lines
  and text.}

  \item{arrow.lwd}{Width of arrow used when used for
  comparing two model outputs.}

  \item{key}{Should the key be shown?}

  \item{key.title}{Title for the key.}

  \item{key.columns}{Number of columns to be used in the
  key. With many pollutants a single column can make to key
  too wide. The user can thus choose to use several columns
  by setting \code{columns} to be less than the number of
  pollutants.}

  \item{key.pos}{Position of the key e.g. "top", "bottom",
  "left" and "right". See details in \code{lattice:xyplot}
  for more details about finer control.}

  \item{strip}{Should a strip be shown?}

  \item{auto.text}{Either \code{TRUE} (default) or
  \code{FALSE}. If \code{TRUE} titles and axis labels will
  automatically try and format pollutant names and units
  properly e.g.  by subscripting the `2' in NO2.}

  \item{...}{Other graphical parameters passed onto
  \code{lattice:xyplot} and \code{cutData}. For example, in
  the case of \code{cutData} the option \code{hemisphere =
  "southern"}.}
}
\value{
  As well as generating the plot itself,
  \code{TaylorDiagram} also returns an object of class
  ``openair''. The object includes three main components:
  \code{call}, the command used to generate the plot;
  \code{data}, the data frame of summarised information
  used to make the plot; and \code{plot}, the plot itself.
  If retained, e.g. using \code{output <-
  TaylorDiagram(thedata, obs = "nox", mod = "mod")}, this
  output can be used to recover the data, reproduce or
  rework the original plot or undertake further analysis.
  For example, \code{output$data} will be a data frame
  consisting of the group, type, correlation coefficient
  (R), the standard deviation of the observations and
  measurements.

  An openair output can be manipulated using a number of
  generic operations, including \code{print}, \code{plot}
  and \code{summary}. See \code{\link{openair.generics}}
  for further details.
}
\description{
  Function to draw Taylor Diagrams for model evaluation.
  The function allows conditioning by any categorical or
  numeric variables, which makes the function very
  flexible.
}
\details{
  The Taylor Diagram is a very useful model evaluation
  tool. Details of the diagram can be found at
  \url{http://www-pcmdi.llnl.gov/about/staff/Taylor/CV/Taylor_diagram_primer.pdf}.
  The diagram provides a way of showing how three
  complementary model performance statistics vary
  simultaneously. These statistics are the correlation
  coefficient R, the standard deviation (sigma) and the
  (centred) root-mean-square error. These three statistics
  can be plotted on one (2D) graph because of the way they
  are related to one another which can be represented
  through the Law of Cosines.

  The \code{openair} version of the Taylor Diagram has
  several enhancements that increase its flexibility. In
  particular, the straightforward way of producing
  conditioning plots should prove valuable under many
  circumstances (using the \code{type} option). Many
  examples of Taylor Diagrams focus on model-observation
  comparisons for several models using all the available
  data. However, more insight can be gained into model
  performance by partitioning the data in various ways e.g.
  by season, daylight/nighttime, day of the week, by levels
  of a numeric variable e.g. wind speed or by land-use type
  etc.

  Note that it is important that each panel represents data
  with the same mean measured data across different groups.
  Therefore \code{TaylorDiagram(mydata, group = "model",
  type = "season")} is OK, whereas
  \code{TaylorDiagram(mydata, group = "season", type =
  "model")} is not because each panel (representing a
  model) will have four different mean values --- one for
  each season.  Generally, the option \code{group} is
  either missing (one model being evaluated) or represents
  a column giving the model name
}
\examples{
## dummy model data for 2003
dat <- selectByDate(mydata, year = 2003)
dat <- data.frame(date = mydata$date, obs = mydata$nox, mod = mydata$nox)

## now make mod worse by adding bias and noise according to the month
## do this for 3 different models
dat <- transform(dat, month = as.numeric(format(date, "\%m")))
mod1 <- transform(dat, mod = mod + 10 * month + 10 * month * rnorm(nrow(dat)), model = "model 1")
## lag the results for mod1 to make the correlation coefficient worse without affecting the sd
mod1 <- transform(mod1, mod = c(mod[5:length(mod)], mod[(length(mod) - 3) : length(mod)]))

## model 2
mod2 <- transform(dat, mod = mod + 7 * month + 7 * month * rnorm(nrow(dat)), model = "model 2")
## model 3
mod3 <- transform(dat, mod = mod + 3 * month + 3 * month * rnorm(nrow(dat)), model = "model 3")

mod.dat <- rbind(mod1, mod2, mod3)

## basic Taylor plot

TaylorDiagram(mod.dat, obs = "obs", mod = "mod", group = "model")

## Taylor plot by season
TaylorDiagram(mod.dat, obs = "obs", mod = "mod", group = "model", type = "season")

## now show how to evaluate model improvement (or otherwise)
mod1a <- transform(dat, mod = mod + 2 * month + 2 * month * rnorm(nrow(dat)), model = "model 1")
mod2a <- transform(mod2, mod = mod * 1.3)
mod3a <- transform(dat, mod = mod + 10 * month + 10 * month * rnorm(nrow(dat)), model = "model 3")
mod.dat2 <- rbind(mod1a, mod2a, mod3a)

## basic model change plot
TaylorDiagram(mod1, mod1a, obs = "obs", mod = "mod")

## do for all models
TaylorDiagram(mod.dat, mod.dat2, obs = "obs", mod = "mod", group = "model")

## all models, by season
TaylorDiagram(mod.dat, mod.dat2, obs = "obs", mod = "mod", group = "model", type = "season")
}
\author{
  David Carslaw
}
\references{
  Taylor, K.E.: Summarizing multiple aspects of model
  performance in a single diagram. J.  Geophys. Res., 106,
  7183-7192, 2001 (also see PCMDI Report 55,
  \url{http://wwwpcmdi.  llnl.gov/publications/ab55.html})

  IPCC, 2001: Climate Change 2001: The Scientific Basis,
  Contribution of Working Group I to the Third Assessment
  Report of the Intergovernmental Panel on Climate Change
  [Houghton, J.T., Y. Ding, D.J. Griggs, M. Noguer, P.J.
  van der Linden, X. Dai, K. Maskell, and C.A.  Johnson
  (eds.)]. Cambridge University Press, Cambridge, United
  Kingdom and New York, NY, USA, 881 pp. (see
  \url{http://www.grida.no/climate/ipcc_tar/wg1/317.htm#fig84})
}
\seealso{
  \code{taylor.diagram} from the \code{plotrix} package
  from which some of the annotation code was used.
}
\keyword{methods}

