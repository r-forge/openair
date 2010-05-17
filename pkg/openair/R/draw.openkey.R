draw.openkey <- function (key, draw = FALSE, vp = NULL) 
{
#modification of draw.colorkey in lattice
#and a lots of thanks owed to Deepayan Sarkar 

    if (!is.list(key)) 
        stop("key must be a list")
    if (is.null(key$labels)) 
        stop("key list must contain labels")
    if (is.null(key$plot.style)){ 
        warning("In draw.openkey(...) key does not define plot.type\n  assuming 'paddle'",
            call. = FALSE)
        key$plot.style <- "paddle"    
    }
    if (is.null(key$auto.text)){ 
        warning("In draw.openkey(...) key does not define auto.text\n  assuming 'TRUE'",
            call. = FALSE)
        key$auto.text <- TRUE    
    }
    if (key$height < 0.25){ 
        warning("In draw.openkey(...) key does allow heights smaller than 0.25\n  forcing to 0.2",
            call. = FALSE)
        key$height <- 0.25    
    }
    if (key$height > 1){ 
        warning("In draw.openkey(...) key does allow heights > 1\n  forcing to 1",
            call. = FALSE)
        key$height <- 1    
    }

    process.key <- function(col = regions$col, alpha = regions$alpha, 
        tick.number = 7, width = 2, height = 1, space = key$space, 
        ...) {
        regions <- trellis.par.get("regions")
        list(col = col, alpha = alpha, tick.number = tick.number, 
            width = width, height = height, space = space, ...)
    }
    axis.line <- trellis.par.get("axis.line")
    axis.text <- trellis.par.get("axis.text")
    key <- do.call("process.key", key)
    check.overlap <- TRUE    
    key$at <- 0:length(key$labels)
    at <- key$at[1:(length(key$at) - 1)] + 0.5
    col <- axis.text$col 
    labels <- key$labels
    atrange <- range(key$at, finite = TRUE)
    scat <- as.numeric(key$at)
    reccentre <- (scat[-1] + scat[-length(scat)])/2
    #recdim <- diff(scat)
    recht <- rep(1, length(labels))
    if(key$plot.style == "paddle"){
        recwd <- seq(0.2, 0.8, length.out = length(recht))
    } else {
        recwd <- rep(0.8, length(key$labels))
    }
    #cex <- axis.text$cex
    cex <- 0.8
    #col <- axis.text$col
    font <- axis.text$font
    fontfamily <- axis.text$fontfamily
    fontface <- axis.text$fontface
    rot <- 0
    if(is.null(key$key.name)) key$key.name <- ""
    if(is.null(key$units)) key$units <- ""
    
    if (key$space == "right") {
        if (key$key.name != ""){
            key.name <- quick.text(key$key.name, key$auto.text)
            units <- quick.text(key$units, key$auto.text) 
        } else { 
            key.name <- quick.text(key$units, key$auto.text)
            units <- " "
        }
        labelsGrob <- textGrob(label = labels, x = rep(0, length(at)), 
            y = at, vp = viewport(yscale = atrange), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == -90) 
                c("center", "bottom")
            else c("left", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        SacGrob <- textGrob(label = c(key.name, units, labels), x = rep(0, length(at) + 2), 
            y = at, vp = viewport(yscale = atrange), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == -90) 
                c("center", "bottom")
            else c("left", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        keyGrob <- textGrob(label = key.name, x = c(0), 
            y = c(0.5), vp = viewport(yscale = c(0,1)), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == -90) 
                c("center", "bottom")
            else c("left", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        keyGrob2 <- textGrob(label = units, x = c(0), 
            y = c(0.5), vp = viewport(yscale = c(0,1)), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == -90) 
                c("center", "bottom")
            else c("left", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        heights.x <- c((1 - key$height)/2, key$height * 0.05, key$height * 0.9, 
            key$height * 0.05, key$height * 0.05, key$height * 0.05,  
            (1 - key$height)/2)
        heights.units <- rep("null", 7)
        widths.x <- c(0.6 * key$width, 0.3, 1)
        widths.units <- c("lines", "lines", "grobwidth")
        widths.data <- list(NULL, NULL, SacGrob)
        key.layout <- grid.layout(nrow = 7, ncol = 3, heights = unit(heights.x, 
            heights.units), widths = unit(widths.x, widths.units, 
            data = widths.data), respect = TRUE)
        key.gf <- frameGrob(layout = key.layout, vp = vp)
        key.gf <- placeGrob(key.gf, keyGrob, row = 5, col = 3)
        key.gf <- placeGrob(key.gf, keyGrob2, row = 6, col = 3)
        key.gf <- placeGrob(key.gf, rectGrob(x = rep(0.5, length(reccentre)), 
            y = reccentre, default.units = "native", vp = viewport(yscale = atrange), 
            height = recht, width = recwd, gp = gpar(fill = key$col, col = "transparent", 
                alpha = key$alpha)), row = 3, col = 1)
        key.gf <- placeGrob(key.gf, labelsGrob, row = 3, col = 3)
    }

    else if (key$space == "left") {
       if (key$key.name != ""){
            key.name <- quick.text(key$key.name, key$auto.text)
            units <- quick.text(key$units, key$auto.text) 
        } else { 
            key.name <- quick.text(key$units, key$auto.text)
            units <- " "
        }
        labelsGrob <- textGrob(label = labels, x = rep(1, length(at)), 
            y = at, vp = viewport(yscale = atrange), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == 90) 
                c("center", "bottom")
            else c("right", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        SacGrob <- textGrob(label = c(key.name, units, labels), x = rep(1, length(at) + 2), 
            y = at, vp = viewport(yscale = atrange), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == 90) 
                c("center", "bottom")
            else c("right", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        keyGrob <- textGrob(label = key.name, x = c(1), 
            y = c(0.5), vp = viewport(yscale =c(0,1)), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == 90) 
                c("center", "bottom")
            else c("right", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        keyGrob2 <- textGrob(label = units, x = c(1), 
            y = c(0.5), vp = viewport(yscale =c(0,1)), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == 90) 
                c("center", "bottom")
            else c("right", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        heights.x <- c((1 - key$height)/2, key$height * 0.05, key$height * 0.9, 
            key$height * 0.05, key$height * 0.05, key$height * 0.05,  
            (1 - key$height)/2)
        heights.units <- rep("null", 7)
        widths.x <- c(1, 0.3, 0.6 * key$width)
        widths.units <- c("grobwidth", "lines", "lines")
        widths.data <- list(SacGrob, NULL, NULL)
        key.layout <- grid.layout(nrow = 7, ncol = 3, heights = unit(heights.x, 
            heights.units), widths = unit(widths.x, widths.units, 
            data = widths.data), respect = TRUE)
        key.gf <- frameGrob(layout = key.layout, vp = vp)
        key.gf <- placeGrob(key.gf, keyGrob, row = 5, col = 1)
        key.gf <- placeGrob(key.gf, keyGrob2, row = 6, col = 1)
        key.gf <- placeGrob(key.gf, rectGrob(x = rep(0.5, length(reccentre)), 
            y = reccentre, default.units = "native", vp = viewport(yscale = atrange), 
            height = recht, width = recwd, gp = gpar(fill = key$col, col = "transparent", 
                alpha = key$alpha)), row = 3, col = 3)
        key.gf <- placeGrob(key.gf, labelsGrob, row = 3, col = 1)
    }
    else if (key$space == "top") {
        temp <- 1
        if (key$key.name != ""){
            if (key$units != ""){
                key.name <- paste(key$key.name, key$units, sep="  ")
                key.name <- quick.text(key.name, key$auto.text)
            } else {
                key.name <- quick.text(key$key.name, key$auto.text)
            }
        } else {
            if (key$units != ""){
                key.name <- quick.text(key$units, key$auto.text)
            } else {
                key.name <- " "
                temp <- 0.1
            }
        }
        labelsGrob <- textGrob(label = labels, y = rep(0, length(at)), 
            x = at, vp = viewport(xscale = atrange), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == 0) 
                c("center", "bottom")
            else c("left", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        keyGrob <- textGrob(label = key.name, y = c(0), 
            x = c(0.5), vp = viewport(xscale = c(0,1)), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == 0) 
                c("center", "bottom")
            else c("left", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        widths.x <- c((1 - key$height)/2, key$height * 0.1, key$height * 0.9,
            key$height * 0.1, (1 - key$height)/2)
        widths.units <- rep("null", 5)
        heights.x <- c(temp, 2, 0.3, 0.6 * key$width)
        heights.units <- c("grobheight", "grobheight", "lines", "lines")
        heights.data <- list(keyGrob, labelsGrob, NULL, NULL)
        key.layout <- grid.layout(nrow = 4, ncol = 5, heights = unit(heights.x, 
            heights.units, data = heights.data), widths = unit(widths.x, 
            widths.units), respect = TRUE)
        key.gf <- frameGrob(layout = key.layout, vp = vp)
        key.gf <- placeGrob(key.gf, rectGrob(y = rep(0.5, length(reccentre)), 
            x = reccentre, default.units = "native", vp = viewport(xscale = atrange), 
            width = recht, height = recwd, gp = gpar(fill = key$col, col = "transparent", 
                alpha = key$alpha)), row = 4, col = 3)
        key.gf <- placeGrob(key.gf, labelsGrob, row = 2, col = 3)
        key.gf <- placeGrob(key.gf, keyGrob, row = 1, col = 3)
    }
    else if (key$space == "bottom") {
        temp <- 2
        if (key$key.name != ""){
            if (key$units != ""){
                key.name <- paste(key$key.name, key$units, sep="  ")
                key.name <- quick.text(key.name, key$auto.text)
            } else {
                key.name <- quick.text(key$key.name, key$auto.text)
            }
        } else {
            if (key$units != ""){
                key.name <- quick.text(key$units, key$auto.text)
            } else {
                key.name <- " "
                temp <- 0.1
            }
        }
        labelsGrob <- textGrob(label = labels, y = rep(0, length(at)), 
            x = at, vp = viewport(xscale = atrange), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == 0) 
                c("center", "bottom")
            else c("left", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        keyGrob <- textGrob(label = key.name, y = c(0), 
            x = c(0.5), vp = viewport(xscale = c(0,1)), default.units = "native", 
            check.overlap = check.overlap, just = if (rot == 0) 
                c("center", "bottom")
            else c("left", "center"), rot = rot, gp = gpar(col = col, 
                cex = cex, fontfamily = fontfamily, fontface = lattice:::chooseFace(fontface, 
                  font)))
        widths.x <- c((1 - key$height)/2, key$height * 0.1, key$height * 0.9,
            key$height * 0.1, (1 - key$height)/2)
        widths.units <- rep("null", 5)
        heights.x <- c(0.6 * key$width, 0.3, 1, temp)
        heights.units <- c("lines", "lines", "grobheight", "grobheight")
        heights.data <- list(NULL, NULL, labelsGrob, keyGrob)
        key.layout <- grid.layout(nrow = 4, ncol = 5, heights = unit(heights.x, 
            heights.units, data = heights.data), widths = unit(widths.x, 
            widths.units), respect = TRUE)
        key.gf <- frameGrob(layout = key.layout, vp = vp)
        key.gf <- placeGrob(key.gf, rectGrob(y = rep(0.5, length(reccentre)), 
            x = reccentre, default.units = "native", vp = viewport(xscale = atrange), 
            width = recht, height = recwd, gp = gpar(fill = key$col, col = "transparent", 
                alpha = key$alpha)), row = 1, col = 3)
        key.gf <- placeGrob(key.gf, labelsGrob, row = 3, col = 3)
        key.gf <- placeGrob(key.gf, keyGrob, row = 4, col = 3)
    }
    if (draw) 
        grid.draw(key.gf)
    key.gf
}
