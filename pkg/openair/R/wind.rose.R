wind.rose <- function(polar,
                      ws.int = 2,
                      angle = 30,
                      type = "default",
                      cols = "default",
                      main = "",
                      grid.line = 5,
                      width = 1,
                      units = "(m/s)",
                      auto.text = TRUE,...) {
    ##library(lattice)
    ##library(reshape) # for rbind.fill

    vars <- c("ws", "wd", "date")

    polar <- check.prep(polar, vars, type, remove.calm = FALSE)
    
    polar <- na.omit(polar)
    
    polar$wd <- angle * round(polar$wd / angle)
    polar$wd[polar$wd == 0] <- 360  

    ## split into four categories, depending on the interval, but check max first
    breaks <- ws.int * 0:3

    if (max(breaks) < max(polar$ws, na.rm = TRUE)) {
        breaks <- c(breaks, max(polar$ws, na.rm = TRUE))
    } else {
        breaks <- c(breaks, 4 * ws.int)
    }
    
   
    polar$ws <- cut(polar$ws, breaks = breaks, include.lowest = FALSE)
    theLabels <- gsub("[(]|[)]|[[]|[]]", "", levels(polar$ws))
    theLabels <- gsub("[,]", "-", theLabels)
    
    
    prepare.grid <- function(polar) {
        wd <- factor(polar$wd)
        
        ## easy labels to refer to
        levels(polar$ws) <- c("ws1", "ws2", "ws3", "ws4")

        calm <- length(which(is.na(polar$ws))) / nrow(polar)
        ## put in calms to ensure all are counted
        polar$ws[which(is.na(polar$ws))] <- "ws1"
            
        weights <- prop.table(table(polar$wd, polar$ws))    ## fraction by ws/wd
        weights <- as.data.frame.matrix(weights)
        ## get cumsum for plotting
        weights <- data.frame(t(apply(weights, 1, cumsum)))
        
        weights$cond <- polar$cond[1]
        weights$wd <- as.numeric(row.names(weights))
        weights <- subset(weights, wd > 0)
        weights$calm <- calm
        weights
    }

    poly <- function(wd, len1, len2, width, colour, x.off = 0, y.off = 0)
    {
        theta <- wd * pi / 180
        offset = 0.02
        len1 <- len1 + offset
        len2 <- len2 + offset
        x1 <- len1 * sin(theta) - width * cos(theta) + x.off
        x2 <- len1 * sin(theta) + width * cos(theta) + x.off
        x3 <- len2 * sin(theta) - width * cos(theta) + x.off
        x4 <- len2 * sin(theta) + width * cos(theta) + x.off

        y1 <- len1 * cos(theta) + width * sin(theta) + y.off
        y2 <- len1 * cos(theta) - width * sin(theta) + y.off
        y3 <- len2 * cos(theta) + width * sin(theta) + y.off
        y4 <- len2 * cos(theta) - width * sin(theta) + y.off

        lpolygon(c(x1, x2, x4, x3), c(y1, y2, y4, y3), col = colour, border = NA)
    }

    ## cut data according to type, then run calculations on each level
    polar <- cut.data(polar, type)
    results.grid <- ddply(polar, .(cond), prepare.grid)

    ## the colours
    col <- open.colours(cols, 4)

    max.freq <- max(results.grid[, 1:4], na.rm = TRUE)

    plt <- xyplot(ws1 ~ wd | cond,
                  xlim = c(-max.freq - 0.02, max.freq + 0.02),
                  ylim = c(-max.freq - 0.02, max.freq + 0.02),
                  data = results.grid,
                  type = "n",
                  xlab = "",
                  ylab = "",
                  main = quick.text(main, auto.text),
                  as.table = TRUE,
                  aspect = 1,
                  scales = list(draw = FALSE),#...,

                  panel = function(x, y, subscripts,...) {
                      panel.xyplot(x, y,...)

                      ## annotate
                      angles <- seq(0, 2 * pi, length = 360)

                      sapply(seq(0.02, 1.02, by = grid.line / 100),
                             function(x) llines(x * sin(angles), x * cos(angles),
                                                col = "grey85", lwd = 1))

                      subdata <- results.grid[subscripts,]

                      for (i in 1:nrow(subdata)) {
                          with(subdata, {
                              poly(wd[i], 0, ws1[i], width * 0.002, col[1])
                              poly(wd[i], ws1[i], ws2[i], width * 0.004, col[2])
                              poly(wd[i], ws2[i], ws3[i], width * 0.008, col[3])
                              poly(wd[i], ws3[i], ws4[i], width * 0.016, col[4])})
                      }

                      ltext(seq((grid.line / 100 + 0.02), 1.02,  grid.line / 100) * sin(pi / 4),
                            seq((grid.line / 100 + 0.02), 1.02, grid.line / 100) * cos(pi / 4),
                            seq(grid.line, 100, by = grid.line), cex = 0.7)

                      ## add calm
                      ltext(max.freq, - max.freq, label = paste("calm = ",  sprintf("%.1f", 100 *
                                                  subdata$calm[1]), "%", sep = ""),
                            adj = c(1, 0), cex = 0.7, col = "forestgreen")

                  })
    ## the scale - must be neater way of doing this

    print(plt, position = c(0, 0.05, 1, 1))

    y1 <- 0.07
    int <- 0.002
    x1 <- c(0.3, 0.3, 0.4, 0.4)

    add.ws.scale <- function(x) {
        grid.polygon(x1 + (x - 1) / 10, c(y1 - x * int, y1 + x * int, y1 + x * int, y1 - x * int),
                     gp = gpar(fill = col[x], col = col[x]))

        grid.text(theLabels[x], (0.35 + (x - 1) / 10), 0.02, just = "bottom", gp = gpar(cex = 0.8))
    }

    sapply(1:4, add.ws.scale)

    grid.text(quick.text(units), 0.75, 0.02, just = "bottom", gp = gpar(cex = 0.8))
    invisible(results.grid)
}



