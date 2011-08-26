##' Taylor Diagram for model evaluation with conditioning
##'
##' Function to draw Taylor Diagrams for model evaluation. The function allows
##' conditioning by any categorical or numeric variables, which makes the
##' function very flexible.
##'
##' The Taylor Diagram is a very useful model evaluation tool. Details of the
##' diagram can be found at
##' \url{http://www-pcmdi.llnl.gov/about/staff/Taylor/CV/Taylor_diagram_primer.pdf}.
##' The diagram provides a way of showing how three complementary model
##' performance statistics vary simultaneously. These statistics are the
##' correlation coefficient R, the standard deviation (sigma) and the (centred)
##' root-mean-square error. These three statistics can be plotted on one (2D)
##' graph because of the way they are related to one another which can be
##' represented through the Law of Cosines.
##'
##' The \code{openair} version of the Taylor Diagram has several enhancements
##' that increase its flexibility. In particular, the straightforward way of
##' producing conditioning plots should prove valuable under many circumstances
##' (using the \code{type} option). Many examples of Taylor Diagrams focus on
##' model-observation comparisons for several models using all the available
##' data. However, more insight can be gained into model performance by
##' partitioning the data in various ways e.g. by season, daylight/nighttime,
##' day of the week, by levels of a numeric variable e.g. wind speed or by
##' land-use type etc.
##'
##' @param mydata A data frame minimally containing a column of observations
##'   and a column of predictions.
##' @param obs A column of observations with which the predictions (\code{mod})
##'   will be compared.
##' @param mod A column of model predictions.
##' @param group The \code{group} column is used to differentiate between
##'   different models and can be a factor or character. The total number of
##'   models compared will be equal to the number of unique values of
##'   \code{group}.
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
##' @param normalise Should the data be normalised by dividing the standard
##'   deviation of the observations? The statistics can be normalised (and
##'   non-dimensionalised) by dividing both the RMS difference and the standard
##'   deviation of the \code{mod} values by the standard deviation of the
##'   observations (\code{obs}). In this case the "observed" point is plotted
##'   on the x-axis at unit distance from the origin. This makes it possible to
##'   plot statistics for different species (maybe with different units) on the
##'   same plot.
##' @param layout Determines how the panels are laid out. By default, plots
##'   will be shown in one column with the number of rows equal to the number
##'   of pollutants, for example. If the user requires 2 columns and two rows,
##'   layout should be set to \code{layout = c(2, 2)}. In general, layout is
##'   expressed as number of columns times number of rows.
##' @param cols Colours to be used for plotting. Options include "default",
##'   "increment", "heat", "spectral", "hue", "brewer1", "greyscale" and user
##'   defined (see \code{openColours} for more details). The same line colour
##'   can be set for all pollutant e.g. \code{cols = "black"}.
##' @param main The plot title; default is no title.
##' @param ylab Name of y-axis variable. By default will use the name of
##'   \code{y}.
##' @param xlab Name of x-axis variable. By default will use the name of
##'   \code{x}.
##' @param pch The symbol type used for plotting. Default is to provide
##'   different symbol types for different pollutant. If one requires a single
##'   symbol for all pollutants, the set \code{pch = 1}, for example.
##' @param cex Size of symbol used.
##' @param rms.col Colour for centred-RMS lines and text.
##' @param cor.col Colour for correlation coefficient lines and text.
##' @param key Should the key be shown?
##' @param key.title Title for the key.
##' @param key.columns Number of columns to be used in the key. With many
##'   pollutants a single column can make to key too wide. The user can thus
##'   choose to use several columns by setting \code{columns} to be less than
##'   the number of pollutants.
##' @param key.pos Position of the key e.g. "top", "bottom", "left" and
##'   "right". See details in \code{lattice:xyplot} for more details about
##'   finer control.
##' @param strip Should a strip be shown?
##' @param auto.text Either \code{TRUE} (default) or \code{FALSE}. If
##'   \code{TRUE} titles and axis labels will automatically try and format
##'   pollutant names and units properly e.g.  by subscripting the `2' in NO2.
##' @param \dots Other graphical parameters passed onto \code{lattice:xyplot}
##'   and \code{cutData}. For example, in the case of \code{cutData} the option
##'   \code{hemisphere = "southern"}.
##' @export
##' @return As well as generating the plot itself, \code{TaylorDiagram} also
##'   returns an object of class ``openair''. The object includes three main
##'   components: \code{call}, the command used to generate the plot;
##'   \code{data}, the data frame of summarised information used to make the
##'   plot; and \code{plot}, the plot itself. If retained, e.g. using
##'   \code{output <- TaylorDiagram(thedata, obs = "nox", mod = "mod")}, this
##'   output can be used to recover the data, reproduce or rework the original
##'   plot or undertake further analysis. For example, \code{output$data} will
##'   be a data frame consisting of the group, type, correlation coefficient
##'   (R), the standard deviation of the observations and measurements.
##'
##' An openair output can be manipulated using a number of generic operations,
##'   including \code{print}, \code{plot} and \code{summary}. See
##'   \code{\link{openair.generics}} for further details.
##' @author David Carslaw
##' @seealso \code{taylor.diagram} from the \code{plotrix} package from which
##'   some of the annotation code was used.
##' @references
##'
##' Taylor, K.E.: Summarizing multiple aspects of model performance in a single
##'   diagram. J.  Geophys. Res., 106, 7183-7192, 2001 (also see PCMDI Report
##'   55, \url{http://wwwpcmdi.  llnl.gov/publications/ab55.html})
##'
##' IPCC, 2001: Climate Change 2001: The Scientific Basis, Contribution of
##'   Working Group I to the Third Assessment Report of the Intergovernmental
##'   Panel on Climate Change [Houghton, J.T., Y. Ding, D.J. Griggs, M. Noguer,
##'   P.J. van der Linden, X. Dai, K. Maskell, and C.A.  Johnson (eds.)].
##'   Cambridge University Press, Cambridge, United Kingdom and New York, NY,
##'   USA, 881 pp. (see
##'   \url{http://www.grida.no/climate/ipcc_tar/wg1/317.htm#fig84})
##' @keywords methods
##' @examples
##'
##' # load openair data if not loaded already
##' data(mydata)
##'
##' ## first make some dummy data based on year 2000 and call the column 'mod'
##' testdat <- selectByDate(mydata, year = 2000)
##' testdat$mod = testdat$nox + 200 * rnorm(1:nrow(testdat))
##'
##' ## basic plot
##' TaylorDiagram(testdat, obs = "nox", mod = "mod")
##'
##' ## don't have actual model data, but can demonstrate a case with
##' ## multiple models.  The code below makes a new column 'month', which
##' ## can be thought of as representing different models. Note also it is
##' ## useful for considering the seasonal performance of a single
##' ## model. Note we choose to normalise the data.
##'
##' testdat <- cutData(testdat, type = "month")
##' TaylorDiagram(testdat, obs = "nox", mod = "mod", group = "month",
##' normalise = TRUE)
##'
TaylorDiagram <- function(mydata,
                          obs = "obs",
                          mod = "mod",
                          group = NULL,
                          type = "default",
                          normalise = FALSE,
                          layout = NULL,
                          cols = "brewer1",
                          main = "",
                          ylab = NULL,
                          xlab = NULL,
                          pch = 20,
                          cex = 2,
                          rms.col = "darkgoldenrod",
                          cor.col = "black",
                          key = TRUE,
                          key.title = group,
                          key.columns = 1,
                          key.pos = "bottom",
                          strip = TRUE,
                          auto.text = TRUE, ...)   {


    ## greyscale handling
    if (length(cols) == 1 && cols == "greyscale") {
        ## strip
        current.strip <- trellis.par.get("strip.background")
        trellis.par.set(list(strip.background = list(col = "white")))
        ## other local colours
        method.col <- "greyscale"
    } else {
        method.col <- "default"
    }


################################################################################################
    if (any(type %in%  openair:::dateTypes)) {

        vars <- c("date", obs, mod)

    } else {

        vars <- c(obs, mod)
    }

    ## if group is present, need to add that list of variables unless it is a pre-defined date-based one
    if (!missing(group)){

        if (group %in%  openair:::dateTypes | any(type %in% openair:::dateTypes)) {
            if (group %in%  openair:::dateTypes) {
                vars <- unique(c(vars, "date")) ## don't need group because it is defined by date
            } else {
                vars <- unique(c(vars, "date", group))
            }

        } else {

            vars <- unique(c(vars, group))
        }
    }

    if (!missing(group)) if (group %in% type) stop ("Can't have 'group' also in 'type'.")

    ## data checks
    mydata <- openair:::checkPrep(mydata, vars, type)

    ## remove missing data
    mydata <- na.omit(mydata)

    mydata <- cutData(mydata, type, ...)

    if (missing(group)) {

        if ((!"group" %in% type) & (!"group" %in% c(obs, mod))) {
            mydata$group <- factor("group")
            group <- "group"
        }
        ## don't overwrite a
    } else {  ## means that group is there
        mydata <- cutData(mydata, group, ...)
    }

    legend <- NULL

    npol <- length(levels(mydata[ , group]))

    ## function to calculate stats for TD
    calcStats <- function(mydata) {
        R <- cor(mydata[[obs]], mydata[[mod]], use = "pairwise")
        sd.obs <- sd(mydata[[obs]])
        sd.mod <- sd(mydata[[mod]])
        if (normalise) {
            sd.mod <- sd.mod / sd.obs
            sd.obs <- 1
        }

        res <- data.frame(R, sd.obs, sd.mod)
        res
    }

    results <- ddply(mydata, c(group, type), calcStats)

    ## if no group to plot, then add a dummy one to make xyplot work
    if (is.null(group)) {results$MyGroupVar <- factor("MyGroupVar"); group <-  "MyGroupVar"}

    ## set up colours
    myColors <- openColours(cols, npol)

    ## basic function for lattice call + defaults
    temp <- paste(type, collapse = "+")

    myform <- formula(paste("R ~ sd.mod", "|", temp, sep = ""))

    scales <- list(x = list(rot = 0), y = list(rot = 0))

    pol.name <- sapply(levels(mydata[ , group]), function(x) quickText(x, auto.text))


    if (missing(key.columns)) if (npol < 5) key.columns <- npol else key.columns <- 4

    if (key & npol > 1) {

        key <- list(points = list(col = myColors[1:npol]), pch = pch, cex = cex,
                    text = list(lab = pol.name, cex = 0.8), space = key.pos,
                    columns = key.columns,
                    title = quickText(key.title, auto.text),
                    cex.title = 0.8, lines.title = 3)

    } else {

        key <- NULL
    }

    ## special wd layout
    skip <- FALSE
    if (length(type) == 1 & type[1] == "wd" ) {
        ## re-order to make sensible layout
        wds <-  c("NW", "N", "NE", "W", "E", "SW", "S", "SE")
        mydata$wd <- ordered(mydata$wd, levels = wds)

        ## see if wd is actually there or not
        wd.ok <- sapply(wds, function (x) {if (x %in% unique(mydata$wd)) FALSE else TRUE })
        skip <- c(wd.ok[1:4], TRUE, wd.ok[5:8])

        mydata$wd <- factor(mydata$wd)  ## remove empty factor levels

        layout = if (type == "wd") c(3, 3) else NULL
    }

    ## proper names of labelling ##############################################################################

    stripName <- sapply(levels(mydata[ , type[1]]), function(x) quickText(x, auto.text))
    if (strip) strip <- strip.custom(factor.levels = stripName)

    if (length(type) == 1 ) {

        strip.left <- FALSE

    } else { ## two conditioning variables
        stripName <- sapply(levels(mydata[ , type[2]]), function(x) quickText(x, auto.text))
        strip.left <- strip.custom(factor.levels =  stripName)
    }
    ## ########################################################################################################


    ## no strip needed for single panel
    if (length(type) == 1 & type[1]  == "default") strip <- FALSE

    ## not sure how to evaluate "group" in xyplot, so change to a fixed name
    id <- which(names(results) == group)
    names(results)[id] <- "MyGroupVar"

    maxsd <- 1.2 * max(results$sd.obs, results$sd.mod)

    if (missing(ylab)) {
        if (normalise) ylab <- "standard deviation (normalised)" else ylab <- "standard deviation"
    }

    if (missing(xlab)) xlab <- ylab

    plt <- xyplot(myform,  data = results, groups = MyGroupVar,
                  xlim = 1.12 * c(0, maxsd),
                  ylim = 1.12 * c(0, maxsd),
                  aspect = 1,
                  type = "n",
                  as.table = TRUE,
                  pch = pch,
                  cex = cex,
                  main = quickText(main, auto.text),
                  ylab = quickText(ylab, auto.text),
                  xlab = quickText(xlab, auto.text),
                  scales = scales,
                  key = key,
                  par.strip.text = list(cex = 0.8),
                  strip = strip,
                  strip.left = strip.left,
                  layout = layout,
                  skip = skip,
                  panel =  panel.superpose,...,
                  panel.groups = function(x, y, col.symbol, col, type, col.line, lty, lwd,
                  group.number,

                  subscripts,...)
              {

                  ## draw the diagram
                  if (group.number == 1) {
                      xcurve <- cos(seq(0, pi / 2, by = 0.01)) * maxsd
                      ycurve <- sin(seq(0, pi / 2, by = 0.01)) * maxsd
                      llines(xcurve, ycurve, col = "black")

                      xcurve <- cos(seq(0, pi / 2, by = 0.01)) * results$sd.obs[subscripts]
                      ycurve <- sin(seq(0, pi / 2, by = 0.01)) * results$sd.obs[subscripts]
                      llines(xcurve, ycurve, col = "black", lty = 5)

                      corr.lines = c(0.2, 0.4, 0.6, 0.8, 0.9)

                      ## grid line with alpha transparency
                      theCol <- t(col2rgb(cor.col)) / 255

                      for (gcl in corr.lines) llines(c(0, maxsd * gcl), c(0, maxsd * sqrt(1 - gcl ^ 2)),
                                                     col = rgb(theCol, alpha = 0.4), alpha = 0.5)

                      bigtick <- acos(seq(0.1, 0.9, by = 0.1))
                      medtick <- acos(seq(0.05, 0.95, by = 0.1))
                      smltick <- acos(seq(0.91, 0.99, by = 0.01))

                      lsegments(cos(bigtick) * maxsd, sin(bigtick) *
                                maxsd, cos(bigtick) * 0.96 * maxsd, sin(bigtick) * 0.96 * maxsd,
                                col = cor.col)

                      lsegments(cos(medtick) * maxsd, sin(medtick) *
                                maxsd, cos(medtick) * 0.98 * maxsd, sin(medtick) * 0.98 * maxsd,
                                col = cor.col)
                      lsegments(cos(smltick) * maxsd, sin(smltick) *
                                maxsd, cos(smltick) * 0.99 * maxsd, sin(smltick) * 0.99 * maxsd,
                                col = cor.col)

                      ## arcs for standard deviations (3 by default)
                      gamma <- pretty(c(0, maxsd), n = 5)
                      if (gamma[length(gamma)] > maxsd)
                          gamma <- gamma[-length(gamma)]
                      labelpos <- seq(45, 70, length.out = length(gamma))

                      ## from plotrix
                      for (gindex in 1:length(gamma)) {
                          xcurve <- cos(seq(0, pi, by = 0.03)) * gamma[gindex] +
                              results$sd.obs[subscripts]
                          endcurve <- which(xcurve < 0)
                          endcurve <- ifelse(length(endcurve), min(endcurve) - 1, 105)
                          ycurve <- sin(seq(0, pi, by = 0.03)) * gamma[gindex]
                          maxcurve <- xcurve * xcurve + ycurve * ycurve
                          startcurve <- which(maxcurve > maxsd * maxsd)
                          startcurve <- ifelse(length(startcurve), max(startcurve) + 1, 0)

                          llines(xcurve[startcurve : endcurve], ycurve[startcurve : endcurve],
                                 col = rms.col, lty = 5)

                          ltext(xcurve[labelpos[gindex]], ycurve[labelpos[gindex]],
                                 gamma[gindex], cex = 0.7, col = rms.col, pos = 1,
                                srt = 0, font = 2)

                          ltext(1.1 * maxsd, 1.05 * maxsd, "centred\nRMS error", cex = 0.7,
                                col = rms.col, pos = 2)
                      }

                      ## angles for R key
                      angles <- 180 * c(bigtick, acos(c(0.95, 0.99))) / pi

                      ltext(cos(c(bigtick, acos(c(0.95, 0.99)))) *
                            1.06 * maxsd, sin(c(bigtick, acos(c(0.95, 0.99)))) *
                            1.06 * maxsd, c(seq(0.1, 0.9, by = 0.1), 0.95, 0.99), cex = 0.7,
                            adj = 0.5, srt = angles, col = cor.col)

                      ltext(0.82 * maxsd, 0.82 * maxsd, "correlation", srt = 315, cex = 0.7,
                            col = cor.col)


                      ## measured point and text
                      lpoints(results$sd.obs[subscripts], 0, pch = 20, col = "purple", cex = 1.5)
                      ltext(results$sd.obs[subscripts], 0, "observed", col = "purple", cex = 0.7, pos = 3)

                  }

                  results <- transform(results, x = sd.mod * R, y = sd.mod * sin(acos(R)))

                  lpoints(results$x[subscripts], results$y[subscripts],
                          col.symbol = myColors[group.number], ...)



              })



    if (length(type) == 1) plot(plt) else plot(useOuterStrips(plt, strip = strip, strip.left = strip.left))
    newdata <- results
    output <- list(plot = plt, data = newdata, call = match.call())
    class(output) <- "openair"

                                        ## reset if greyscale
    if (length(cols) == 1 && cols == "greyscale")
        trellis.par.set("strip.background", current.strip)

    invisible(output)

}







