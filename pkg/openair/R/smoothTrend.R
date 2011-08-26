##' Calculate smoothTrends
##'
##' Use non-parametric methods to calculate time series trends
##'
##' The \code{smoothTrend} function provides a flexible way of estimating the
##' trend in the concentration of a pollutant or other variable. Monthly mean
##' values are calculated from an hourly (or higher resolution) or daily time
##' series. There is the option to deseasonalise the data if there is evidence
##' of a seasonal cycle.
##'
##' \code{smoothTrend} uses a Generalized Additive Model (GAM) from the
##' \code{\link{mgcv}} package to find the most appropriate level of smoothing.
##' The function is particularly suited to situations where trends are not
##' monotonic (see discussion with \code{\link{MannKendall}} for more details
##' on this). The \code{smoothTrend} function is particularly useful as an
##' exploratory technique e.g. to check how linear or non-linear trends are.
##'
##' 95% confidence intervals are shown by shading. Bootstrap estimates of the
##' confidence intervals are also available through the \code{simulate} option.
##' Residual resampling is used.
##'
##' Trends can be considered in a very wide range of ways, controlled by
##' setting \code{type} - see examples below.
##'
##' @param mydata A data frame containing the field \code{date} and at least
##'   one other parameter for which a trend test is required; typically (but
##'   not necessarily) a pollutant.
##' @param pollutant The parameter for which a trend test is required.
##'   Mandatory.
##' @param deseason Should the data be de-deasonalized first? If \code{TRUE}
##'   the function \code{stl} is used (seasonal trend decomposition using
##'   loess). Note that if \code{TRUE} missing data are first linearly
##'   interpolated because \code{stl} cannot handle missing data.
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
##' @param statistic Statistic used for calculating monthly values. Default is
##'   \code{"mean"}, but can also be \code{"percentile"}. See
##'   \code{timeAverage} for more details.
##' @param avg.time Either "month" (the default), or "year". Determines whether
##'   monthly mean or annual mean trends are plotted.
##' @param percentile Percentile value(s) to use if \code{statistic =
##'   "percentile"} is chosen. Can be a vector of numbers e.g. \code{percentile
##'   = c(5, 50, 95)} will plot the 5th, 50th and 95th percentile values
##'   together on the same plot.
##' @param data.thresh The data capture threshold to use (%) when aggregating
##'   the data using \code{avg.time}. A value of zero means that all available
##'   data will be used in a particular period regardless if of the number of
##'   values available. Conversely, a value of 100 will mean that all data will
##'   need to be present for the average to be calculated, else it is recorded
##'   as \code{NA}. Not used if \code{avg.time = "default"}.
##' @param simulate Should simulations be carried out to determine the
##'   Mann-Kendall tau and p-value. The default is \code{FALSE}. If
##'   \code{TRUE}, bootstrap simulations are undertaken, which also account for
##'   autocorrelation.
##' @param n Number of bootstrap simulations if \code{simulate = TRUE}.
##' @param autocor Should autocorrelation be considered in the trend
##'   uncertainty estimates? The default is \code{FALSE}. Generally, accounting
##'   for autocorrelation increases the uncertainty of the trend estimate
##'   sometimes by a large amount.
##' @param cols Colours to use. Can be a vector of colours e.g. \code{cols =
##'   c("black", "green")} or pre-defined openair colours --- see
##'   \code{openColours} for more details.
##' @param ylab y-axis label.
##' @param xlab x-axis label.
##' @param lty Line type to use, can be a vector of types if the option
##'   \code{statistic = "percentile"} is used e.g. \code{lty = c(5, 1, 5)}.
##' @param lwd Line width to use, can be a vector of widths if the option
##'   \code{statistic = "percentile"} is used e.g. \code{lwd = c(1, 2, 1)}.
##' @param pch Plot symbol to use, can be a vector of symbols if the option
##'   \code{statistic = "percentile"} is used e.g. \code{pch = c(1, 2, 1)}. To
##'   remove symbols altogether use \code{pch = NA}.
##' @param cex Plot symbol size, can be a vector of sizes if the option
##'   \code{statistic = "percentile"} is used e.g. \code{cex = c(1, 2, 4)}.
##' @param y.relation This determines how the y-axis scale is plotted. "same"
##'   ensures all panels use the same scale and "free" will use panel-specfic
##'   scales. The latter is a useful setting when plotting data with very
##'   different values.
##' @param key.columns Number of columns used if a key is drawn when using the
##'   option \code{statistic = "percentile"}.
##' @param main Title of plot, if required.
##' @param ci Should confidence intervals be plotted? The default is
##'   \code{FALSE}.
##' @param alpha The alpha transparency of shaded confidence intervals - if
##'   plotted. A value of 0 is fully transparent and 1 is fully opaque.
##' @param date.breaks Number of major x-axis intervals to use. The function
##'   will try and choose a sensible number of dates/times as well as
##'   formatting the date/time appropriately to the range being considered.
##'   This does not always work as desired automatically. The user can
##'   therefore increase or decrease the number of intervals by adjusting the
##'   value of \code{date.breaks} up or down.
##' @param auto.text Either \code{TRUE} (default) or \code{FALSE}. If
##'   \code{TRUE} titles and axis labels will automatically try and format
##'   pollutant names and units properly e.g.  by subscripting the \sQuote{2}
##'   in NO2.
##' @param \dots Other graphical parameters e.g. pch = 16 for filled circles
##'   and to \code{cutData}.  For example, in the case of \code{cutData} the
##'   option \code{hemisphere = "southern"}
##' @export
##' @return As well as generating the plot itself, \code{smoothTrend} also
##'   returns an object of class ``openair''. The object includes three main
##'   components: \code{call}, the command used to generate the plot;
##'   \code{data}, the data frame of summarised information used to make the
##'   plot; and \code{plot}, the plot itself. If retained, e.g. using
##'   \code{output <- smoothTrend(mydata, "nox")}, this output can be used to
##'   recover the data, reproduce or rework the original plot or undertake
##'   further analysis.
##'
##' An openair output can be manipulated using a number of generic operations,
##'   including \code{print}, \code{plot} and \code{summarise}. See
##'   \code{\link{openair.generics}} for further details.
##' @author David Carslaw
##' @seealso \code{\link{MannKendall}} for an alternative method of calculating
##'   trends.
##' @keywords methods
##' @examples
##'
##' # load example data from package
##' data(mydata)
##'
##' # trend plot for nox
##' smoothTrend(mydata, pollutant = "nox")
##'
##' # trend plot by each of 8 wind sectors
##' \dontrun{smoothTrend(mydata, pollutant = "o3", type = "wd", ylab = "o3 (ppb)")}
##'
##' # several pollutants, no plotting symbol
##' \dontrun{smoothTrend(mydata, pollutant = c("no2", "o3", "pm10", "pm25"), pch = NA)}
##'
##' # percentiles
##' \dontrun{smoothTrend(mydata, pollutant = "o3", statistic = "percentile",
##' percentile = 95)}
##'
##' # several percentiles with control over lines used
##' \dontrun{smoothTrend(mydata, pollutant = "o3", statistic = "percentile",
##' percentile = c(5, 50, 95), lwd = c(1, 2, 1), lty = c(5, 1, 5))}
##'
smoothTrend <- function(mydata,
                        pollutant = "nox",
                        deseason = FALSE,
                        type = "default",
                        statistic = "mean",
                        avg.time = "month",
                        percentile = NA,
                        data.thresh = 0,
                        simulate = FALSE,
                        n = 200, #bootstrap simulations
                        autocor = FALSE,
                        cols = "brewer1",
                        ylab = pollutant,
                        xlab = "year",
                        lty = 1,
                        lwd = 1,
                        pch = 1,
                        cex = 0.6,
                        y.relation = "same",
                        key.columns = length(percentile),
                        main = "",
                        ci = TRUE,
                        alpha = 0.2,
                        date.breaks = 7,
                        auto.text = TRUE,...)  {

    ## greyscale handling
    if (length(cols) == 1 && cols == "greyscale") {
        ## strip only
        current.strip <- trellis.par.get("strip.background")
        trellis.par.set(list(strip.background = list(col = "white")))
    }

    vars <- c("date", pollutant)

    mydata <- checkPrep(mydata, vars, type, remove.calm = FALSE)

    if (!missing(percentile)) statistic <- "percentile"

    if (length(pollutant) > 1 & length(percentile) > 1) {
        warning(paste("You cannot choose multiple percentiles and pollutants, using percentile =",
                      percentile[1]))
        percentile <- percentile[1]
    }

    if (!avg.time %in% c("year", "month")) stop("Averaging period must be 'month' or 'year'.")

    ## for overall data and graph plotting
    start.year <- startYear(mydata$date)
    end.year <-  endYear(mydata$date)
    start.month <- startMonth(mydata$date)
    end.month <-  endMonth(mydata$date)

    ## date formatting for plot
    date.at <- dateBreaks(mydata$date, date.breaks)$major
    date.format <- dateBreaks(mydata$date)$format

    ## cutData depending on type
    mydata <- cutData(mydata, type, ...)

    ## reshape data, make sure there is not a variable called 'variable'
    if ("variable" %in% names(mydata)) {
        mydata <- rename(mydata, c(variable = "theVar"))
        type <- "theVar"
    }
    ## in the case of mutiple percentiles, these are assinged and treated like multiple pollutants
    mydata <- melt(mydata, measure.vars = pollutant)

    if (length(percentile) > 1) {

        mydata <- ddply(mydata, c(type, "variable"), calcPercentile, pollutant = "value",
                        avg.time = avg.time, percentile = percentile, data.thresh = data.thresh)

        mydata <- melt(subset(mydata, select = -variable), measure.vars = paste("percentile.",
                                                           percentile, sep = ""))

    } else {
        mydata <- ddply(mydata, c(type, "variable"), timeAverage, avg.time = avg.time,
                        statistic = statistic, percentile = percentile,
                        data.thresh = data.thresh)
    }


    process.cond <- function(mydata) {

        ## return if nothing to analyse
        if (all(is.na(mydata$value))) return()

        ## sometimes data have long trailing NAs, so start and end at
        ## first and last data
        min.idx <- min(which(!is.na(mydata[, "value"])))
        max.idx <- max(which(!is.na(mydata[, "value"])))
        mydata <- mydata[min.idx:max.idx, ]

        ## these subsets may have different dates to overall
        start.year <- startYear(mydata$date)
        end.year <-  endYear(mydata$date)
        start.month <- startMonth(mydata$date)
        end.month <-  endMonth(mydata$date)

        ## can't deseason less than 2 years of data
        if (nrow(mydata) < 24) deseason <- FALSE

        if (deseason) {
            ## interpolate missing data using zoo

            mydata[, "value"] <- na.approx(mydata[, "value"])

            myts <- ts(mydata[, "value"], start = c(start.year, start.month),
                       end = c(end.year, end.month), frequency = 12)

            ssd <- stl(myts, s.window = 35, robust = TRUE, s.degree = 0)

            deseas <- ssd$time.series[, "trend"] + ssd$time.series[, "remainder"]
            deseas <- as.vector(deseas)

            results <- data.frame(date = mydata$date, conc = as.vector(deseas))

        } else {

            results <- data.frame(date = mydata$date, conc = mydata[, "value"])

        }

        results
    }

    split.data <- ddply(mydata, c(type, "variable"),  process.cond)

    skip <- FALSE
    layout <- NULL


    if (length(type) == 1 & type[1] == "wd") {
        ## re-order to make sensible layout
        wds <-  c("NW", "N", "NE", "W", "E", "SW", "S", "SE")
        split.data$wd <- ordered(split.data$wd, levels = wds)

        ## see if wd is actually there or not
        wd.ok <- sapply(wds, function (x) {if (x %in% unique(split.data$wd)) FALSE else TRUE })
        skip <- c(wd.ok[1:4], TRUE, wd.ok[5:8])

        split.data$wd <- factor(split.data$wd)  ## remove empty factor levels

        layout = if (type == "wd") c(3, 3) else NULL
    }

    ## proper names of labelling ##############################################################################
    pol.name <- sapply(levels(factor(split.data[ , type[1]])), function(x) quickText(x, auto.text))
    strip <- strip.custom(factor.levels = pol.name)

    if (length(type) == 1 ) {

        strip.left <- FALSE

    } else { ## two conditioning variables

        pol.name <- sapply(levels(factor(split.data[ , type[2]])), function(x) quickText(x, auto.text))
        strip.left <- strip.custom(factor.levels = pol.name)
    }
    ## ########################################################################################################
    if (length(type) == 1 & type[1] == "default") strip <- FALSE ## remove strip

    ## colours according to number of percentiles
    npol <- max(length(percentile), length(pollutant)) ## number of pollutants

    ## set up colours
    myColors <- if (length(cols) == 1 && cols == "greyscale")
        openColours(cols, npol+1)[-1] else openColours(cols, npol)

    ## information for key
    npol <- unique(split.data$variable)
    key.lab <- sapply(seq_along(npol), function(x) quickText(npol[x], auto.text))

    if (length(npol) > 1) {
        key.columns <- length(npol)
        key <- list(lines = list(col = myColors[1 : length(npol)], lty = lty, lwd = lwd,
                    pch = pch, type = "b", cex = cex),
                    text = list(lab = key.lab),  space = "bottom", columns = key.columns)
        if (missing(ylab)) ylab <-  paste(pollutant, collapse = ", ")

    } else {
        key <- NULL ## either there is a key or there is not
    }

    temp <- paste(type, collapse = "+")
    myform <- formula(paste("conc ~ date| ", temp, sep = ""))

    plt <- xyplot(myform, data = split.data, groups = variable,
                  as.table = TRUE,
                  strip = strip,
                  strip.left = strip.left,
                  layout = layout,
                  key = key,
                  lwd = lwd,
                  lty = lty,
                  pch = pch,
                  cex = cex,
                  skip = skip,
                  par.strip.text = list(cex = 0.8),
                  xlab = quickText(xlab, auto.text),
                  ylab = quickText(ylab, auto.text),
                  main = quickText(main, auto.text),
                  scales = list(x = list(at = date.at, format = date.format),
                  y = list(relation = y.relation, rot = 0)),
                  panel = panel.superpose,
                  ...,

                  panel.groups = function(x, y, group.number, lwd, lty, pch, col, col.line, col.symbol,
                  subscripts, type = "b",...) {


                      if (group.number == 1) {  ## otherwise this is called every time

                          panel.shade(split.data, start.year, end.year, ylim = current.panel.limits()$ylim)
                          panel.grid(-1, 0)


                      }
                      panel.xyplot(x, y, type = "b", lwd = lwd, lty = lty, pch = pch,
                                   col.line = myColors[group.number],
                                   col.symbol = myColors[group.number], ...)

                      panel.gam(x, y, col =  myColors[group.number], col.se =  "black",
                                simulate = simulate, n.sim = n,
                                autocor = autocor, lty = 1, lwd = 1, se = ci, ...)

                  })

#################
    ## output
#################
    if (length(type) == 1) plot(plt) else plot(useOuterStrips(plt, strip = strip, strip.left = strip.left))
    newdata <- split.data
    output <- list(plot = plt, data = newdata, call = match.call())
    class(output) <- "openair"
    ## reset if greyscale
    if (length(cols) == 1 && cols == "greyscale")
        trellis.par.set("strip.background", current.strip)
    invisible(output)

}







