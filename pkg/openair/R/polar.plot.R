
polar.plot <- function(polar,
                       pollutant = "nox",
                       type = "default",
                       resolution = "normal",
                       limits = c(0, 100),
                       exclude.missing = TRUE,
                       cols = "default",
                       min.bin = 1,
                       upper = 10,
                       force.positive = TRUE,
                       k = 100,
                       main = "",
                       auto.text = TRUE,
                       ...) {
    library(plyr)
    ## extract variables of interest
    vars <- c("ws", "wd", "date", pollutant)
    if (type == "site") vars <- c("date", pollutant, "ws", "wd", "site")
    if (type == "temp") vars <- c("date", pollutant, "ws", "wd", "temp")

    polar <- check.prep(polar, vars, type)
    polar <- na.omit(polar)
    ## cut data depending on type
    polar <- cut.data(polar, type)

    ## if upper ws not set, set it to the max to display all information
    max.ws <- ceiling(max(polar$ws, na.rm = TRUE))
    if(missing(upper)) upper <- max.ws

    polar$wd[polar$wd == 0] <- 360

    ## for resolution of grid plotting (default = 101; fine =201)
    if (resolution == "normal") int <- 101
    if (resolution == "fine") int <- 201
    if (resolution == "ultra.fine") int <- 401  ## very large files!

    ## binning wd data properly
    ws <- seq(0, max.ws, length = 30)
    wd <- seq(from = 10, to = 360, by = 10) ## wind directions from 10 to 360
    ws.wd <- expand.grid(ws = ws, wd = wd)

    u <- ws.wd$ws * sin(pi * ws.wd$wd / 180) # #convert to polar coords
    v <- ws.wd$ws * cos(pi * ws.wd$wd / 180)

    ## data to predict over
    input.data <- expand.grid(u = seq(-upper, upper, length = int),
                              v = seq(-upper, upper, length = int))

    prepare.grid <- function(polar) {
        ## identify which ws and wd bins the data belong
        wd <- cut(polar$wd, breaks = seq(0, 360, 10), include.lowest = TRUE)
        ws <- cut(polar$ws, breaks = seq(0, max.ws, length = 31))

        ## this automatically deals with missing data
        binned <- tapply(polar[, pollutant], list(wd, ws), mean, na.rm = TRUE)
        binned <- as.vector(t(binned))

        ## frequency - remove points with freq < min.bin
        bin.len <- tapply(polar[, pollutant], list(ws, wd), length)
        binned.len <- as.vector(bin.len)
        ids <- which(binned.len < min.bin)
        binned[ids] <- NA
######################Smoothing#################################################
        if (force.positive) n <- 0.5 else n <- 1

        Mgam <- gam(binned ^ n ~ s(u, v, k = k))

        pred <- predict.gam(Mgam, input.data)
        pred <- pred ^ (1 / n)

#############################################################################

        results <- data.frame(u = input.data$u, v = input.data$v,
                              z = pred, cond = polar$cond[1])

        if (exclude.missing) {

            ## exclude predictions too far from data (from mgcv)

            x <- seq(-upper, upper, length = int)
            y <- x
            res <- int
            wsp <- rep(x, res)
            wdp <- rep(y, rep(res, res))
            ## remove null data
          #  polar <- na.omit(polar)

           # ind <- with(polar, exclude.too.far(wsp, wdp, ws * sin(pi * wd / 180),
           #                                   ws * cos(pi * wd / 180), dist = 0.05))

            ## data with gaps caused by min.bin
            all.data <- na.omit(data.frame(u, v, binned))
            ind <- with(all.data, exclude.too.far(wsp, wdp, u, v, dist = 0.05))

            results$z[ind] <- NA
            results
        }
    }

#############################################################################
#    results.grid <- split(polar, polar$cond)
#    results.grid <- lapply(results.grid, function(x) prepare.grid(x))
#    results.grid <- do.call(rbind, results.grid)
    results.grid <- ddply(polar, .(cond), prepare.grid)

    ## remove wind speeds > upper to make a circle
    results.grid$z[(results.grid$u ^ 2 + results.grid$v ^ 2) ^ 0.5 > upper] <- NA

    strip <- TRUE
    skip <- FALSE
    if (type == "default") 	strip = FALSE ## remove strip

    ## auto-scaling
    nlev = 200  ## preferred number of intervals

    ## handle missing breaks arguments
    if(missing(limits)) breaks <- pretty(results.grid$z, n = nlev) else breaks <- pretty(limits, n = nlev)

    nlev2 = length(breaks)

    col <- open.colours(cols, (nlev2 - 1))

    col.scale = breaks

    levelplot(z ~ u * v | cond, results.grid, axes = FALSE,
              as.table = TRUE,
              layout = layout,
              strip = strip,
              col.regions = col,
              region = TRUE,
              aspect = 1,
              at = col.scale,
              xlab = "",
              ylab = "",
              main = quick.text(main, auto.text),
              scales = list(draw = FALSE),
              xlim = c(-upper * 1.15, upper * 1.15),
              ylim =c(-upper * 1.15, upper * 1.15),
              ...,

              ## colorkey = list(labels = list(labels=as.character(col.scale),
              ## at=col.scale, cex = 0.7)),
              panel = function(x, y, z,subscripts,...) {
                  panel.levelplot(x, y, z,
                                  subscripts,
                                  at = col.scale,
                                  pretty = TRUE,
                                  col.regions = col,
                                  labels = FALSE)

                  ## add axis line to central polar plot
                  llines(c(-upper, upper), c(0, 0), col = "grey20")
                  llines(c(0, 0), c(-upper, upper), col = "grey20")

                  ## annotate
                  lsegments(seq(-upper, upper), rep(-.2, 2 * upper + 1),
                            seq(-upper, upper), rep(.2, 2 * upper + 1))

                  lsegments(rep(-.2, 2 * upper + 1), seq(-upper, upper),
                            rep(.2, 2 * upper + 1),	seq(-upper, upper))

                  ## larger ticks every 5
                  lsegments(seq(0, upper, by = 5), rep(-0.5, 2 * upper + 1),
                            seq(0 , upper, by = 5), rep(0.5, 2 * upper + 1))

                  lsegments(seq(0, -upper, by = -5), rep(-0.5, 2 * upper + 1),
                            seq(0 , -upper, by = -5), rep(0.5, 2 * upper + 1))

                  lsegments(rep(-0.5, 2 * upper + 1), seq(0, upper, by = 5),
                            rep(0.5, 2 * upper + 1), seq(0, upper, by = 5))

                  lsegments(rep(-0.5, 2 * upper + 1), seq(0, -upper, by = -5),
                            rep(0.5, 2 * upper + 1), seq(0, -upper, by = -5))

                  ltext(-upper * 1.07, 0, "W", cex = 0.7)
                  ltext(0, -upper * 1.07, "S", cex = 0.7)
                  ltext(0, upper * 1.07, "N", cex = 0.7)
                  ltext(upper * 1.07, 0, "E", cex = 0.7)

              })

}

