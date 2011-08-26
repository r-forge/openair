##' corrgram plot with conditioning
##'
##' Function to to draw and visualise correlation matrices using lattice. The
##' primary purpose is as a tool for exploratory data analysis. Hierarchical
##' clustering is used to group similar variables.
##'
##' The \code{corPlot} function plots correlation matrices. The implementation
##' relies heavily on that shown in Sarkar (2007), with a few extensions.
##'
##' Correlation matrices are a very effective way of understating relationships
##' between many variables. The \code{corPlot} shows the correlation coded in
##' three ways: by shape (ellipses), colour and the numeric value. The ellipses
##' can be thought of as visual representations of scatter plot. With a perfect
##' positive correlation a line at 45 degrees positive slope is drawn. For zero
##' correlation the shape becomes a circle. See examples below.
##'
##' With many different variables it can be difficult to see relationships
##' between variables i.e. which variables tend to behave most like one
##' another. For this reason hierarchical clustering is applied to the
##' correlation matrices to group variables that are most similar to one
##' another (if \code{cluster = TRUE}.)
##'
##' It is also possible to use the \code{openair} type option to condition the
##' data in many flexible ways, although this may become difficult to visualise
##' with too many panels.
##'
##' @param mydata A data frame which should consist of some numeric columns.
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

##' @param cluster Should the data be ordered according to cluster analysis. If
##'   \code{TRUE} hierarchical clustering is applied to the correlation
##'   matrices using \code{hclust} to group similar variables together. With
##'   many variables clustering can greatly assist interpretation.
##' @param cols Colours to be used for plotting. Options include "default",
##'   "increment", "heat", "spectral", "hue", "brewer1", "greyscale" and user
##'   defined (see \code{openColours} for more details).
##' @param r.thresh Values of greater than \code{r.thresh} will be shown in
##'   bold type. This helps to highlight high correlations.
##' @param text.col The colour of the text used to show the correlation values.
##'   The first value controls the colour of negative correlations and the
##'   second positive.
##' @param main The plot title; default is no title.
##' @param auto.text Either \code{TRUE} (default) or \code{FALSE}. If
##'   \code{TRUE} titles and axis labels will automatically try and format
##'   pollutant names and units properly e.g.  by subscripting the `2' in NO2.
##' @export
##' @author David Carslaw --- but mostly based on code contained in Sarkar
##'   (2007)
##' @seealso \code{taylor.diagram} from the \code{plotrix} package from which
##'   some of the annotation code was used.
##' @references Sarkar, D. (2007). Lattice Multivariate Data Visualization with
##'   R. New York: Springer.
##'
##' Friendly, M. (2002). Corrgrams : Exploratory displays for correlation
##'   matrices. American Statistician, 2002(4), 1-16. doi:10.1198/000313002533
##' @keywords methods
##' @examples
##'
##' # load openair data if not loaded already
##' data(mydata)
##' ## basic corrgram plot
##' corPlot(mydata)
##' ## plot by season ... and so on
##' corPlot(mydata, type = "season")
##' \dontrun{
##' ## a more interesting are hydrocarbon measurements
##' hc <- importAURN(site = "my1", year = 2005, hc = TRUE)
##' ## now it is possible to see the hydrocarbons that behave most
##' ## similarly to one another
##' corPlot(hc)
##' }
##'
corPlot <- function(mydata, type = "default", cluster = TRUE, cols = "default", r.thresh = 0.8,
                         text.col = c("black", "black"),  main = "", auto.text = TRUE) {

    if (length(type) > 1) stop ("Only one 'type' allowed in this function.")

    ## make sure date is present for types requiring it
    if (any(type %in% openair:::dateTypes)) {
        if (!"date" %in% names(mydata)) stop ("Need a field 'date'")
    }

    ## remove variables where all are NA
    mydata <- mydata[ , sapply(mydata, function(x) !all(is.na(x)))]

    ## cut data depending on type
    mydata <- cutData(mydata, type)

    ## proper names of labelling
    pol.name <- sapply(names(mydata[, sapply(mydata, is.numeric)]),
                       function(x) quickText(x, auto.text))

    ## number of pollutants
    npol <- length(pol.name)


    prepare.cond <- function(mydata) {
        ## calculate the correlations
        thedata <- suppressWarnings(cor(mydata[, sapply(mydata, is.numeric)],
                                        use = "pairwise.complete.obs" ))

        ## remove columns/rows where all are NA
        therows <- apply(thedata, 1, function(x) !all(is.na(x)))
        thecols <- apply(thedata, 2, function(x) !all(is.na(x)))
        thedata <- thedata[therows, thecols]

        ## maybe reduced number of pollutants, hence select only those present
        thepols <-  pol.name[thecols]

        if (cluster) {
            ord.dat <- order.dendrogram(as.dendrogram(hclust(dist(thedata))))

        } else {
            ord.dat <- 1:ncol(thedata)
        }

        npol <- length(ord.dat)
        grid <- expand.grid(x= 1:npol, y = 1:npol)

        thepols <- thepols[ord.dat]

        thedata <- thedata[ord.dat, ord.dat]
        thedata <- as.vector(thedata)

        thedata <- cbind(grid, z = thedata, type = mydata[1, type])
        thedata <- list(thedata = thedata, pol.name = thepols)
        thedata

    }

    results.grid <- dlply(mydata, type, prepare.cond)

    ## list of labels
    labels <-  llply(results.grid, function(x) x$pol.name)
    results.grid <- do.call(rbind, llply(results.grid, function(x) x$thedata))

    div.col <- function (x) openColours(cols, x)

    ## labelleing of strips
    pol.name <- sapply(levels(results.grid[ , "type"]), function(x) quickText(x, auto.text))
    strip <- strip.custom(factor.levels = pol.name)
    if (type == "default") strip <- FALSE

    levelplot(z ~ x * y | type , data = results.grid,
              at = do.breaks(c(-1.01, 1.01), 100),
              xlab = NULL, ylab = NULL,
              as.table = TRUE,
              strip = strip,
              aspect = 1,
              main = quickText(main, auto.text),
              colorkey = FALSE,
              col.regions = div.col,
              par.strip.text = list(cex = 0.8),
              scales = list(x = list(rot = 90, labels = labels, at = 1 : npol),
              y = list(labels = labels, at = 1 : npol), relation = "free"),
              panel = panel.corrgram,  text.col = text.col, r.thresh = r.thresh, label = TRUE)

}

panel.corrgram <- function(x, y, z, subscripts, at, level = 0.9, text.col, r.thresh = r.thres,
                           label = FALSE, ...) {
    require("ellipse", quietly = TRUE)
    x <- as.numeric(x)[subscripts]
    y <- as.numeric(y)[subscripts]
    z <- as.numeric(z)[subscripts]

    zcol <- level.colors(z, at = at, ...)
    for (i in seq(along = z)) {
        ell <- ellipse(z[i], level = level, npoints = 50, scale = c(.2, .2),
                       centre = c(x[i], y[i]))
        panel.polygon(ell, col = zcol[i], border = zcol[i],...)

    }
    if (label)
        panel.text(x = x, y = y, lab = 100 * round(z, 2),
                   cex = 0.8, col = ifelse(z < 0, text.col[1], text.col[2]),
                   font = ifelse(z < r.thresh, 1, 2))
}

