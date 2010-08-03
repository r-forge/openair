
polar.percentile <- function(polar,
		pollutant = "",
		type = "ws",
		limits = c(0, 100),
		per = c(50, 95),
		cols = "default",
		auto.smooth = TRUE,
		k = 10,
		main = "",
		auto.text = TRUE,...) {

	#needs access to these packages
	require(mgcv)    #for smoothing surfaces and removing noise
	require(lattice) #basic plotting

	#extract variables of interest

	vars <- c("wd", "date", "ws", pollutant)

	# check data
	polar <- check.prep(polar, vars, "default")

	polar <- na.omit(polar)

	polar$wd[polar$wd == 0] <- 360

	percentile <- seq(0, 100, length = 30) #for percentiles

	wd <- seq(from = 10, to = 360, by = 10) #wind directions from 10 to 360
	ws.wd <- expand.grid(percentile = percentile, wd = wd)
	u <- ws.wd$percentile * sin(pi * ws.wd$wd / 180) #convert to polar coords
	v <- ws.wd$percentile * cos(pi * ws.wd$wd / 180)

	#data to predict over
	input.data <- expand.grid(u = seq(-100, 100, length = 100),
			v = seq(-100, 100, length = 100))

	prepare.grid <- function(polar) {
		#identify which ws and wd bins the data belong
		wd <- cut(polar$wd, breaks = seq(0, 360, 10), include.lowest = TRUE)
		binned <- sapply(split(polar[, pollutant], wd), function(x)
					quantile(x, probs= seq(0, 1, length = 30)^.5, na.rm = TRUE))
		binned <- as.vector(binned)

		######################Smoothing#################################################

		#run GAM to make a smooth surface

		if (auto.smooth == TRUE) {
			Mgam <- gam(binned ^ 0.5 ~ te(u, v))
		} else {
			Mgam <- gam(binned ^ 0.5 ~ s(u, v, k = k))
		}
		pred <- predict.gam(Mgam, input.data)
		pred <- pred ^ 2
		pred
	}

	#############################################################################
	if (type == "ws") {
		#cut data into 8 intervals with same number of points
		polar$cond <- cut(polar$ws, quantile(polar$ws, probs = seq(0, 1, length = 9),
						na.rm = TRUE), include.lowest = TRUE, labels = FALSE)

		ws.levels <- levels(cut(polar$ws, quantile(polar$ws, probs =
										seq(0, 1, length = 9), na.rm = TRUE), include.lowest = TRUE))
	}

	if (type == "year") {
		polar$cond <- cut(polar$date, "year", labels = FALSE)
	}

	if (type == "month") {
		polar$cond <- as.numeric(format(polar$date, "%m"))
	}

	results.grid <- data.frame(u = NULL, v = NULL, z = NULL, cond = NULL)
	polar <- na.omit(polar)

	for (i in unique(polar$cond))
	{
		pred <- prepare.grid(subset(polar, cond == i))
		pred <- cbind(u = input.data$u, v = input.data$v, z = pred, cond = i)
		results.grid <- rbind(results.grid, pred)
	}

	if (type == "ws") {  #better labelling of strips
		results.grid$cond <- as.factor(results.grid$cond)
		ws.levels <- gsub("[[]", "", ws.levels)
		ws.levels <- gsub("[]]", "", ws.levels)
		ws.levels <- gsub("[(]", "", ws.levels)
		ws.levels <- gsub("[)]", "", ws.levels)
		ws.levels <- gsub("[,]", " to ", ws.levels)
		levels(results.grid$cond) = ws.levels
	}

	if (type == "year") {
		results.grid$cond <- as.factor(results.grid$cond)
		levels(results.grid$cond) = unique(format(polar$date, "%Y"))
	}

	if (type == "month") {
		results.grid$cond <- as.factor(results.grid$cond)
		levels(results.grid$cond) = make.month.names()
	}

	#remove points to make a circle
	results.grid$z[(results.grid$u^2 + results.grid$v^2)^.5 > 100] <- NA

	#auto-scaling
	nlev = 200  #preferred number of intervals
	#handle missing breaks arguments
	if(missing(limits))
	{
		breaks = unique(c(0, pretty(results.grid$z^0.5, nlev)))
		br = pretty((results.grid$z), n = 10)
	} else {
		breaks = pretty(limits^0.5, n = nlev)
		br = pretty(limits, n = 10)
	}

	nlev2 = length(breaks)

	col <- open.colours(cols, (nlev2 - 1))

	col.scale <- breaks

	contourplot((z)^.5 ~ u * v | cond, results.grid,
			as.table = TRUE,
			main = quick.text(main, auto.text),
			axes = FALSE,
			col.regions = col, region = TRUE,
			aspect = 1,
			at = col.scale,
			xlab = "", ylab = "",
			scales = list(draw = FALSE),
			colorkey = list(labels = list(at = br^0.5, labels = br)),
			xlim = c(-120, 120), ylim =c(-120, 120),...,

			panel = function(x, y, z,subscripts,...) {
				panel.levelplot(x, y, z, subscripts, at = col.scale,
						col.regions = col)

				panel.contourplot(x, y, z, subscripts,
						at = (quantile(polar[, pollutant], probs = per / 100, na.rm = TRUE))^0.5,
						contour = TRUE, region = FALSE,
						labels = list(labels = as.character(per), cex = 0.6),
						col = "magenta")

				#add axis line to central polar plot
				llines(c(-100, 100), c(0, 0),
						col = "grey20")
				llines(c(0, 0), c(-100, 100),
						col = "grey20")

				lsegments(c(-90, -25, 25, 90),
						rep(-5, 4),
						c(-90, -25, 25, 90),
						rep(5, 4), col = "grey20")
				lsegments(rep(-5, 4),
						c(-90, -25, 25, 90),
						rep(5, 4),
						c(-90, -25, 25, 90), col = "grey20")

				# text for directions
				ltext(-100 - 10, 0, "W")
				ltext(0, -100 - 10, "S")
				ltext(0, 100 + 10, "N")
				ltext(100 + 10, 0, "E")
			})

}

#

#

#

