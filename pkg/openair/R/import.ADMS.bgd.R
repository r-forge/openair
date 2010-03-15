import.ADMS.bgd <- function(file=file.choose(), drop.case=TRUE, drop.input.dates=TRUE, keep.units=TRUE
    , ...
){
ans <- readLines(file, n=2)
allowed.formats <- c(
    "BackgroundVersion2"
)
ans.2 <- suppressWarnings(as.numeric(ans[2]))
if( !ans[1] %in% allowed.formats | is.na(ans.2) ) {
    stop("File not recognised ADMS.bgd structure\n       [please contact openair if valid]"
        , call. = FALSE
    )
}
ans <- readLines(file, n= 2*ans.2 + 4)
file.names <- ans[3:(ans.2 + 2)]
if(drop.case) { 
    file.names <- tolower(file.names)
}
ans <- ans[(ans.2+4):(2*ans.2 + 4)]
units <- paste(ans[1], ans[2], sep=" ")

units <- paste(units, paste(ans[3:length(ans)], collapse=", "), sep=", ")
ans <- read.csv(file, header=FALSE, skip=(2*ans.2 + 6)
    , na.strings = c("", "NA", "-999", "-999.0") 
    , ...
)
########################
#screening for missing data
#confirm formats, if they get any with bgd files, etc.
#might not be necessary

date<- paste(ans[,1], ans[,2], ans[,3], sep = "-")
date <- as.POSIXct(strptime(date, format = "%Y-%j-%H"), "GMT")

if(drop.input.dates==TRUE){
    ans <- ans[,4:ncol(ans)]
} else {
    file.names <- c(
        "bgd.year","bgd.day","bgd.hour",
        file.names
    ) 
}
names(ans) <- file.names
ans <- cbind(date=date, ans)
if(keep.units) { 
    comment(ans) <- c(comment(ans), units)
}

#error handling for bad days
ids <- which(is.na(ans$date))
if (length(ids) > 0) {

    if(length(ids)==nrow(ans)) {
        stop("Invalid date (and time) format requested\n       [compare openair import settings and data structure]"
            , call. = FALSE
        )
    }

    ans <- ans[-ids, ]
    reply <- paste("Missing dates detected, removing", length(ids), "line", sep=" ")
    if(length(ids)>1) { reply <- paste(reply,"s",sep="") }
    warning(reply, call. = FALSE)
}

print(unlist(sapply(ans, class)))
ans
}
