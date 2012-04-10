\name{conditionalEval}
\alias{conditionalEval}
\title{Conditional quantile estimates with additional variables for model evaluation}
\usage{
  conditionalEval(mydata, obs = "obs", mod = "mod",
    var.obs = "var.obs", var.mod = "var.mod",
    type = "default", bins = 31, statistic = "MB",
    xlab = "predicted value", ylab = "statistic",
    col = brewer.pal(5, "YlOrRd"), col.var = "Set1",
    var.names = NULL, auto.text = TRUE, ...)
}
\arguments{
  \item{mydata}{A data frame containing the field
  \code{obs} and \code{mod} representing observed and
  modelled values.}

  \item{obs}{The name of the observations in
  \code{mydata}.}

  \item{mod}{The name of the predictions (modelled values)
  in \code{mydata}.}

  \item{var.obs}{Other variable observations for which
  statistics should be calculated. Can be more than length
  one e.g. \code{var.obs = c("nox.obs", "ws.obs")}.}

  \item{var.mod}{Other variable predictions for which
  statistics should be calculated. Can be more than length
  one e.g. \code{var.obs = c("nox.obs", "ws.obs")}.}

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
  different variables and how they depend on one another.}

  \item{bins}{Number of bisn used in
  \code{conditionalQuantile}.}

  \item{statistic}{Statistic(s) to be plotted. Can be "MB",
  "NMB", "r", "IOA", "MGE", "NMGE", "RMSE", "FAC2", as
  described in \code{modStats}. Can also be "cluster" if
  clusters have been calculated using \code{trajCluster}.}

  \item{xlab}{label for the x-axis, by default
  \code{"predicted value"}.}

  \item{ylab}{label for the y-axis, by default
  \code{"observed value"}.}

  \item{col}{Colours to be used for plotting the
  uncertainty bands and median line. Must be of length 5 or
  more.}

  \item{col.var}{Colours for the additional variables to be
  compared. See \code{openColours} for more details.}

  \item{var.names}{Variable names to be shown on plot for
  plotting \code{var.obs} and \code{var.mod}.}

  \item{auto.text}{Either \code{TRUE} (default) or
  \code{FALSE}. If \code{TRUE} titles and axis labels etc.
  will automatically try and format pollutant names and
  units properly e.g.  by subscripting the `2' in NO2.}

  \item{...}{Other graphical parameters passed onto
  \code{conditionalQuantile} and \code{cutData}. For
  example, \code{conditionalQuantile} passes the option
  \code{hemisphere = "southern"} on to \code{cutData} to
  provide southern (rather than default northern)
  hemisphere handling of \code{type = "season"}. Similarly,
  common axis and title labelling options (such as
  \code{xlab}, \code{ylab}, \code{main}) are passed to
  \code{xyplot} via \code{quickText} to handle routine
  formatting.}
}
\description{
  This function enhances \code{\link{conditionalQuantile}}
  by also considering how other variables vary over the
  same intervals. Conditional quantiles are very useful on
  their own for model evaluation, but provide no direct
  information on how other variables change at the same
  time. For example, a conditional quantile plot of ozone
  concentrations may show that low concentrations of ozone
  tend to be under-predicted. However, the cause of the
  under-prediction can be difficult to determine.
}
\details{
  The \code{conditionalEval} function simultaneously plots
  the model performance of other observed/predicted
  variables pairs according to different model evaluation
  statistics. These statistics derive from the
  \code{\link{modStats}} function and include "MB", "NMB",
  "r", "IOA", "MGE", "NMGE", "RMSE" and "FAC2". More than
  one statistic can be supplied. Bootstrap samples are
  taken from the corresponding values of other variables to
  be plotted and their statistics calculated. For example,
  a model may also provide predictions of NOx and wind
  speed (for which there are also observations available).
  The \code{conditionalEval} function will show how well
  these other variables are predicted for the same
  intervals of the main variables assessed in the
  conditional quantile. The analysis could show for
  example, when ozone concentrations are under-predicted,
  the model may also be shown to over-predict
  concentrations of NOx at the same time, or under-predict
  wind speeds. Such information can thus help identify the
  underlying causes of poor model performance. One or more
  additional variables can be plotted.

  A special case is \code{statistic = "cluster"}. In this
  case a data frame is provided that contains the cluster
  calculated by \code{\link{trajCluster}} and
  \code{\link{importTraj}}. Alternatively users could
  supply their own calculated clusters. These calculations
  can be very useful in showing whether certain back
  trajectory clusters are associated with poor (or good)
  model performance. Note that in the case of
  \code{statistic = "cluster"} there will be fewer data
  points used in the analysis compared with the ordinary
  statistics above because the trajectories are available
  for every three hours. Also note that \code{statistic =
  "cluster"} cannot be used together with the ordinary
  model evaluation statistics such as MB.

  Far more insight can be gained into model performance
  through conditioning using \code{type}. For example,
  \code{type = "season"} will plot conditional quantiles by
  each season. \code{type} can also be a factor or
  character field e.g. representing different models used.

  See Wilks (2005) for more details and the examples below.
}
\examples{
## Examples to follow, or will be shown in the openair manual
}
\author{
  David Carslaw
}
\references{
  Wilks, D. S., 2005. Statistical Methods in the
  Atmospheric Sciences, Volume 91, Second Edition
  (International Geophysics), 2nd Edition. Academic Press.
}
\seealso{
  See \code{\link{conditionalQuantile}} for information on
  conditional quantiles, \code{\link{modStats}} for model
  evaluation statistics and the package \code{verification}
  for comprehensive functions for forecast verification.
}
\keyword{methods}

