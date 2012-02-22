##' Calculate clusters for back tracectories
##'
##' This function carries out cluster analysis of HYSPLIT back
##' trajectories. The function is specifically designed to work with
##' the trajectories imported using the \code{openair}
##' \code{importTraj} function, which provides pre-calculated back
##' trajectories at specific receptor locations.
##'
##' Two main methods are available to cluster the back trajectories
##' using two different calculations of the distance matrix. The
##' default is to use the standard Euclidian distance between each
##' pair of trajectories. Also available is an angle-based distance
##' matrix based on Sirois and Bottenheim (1995). The latter method is
##' useful when the interest is the direction of the trajectories in
##' clustering.
##'
##' The distance matrix calculations are made in C++ for speed. For
##' data sets of up to 1 year both methods should be relatively fast,
##' although the \code{method = "Angle"} does tend to take much longer
##' to calculate. Further details of these methods are given in the
##' openair manual.
##' @param traj An openair trajectory data frame resulting from the
##' use of \code{importTraj}.
##' @param method Method used to calculate the distance matrix for the
##' back trajectories. There are two methods available: "Euclid" and
##' "Angle".
##' @param n.cluster Number of clusters to calculate.
##' @param plot Should a plot be produced?
##' @param type \code{type} determines how the data are split
##' i.e. conditioned, and then plotted. The default is will produce a
##' single plot using the entire data. Type can be one of the built-in
##' types as detailed in \code{cutData} e.g. "season", "year",
##' "weekday" and so on. For example, \code{type = "season"} will
##' produce four plots --- one for each season. Note that the cluster
##' calculations are separately made of each level of "type".
##' @param cols Colours to be used for plotting. Options include
##' "default", "increment", "heat", "jet" and \code{RColorBrewer}
##' colours --- see the \code{openair} \code{openColours} function for
##' more details. For user defined the user can supply a list of
##' colour names recognised by R (type \code{colours()} to see the
##' full list). An example would be \code{cols = c("yellow", "green",
##' "blue")}.
##' @param split.after For \code{type} other than "default"
##' e.g. season, the trajectories can either be calculated for each
##' level of \code{type} independently or extracted after the cluster
##' calculations have been applied to the whole data set.
##' @param ... Other graphical parameters passed onto
##' \code{lattice:levelplot} and \code{cutData}. Similarly, common
##' axis and title labelling options (such as \code{xlab},
##' \code{ylab}, \code{main}) are passed to \code{levelplot} via
##' \code{quickText} to handle routine formatting.
##' @export
##' @useDynLib openair
##' @import cluster
##' @return Returns original data frame with a new (factor) variable
##' \code{cluster} giving the calculated cluster.
##' @seealso \code{\link{importTraj}}, \code{\link{trajPlot}}, \code{\link{trajLevel}}
##' @author David Carslaw
##' @references
##'
##' Sirois, A. and Bottenheim, J.W., 1995. Use of backward
##' trajectories to interpret the 5-year record of PAN and O3 ambient
##' air concentrations at Kejimkujik National Park, Nova
##' Scotia. Journal of Geophysical Research, 100: 2867-2881.
##' @keywords methods
##' @examples
##' \dontrun{
##' ## import trajectories
##' traj <- importTraj(site = "london", year = 2009)
##' ## calculate clusters
##' traj <- trajCluster(traj, n.clusters = 5)
##' head(traj) ## note new variable 'cluster'
##' ## use different distance matrix calculation, and calculate by season
##' traj <- trajCluster(traj, method = "Angle", type = "season", n.clusters = 4)
##' }
trajCluster <- function(traj, method = "Euclid", n.cluster = 5, plot = TRUE, type = "default",
                        cols = "Set1", split.after = FALSE, ...) {

    if (tolower(method) == "euclid")  method <- "distEuclid" else method <- "distAngle"


    extra.args <- list(...)

    ## label controls
    extra.args$plot.type <- if ("plot.type" %in% names(extra.args))
        extra.args$plot.type else extra.args$plot.type <- "l"
    extra.args$lwd <- if ("lwd" %in% names(extra.args))
       extra.args$lwd else extra.args$lwd <- 4



    calcTraj <- function(traj) {

        ## make sure ordered correctly
        traj <- traj[order(traj$date, traj$hour.inc), ]

        ## length of back trajectories
        traj$len <- ave(traj$lat, traj$date, FUN = length)

        ## 96-hour back trajectories with origin: length should be 97
        traj <- subset(traj, len == 97)
        len <- nrow(traj) / 97

        ## lat/lon input matrices
        x <- matrix(traj$lon, nrow = 97)
        y <- matrix(traj$lat, nrow = 97)

        z <- matrix(0, nrow = 97, ncol = len)
        res <- matrix(0, nrow = len, ncol = len)

        res <- .Call(method, x, y, res)

        res[is.na(res)] <- 0 ## possible for some to be NA if trajectory does not move between two hours?


        dist.res <- as.dist(res)
        clusters <- pam(dist.res, n.cluster)
        cluster <- rep(clusters$clustering, each = 97)
        traj$cluster <- factor(cluster)
        traj

    }

    ## this bit decides whether to separately calculate trajectories for each level of type

    if (split.after) {
        traj <- ddply(traj, "default", calcTraj)
        traj <- cutData(traj, type)
    } else {
        traj <- cutData(traj, type)
        traj <- ddply(traj, type, calcTraj)
    }

    if (plot) {
        ## calculate the mean trajectories by cluster
        agg <- aggregate(traj[, c("lat", "lon", "date")], traj[, c("cluster", "hour.inc", type)] ,
                         mean, na.rm = TRUE)

        ## make sure date is in correct format
        class(agg$date) = class(traj$date)
        attr(agg$date, "tzone") <- "GMT"

        plot.args <- list(agg, x = "lon", y ="lat", group = "cluster",
                    col = cols, type = type, map = TRUE)

         ## reset for extra.args
        plot.args <- openair:::listUpdate(plot.args, extra.args)

        ## plot
        plt <- do.call(scatterPlot, plot.args)

    }

    invisible(traj)

}

