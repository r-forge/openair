pollutionRose <- function(mydata,
                          pollutant = "nox", key.footer = pollutant,
                          breaks = 6, paddle = FALSE, key.position = "right",
                          ...)
{
    if (is.null(breaks))  breaks <- 6
    if (is.numeric(breaks) & length(breaks) == 1) {
        breaks2 <- co.intervals(mydata[ , pollutant][is.finite(mydata[ ,pollutant])],
                                number = 10, overlap = 0)
        breaks <- pretty(c(min(mydata[ , pollutant], na.rm = TRUE),
                           breaks2[nrow(breaks2), 1]), breaks)
        breaks <- breaks[breaks >= min(mydata[ , pollutant], na.rm = TRUE)]
    }

    windRose(mydata, pollutant = pollutant, paddle = paddle,
             key.position = key.position, key.footer = key.footer,
             breaks = breaks, ...)
}




##' Traditional wind rose plot and pollution rose variation
##'
##' The traditional wind rose plot that plots wind speed and wind direction by
##' different intervals. The pollution rose applies the same plot structure but
##' substitutes other measurements, most commonly a pollutant time series, for
##' wind speed.
##'
##' For \code{windRose} data are summarised by direction, typically by 45 or 30
##' (or 10) degrees and by different wind speed categories. Typically, wind
##' speeds are represented by different width "paddles". The plots show the
##' proportion (here represented as a percentage) of time that the wind is from
##' a certain angle and wind speed range.
##'
##' By default \code{windRose} will plot a windRose in using "paddle" style
##' segments and placing the scale key below the plot.
##'
##' The argument \code{pollutant} uses the same plotting structure but
##' substitutes another data series, defined by \code{pollutant}, for wind
##' speed.
##'
##' The option \code{statistic = "prop.mean"} provides a measure of the
##' relative contribution of each bin to the panel mean, and is intended for
##' use with \code{pollutionRose}.
##'
##' \code{pollutionRose} is a \code{windRose} wrapper which brings
##' \code{pollutant} forward in the argument list, and attempts to sensibly
##' rescale break points based on the \code{pollutant} data range by by-passing
##' \code{ws.int}.
##'
##' By default, \code{pollutionRose} will plot a pollution rose of \code{nox}
##' using "wedge" style segments and placing the scale key to the right of the
##' plot.
##' @usage windRose(mydata, ws.int = 2, angle = 30, type = "default",
##'                      cols = "default", main = "", grid.line = 5, width = 1,
##'                      auto.text = TRUE, breaks = 4, offset = 10,
##'                      paddle = TRUE, key.header = NULL, key.footer = "(m/s)",
##'                      key.position = "bottom", key = TRUE, dig.lab = 5,
##'                      statistic = "prop.count", pollutant = NULL, annotate = TRUE,
##'                      ...)
##'
##'
##'     pollutionRose(mydata, pollutant = "nox", key.footer = pollutant,
##'                          breaks = 6, paddle = FALSE, key.position = "right",
##'                          ...)
##'
##'
##' @aliases windRose pollutionRose
##' @param mydata A data frame containing fields \code{ws} and \code{wd}
##' @param ws.int The Wind speed interval. Default is 2 m/s but for low met
##'   masts with low mean wind speeds a value of 1 or 0.5 m/s may be better.
##'   Note, this argument is superseded in \code{pollutionRose}. See
##'   \code{breaks} below.
##' @param breaks The number of break points produced for wind speed in
##'   \code{windRose} or pollutant in \code{pollutionRose}. For \code{windRose}
##'   and the \code{ws.int} default of 2 m/s, the default, 4, generates the
##'   break points 2, 4, 6, 8 m/s. For \code{pollutionRose}, the default, 6,
##'   attempts to breaks the supplied data at approximately 6 sensible break
##'   points. For example, the argument \code{breaks = c(1, 10, 100)} breaks
##'   the data into segments <1, 1-10, 10-100, >100.
##' @param angle Default angle of "spokes" is 30. Other potentially useful
##'   angles are 45 and 10. Note that the width of the wind speed interval may
##'   need adjusting using \code{width}.
##' @param type \code{type} determines how the data are split i.e. conditioned,
##'   and then plotted. The default is will produce a single plot using the
##'   entire data. Type can be one of the built-in types as detailed in
##'   \code{cutData} e.g. "season", "year", "weekday" and so on. For example,
##'   \code{type = "season"} will produce four plots --- one for each season.
##'
##' It is also possible to choose \code{type} as another variable in the data
##'   frame. If that variable is numeric, then the data will be split into four
##'   quantiles (if possible) and labelled accordingly. If type is an existing
##'   character or factor variable, then those categories/levels will be used
##'   directly. This offers great flexibility for understanding the variation
##'   of different variables and how they depend on one another.
##'
##' Type can be up length two e.g. \code{type = c("season", "weekday")} will
##'   produce a 2x2 plot split by season and day of the week. Note, when two
##'   types are provided the first forms the columns and the second the rows.
##' @param cols Colours to be used for plotting. Options include
##'   \code{default}, \code{increment}, \code{heat}, \code{jet}, \code{hue} and
##'   user defined. For user defined the user can supply a list of colour names
##'   recognised by R (type \code{colours()} to see the full list). An example
##'   would be \code{cols = c("yellow", "green", "blue", "black")}.
##' @param main Title of plot.
##' @param grid.line Grid line interval to use.
##' @param paddle Either \code{TRUE} (default) or \code{FALSE}. If \code{TRUE}
##'   plots rose using `paddle' style spokes. If \code{FALSE} plots rose using
##'   `wedge' style spokes.
##' @param width For \code{paddle = TRUE}, the adjustment factor for width of
##'   wind speed intervals. For example, \code{width = 1.5} will make the
##'   paddle width 1.5 times wider.
##' @param offset The size of the 'hole' in the middle of the plot, expressed
##'   as a percentage of the polar axis scale, default 10.
##' @param auto.text Either \code{TRUE} (default) or \code{FALSE}. If
##'   \code{TRUE} titles and axis labels will automatically try and format
##'   pollutant names and units properly e.g.  by subscripting the `2' in NO2.
##' @param key.header,key.footer Adds additional text/labels above and/or below
##'   the scale key, respectively. For example, passing \code{windRose(mydata,
##'   key.header = "ws")} adds the addition text as a scale header. Note: This
##'   argument is passed to \code{drawOpenKey} via \code{quickText}, applying
##'   the \code{auto.text} argument, to handle formatting.
##' @param key.position Location where the scale key is to plotted.  Allowed
##'   arguments currently include \code{"top"}, \code{"right"}, \code{"bottom"}
##'   and \code{"left"}.
##' @param key Fine control of the scale key via \code{drawOpenKey}. See
##'   \code{drawOpenKey} for further details.
##' @param dig.lab The number of signficant figures at which scientific number
##'   formatting is used in break point and key labelling. Default 5.
##' @param statistic The \code{statistic} to be applied to each data bin in the
##'   plot. Options currently include \code{"prop.count"} and
##'   \code{"prop.mean"}. The default \code{"prop.count"} sizes bins according
##'   to the proportion of the frequency of measurements, in each bin.
##'   Similarly, \code{prop.mean} sizes bins according to their relative
##'   contribution to the mean. In both cases, results are expressed as
##'   percentages of the 'whole-of-panel' \code{statistic} measurement. The
##'   overall value in each panel is shown at the bottom-right.
##' @param pollutant Alternative data series to be sampled instead of wind
##'   speed. The \code{windRose} default NULL is equivalent to \code{pollutant
##'   = "ws"}.
##' @param annotate If \code{TRUE} then the percentage calm and mean values are
##'   printed in each panel.
##' @param ... For \code{pollutionRose} other parameters that are passed on to
##'   \code{windRose}. For \code{windRose} other parameters that are passed on
##'   to \code{drawOpenKey}, \code{lattice:xyplot} and \code{cutData}.
##' @export windRose pollutionRose
##' @return As well as generating the plot itself, \code{windRose} and
##'   \code{pollutionRose} also return an object of class ``openair''. The
##'   object includes three main components: \code{call}, the command used to
##'   generate the plot; \code{data}, the data frame of summarised information
##'   used to make the plot; and \code{plot}, the plot itself. If retained,
##'   e.g. using \code{output <- windRose(mydata)}, this output can be used to
##'   recover the data, reproduce or rework the original plot or undertake
##'   further analysis.
##'
##' An openair output can be manipulated using a number of generic operations,
##'   including \code{print}, \code{plot} and \code{summarise}. See
##'   \code{\link{openair.generics}} for further details.
##'
##' Summarised proportions can also be extracted directly using the
##'   \code{$data} operator, e.g.  \code{object$data} for \code{output <-
##'   windRose(mydata)}. This returns a data frame with three set columns:
##'   \code{cond}, conditioning based on \code{type}; \code{wd}, the wind
##'   direction; and \code{calm}, the \code{statistic} for the proportion of
##'   data unattributed to any specific wind direction because it was collected
##'   under calm conditions; and then several (one for each range binned for
##'   the plot) columns giving proportions of measurements associated with each
##'   \code{ws} or \code{pollutant} range plotted as a discrete panel.
##' @note \code{windRose} and \code{pollutionRose} both use \link{drawOpenKey}
##'   to produce scale keys.
##' @author David Carslaw (with some additional contributions by Karl Ropkins)
##' @seealso See \code{\link{drawOpenKey}} for fine control of the scale key.
##'
##' See \code{\link{polarFreq}} for a more flexible version that considers
##'   other statistics and pollutant concentrations.
##' @keywords methods
##' @examples
##'
##' # load example data from package data(mydata)
##'
##' # basic plot
##' windRose(mydata)
##'
##' # one windRose for each year
##' windRose(mydata,type = "year")
##'
##' # windRose in 10 degree intervals with gridlines and width adjusted
##' windRose(mydata, angle = 10, width = 0.2, grid.line = 1)
##'
##' # pollutionRose of nox
##' pollutionRose(mydata, pollutant = "nox")
##'
##' ## source apportionment plot - contribution to mean
##' \dontrun{
##' pollutionRose(mydata, pollutant = "pm10", type = "year", statistic = "prop.mean")
##' }
##'
##'
windRose <- function (mydata, ws.int = 2, angle = 30, type = "default",
                      cols = "default", main = "", grid.line = 5, width = 1,
                      auto.text = TRUE, breaks = 4, offset = 10,
                      paddle = TRUE, key.header = NULL, key.footer = "(m/s)",
                      key.position = "bottom", key = TRUE, dig.lab = 5,
                      statistic = "prop.count", pollutant = NULL, annotate = TRUE,
                      ...)
{

    ## greyscale handling
    if (length(cols) == 1 && cols == "greyscale") {
        ## strip
        current.strip <- trellis.par.get("strip.background")
        trellis.par.set(list(strip.background = list(col = "white")))
        ## other local colours
        calm.col <- "black"
    } else {
        calm.col <- "forestgreen"
    }


    if (360/angle != round(360/angle)) {
        warning("In windRose(...):\n  angle will produce some spoke overlap",
                "\n  suggest one of: 5, 6, 8, 9, 10, 12, 15, 30, 45, etc.", call. = FALSE)
    }
    if (angle < 3) {
        warning("In windRose(...):\n  angle too small",
                "\n  enforcing 'angle = 3'", call. = FALSE)
        angle <- 3
    }

    allowed.statistics <- c("prop.count", "prop.mean")
    if (!is.character(statistic) || !statistic[1] %in% allowed.statistics) {
        warning("In windRose(...):\n  statistic unrecognised",
                "\n  enforcing statistic = 'prop.count'", call. = FALSE)
        statistic <- "prop.count"
    }

    vars <- c("wd", "ws")
    if (any(type %in%  dateTypes)) vars <- c(vars, "date")

    if (!is.null(pollutant)) {
        vars <- c(vars, pollutant)
    }
    mydata <- checkPrep(mydata, vars, type, remove.calm = FALSE)

    mydata <- na.omit(mydata)

    if (is.null(pollutant))
        pollutant <- "ws"
    mydata$.z.poll <- mydata[, pollutant]

    ## if (type == "ws")  type <- "ws.1"

    mydata$wd <- angle * ceiling(mydata$wd/angle - 0.5)
    mydata$wd[mydata$wd == 0] <- 360

    ## flag calms as negatives
    mydata$wd[mydata$ws == 0] <- -999 ## set wd to flag where there are calms
    ## do after rounding or -999 changes

    if (length(breaks) == 1) breaks <- 0:(breaks - 1) * ws.int

    if (max(breaks) < max(mydata$.z.poll, na.rm = TRUE)) breaks <- c(breaks, max(mydata$.z.poll, na.rm = TRUE))

    if (min(breaks) > min(mydata$.z.poll, na.rm = TRUE)) breaks <- c(min(mydata$.z.poll, na.rm = TRUE), breaks)

    breaks <- unique(breaks)
    mydata$.z.poll <- cut(mydata$.z.poll, breaks = breaks, include.lowest = FALSE,
                          dig.lab = dig.lab)

    theLabels <- gsub("[(]|[)]|[[]|[]]", "", levels(mydata$.z.poll))
    theLabels <- gsub("[,]", "-", theLabels)

######################
    ## statistic handling
#####################

    prepare.grid <- function(mydata) {

        levels(mydata$.z.poll) <- c(paste(".z.poll", 1:length(theLabels),
                                          sep = ""))


        count <- length(mydata$wd)
        calm <- mydata[mydata$wd == -999, ][, pollutant]
        mydata <- mydata[mydata$wd != -999, ]
        mydata <- na.omit(mydata) # needed?

        if(statistic == "prop.count") {
            calm <- length(calm)/count
            weights <- tapply(mydata[, pollutant], list(mydata$wd, mydata$.z.poll),
                              length) / count
        }

        if(statistic == "prop.mean") {
             calm <- sum(calm)

            weights <- tapply(mydata[, pollutant], list(mydata$wd, mydata$.z.poll),
                              sum)
            temp <- sum(sum(weights, na.rm = TRUE), na.rm = TRUE) + calm

            weights <- weights / temp
            calm <- calm / temp

        }

        weights[is.na(weights)] <- 0
        weights <- t(apply(weights, 1, cumsum))

        means <- mean(mydata[ , pollutant])
        weights <- cbind(data.frame(weights), wd = as.numeric(row.names(weights)),
                         calm = calm, means = means)


        weights
    }

    if (paddle) {
        poly <- function(wd, len1, len2, width, colour, x.off = 0,
                         y.off = 0) {
            theta <- wd * pi/180
            len1 <- len1 + off.set
            len2 <- len2 + off.set
            x1 <- len1 * sin(theta) - width * cos(theta) + x.off
            x2 <- len1 * sin(theta) + width * cos(theta) + x.off
            x3 <- len2 * sin(theta) - width * cos(theta) + x.off
            x4 <- len2 * sin(theta) + width * cos(theta) + x.off
            y1 <- len1 * cos(theta) + width * sin(theta) + y.off
            y2 <- len1 * cos(theta) - width * sin(theta) + y.off
            y3 <- len2 * cos(theta) + width * sin(theta) + y.off
            y4 <- len2 * cos(theta) - width * sin(theta) + y.off
            lpolygon(c(x1, x2, x4, x3), c(y1, y2, y4, y3), col = colour,
                     border = NA)
        }
    } else {
        poly <- function(wd, len1, len2, width, colour, x.off = 0,
                         y.off = 0) {
            len1 <- len1 + off.set
            len2 <- len2 + off.set
            theta <- seq((wd - (angle/2) + 1), (wd + (angle/2) -
                                                1), length.out = (angle - 2) * 10)
            theta <- ifelse(theta < 1, 360 - theta, theta)
            theta <- theta * pi/180
            x1 <- len1 * sin(theta) + x.off
            x2 <- rev(len2 * sin(theta) + x.off)
            y1 <- len1 * cos(theta) + x.off
            y2 <- rev(len2 * cos(theta) + x.off)
            lpolygon(c(x1, x2), c(y1, y2), col = colour, border = NA)
        }
    }

    mydata <- cutData(mydata, type, ...)

    results.grid <- ddply(mydata, type, prepare.grid)

    ## proper names of labelling ##############################################################################
    pol.name <- sapply(levels(results.grid[ , type[1]]),
                       function(x) quickText(x, auto.text))
    strip <- strip.custom(factor.levels = pol.name)

    if (length(type) == 1 ) {

        strip.left <- FALSE

    } else { ## two conditioning variables

        pol.name <- sapply(levels(results.grid[ , type[2]]),
                           function(x) quickText(x, auto.text))
        strip.left <- strip.custom(factor.levels = pol.name)
    }
    if (length(type) == 1 & type[1] == "default") strip <- FALSE ## remove strip

###############################################################################

    col <- openColours(cols, length(theLabels))
    max.freq <- max(results.grid[, (length(type) + 1) : (length(theLabels) +
                                                         length(type))], na.rm = TRUE)
    off.set <- max.freq * (offset / 100)
    box.widths <- seq(0.002 ^ 0.25, 0.016 ^ 0.25, length.out = length(theLabels)) ^ 4

    #key, colorkey, legend
    legend <- list(col = col, space = key.position, auto.text = auto.text,
                   labels = theLabels, footer = key.footer, header = key.header,
                   height = 0.60, width = 1.5, fit = "scale",
                   plot.style = if(paddle) "paddle"  else "other")
    legend <- makeOpenKeyLegend(key, legend, "windRose")

    temp <- paste(type, collapse = "+")
    myform <- formula(paste(".z.poll1 ~ wd | ", temp, sep = ""))

    sub.title <- "Frequency of counts by wind direction (%)"
    if (statistic == "prop.mean") sub.title <- "Proportion contribution to the mean (%)"

    plt <- xyplot(myform,
                  xlim = 1.03 * c(-max.freq - off.set, max.freq + off.set),
                  ylim = 1.03 * c(-max.freq - off.set, max.freq + off.set),
                  data = results.grid,
                  type = "n",
                  sub = sub.title,
                  strip = strip,
                  strip.left = strip.left,
                  xlab = "", ylab = "",
                  main = quickText(main, auto.text),
                  as.table = TRUE,
                  aspect = 1,
                  par.strip.text = list(cex = 0.8),
                  scales = list(draw = FALSE),

                  panel = function(x, y, subscripts, ...) {
                      panel.xyplot(x, y, ...)
                      angles <- seq(0, 2 * pi, length = 360)
                      sapply(seq(off.set, 1 + off.set, by = grid.line/100),
                             function(x) llines(x * sin(angles), x * cos(angles),
                                                col = "grey85", lwd = 1))

                      subdata <- results.grid[subscripts, ]
                      for (i in 1:nrow(subdata)) {
                          with(subdata, {
                              for (j in 1:length(theLabels)) {
                                  if (j == 1) {
                                      temp <- "poly(wd[i], 0, .z.poll1[i], width * box.widths[1], col[1])"
                                  }
                                  else {
                                      temp <- paste("poly(wd[i], .z.poll", j -
                                                    1, "[i], .z.poll", j, "[i], width * box.widths[",
                                                    j, "], col[", j, "])", sep = "")
                                  }
                                  eval(parse(text = temp))
                              }
                          })
                      }
                      ltext(seq((grid.line / 100 + off.set), 1 + off.set,
                                grid.line / 100) * sin(pi/4),
                            seq((grid.line/100 +  off.set), 1 + off.set,
                                grid.line / 100) *
                            cos(pi / 4), paste(seq(grid.line, 100, by = grid.line),
                                               "%", sep = ""), cex = 0.7)
                      if (annotate) ltext(max.freq, -max.freq,
                            label = paste("mean = ", sprintf("%.1f", subdata$means[1]),
                            "\ncalm = ", sprintf("%.1f", 100 * subdata$calm[1]),
                            "%", sep = ""), adj = c(1, 0), cex = 0.7, col = calm.col)

                  }, legend = legend, ...)

    ## output ################################################################################

    if (length(type) == 1) plot(plt) else plot(useOuterStrips(plt, strip = strip,
              strip.left = strip.left))

    ## reset if greyscale
    if (length(cols) == 1 && cols == "greyscale")
        trellis.par.set("strip.background", current.strip)

    newdata <- results.grid

    output <- list(plot = plt, data = newdata, call = match.call())
    class(output) <- "openair"
    invisible(output)

}
