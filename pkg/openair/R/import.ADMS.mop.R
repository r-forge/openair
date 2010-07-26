import.ADMS.mop <- function(...) { import.adms.mop(...) }

import.adms.mop <- function(file=file.choose()
    , drop.case=TRUE, drop.input.dates=TRUE
    , test.file.structure=TRUE
    , drop.delim=TRUE, add.prefixes = TRUE 
    , simplify.names=TRUE
    , ...)
{

#new function (kr)

#problem 
#mismatch in file header line end with lr; data lines end with comma then lr
#########
#written a catch for this

#problem
#no obvious file structure for testing
###########
#discuss with cerc/david
#meantime added provisional based on delim names

#problem
#r handling of x(y) names and x: names is messy
############
#added tidy to correct for this
#might need to rationalise names

#problem
#file contains lots of same names, input and processed
##############
#added an add.prefixes option to handle this

#problem 
#no keep.units options
##############
#discuss with David and Matthew
#bit tricky given info in file format documentation

######################
#code

#read top line/data headers
check.names <- read.csv(file, header=FALSE, nrow=1, ...)
check.names <- make.names(as.vector(apply(check.names, 1, as.character)))
##tidy () handling; renaming x(y) as x.y. is messy
check.names <- ifelse(
    substr(check.names,nchar(check.names),nchar(check.names))=="."
    , substr(check.names,1,nchar(check.names)-1)
    , check.names
) 
##tidy 1/LMN
check.names <- gsub("X1.LMO", "RECIP.LMO", check.names)

x.1 <- which(check.names=="INPUT_DATA")
x.2 <- which(check.names=="PROCESSED_DATA")

if(test.file.structure){
  #check for delim columns
  if(length(x.1)==0 | length(x.2)==0){
    stop("File not recognised ADMS.mop structure\n       [please contact openair if valid]"
      , call. = FALSE
    )
  }
}

#read in data
ans <- read.csv(file, header=FALSE, skip=1
    , na.strings = c("", "NA", "-999", "-999.0")
    , ...
) 
ans[] <- lapply(ans, function(x) { replace(x, x == -999, NA) })

##check for mismatchs
if(length(ans[,ncol(ans)][!is.na(ans[,ncol(ans)])])==0) {
    ans <- ans[,1:(ncol(ans)-1)]
}
if(ncol(ans)!=length(check.names)){
    warning("Unexpected name/data mismatch, handled pragmatically\n       [compare openair import settings and data structure]"
        , call. = FALSE
    )
}

##restructure names and data according to arguments and put together
if(is.logical(add.prefixes)==TRUE){
    if(add.prefixes==TRUE){
        check.names[(x.2[1]+1): length(check.names)] <- paste("PROCESS", check.names[(x.2[1]+1): length(check.names)], sep=".")
    }
} else {
    if(length(add.prefixes)==1){
        check.names[(x.2[1]+1): length(check.names)] <- paste(add.prefixes[1], check.names[(x.2[1]+1): length(check.names)], sep=".")
    } else {
        if(length(add.prefixes)>1){
            check.names[(x.1[1]+4): (x.2[1]-1)] <- paste(add.prefixes[1], check.names[(x.1[1]+4): (x.2[1]-1)], sep=".")
            check.names[(x.2[1]+1): length(check.names)] <- paste(add.prefixes[2], check.names[(x.2[1]+1): length(check.names)], sep=".")
        } else {
            warning("Unexpected add.prefixes option, option treated as FALSE\n       [check openair import settings]"
                , call. = FALSE)
        }
    }
}
names(ans) <- make.names(check.names, unique=TRUE)

if(simplify.names){
    names(ans) <- simplify.names.adms(names(ans))
}

#drop messy name handling
names(ans) <- gsub("[.][.]", ".", names(ans))
names(ans) <- gsub("^[.]", "", names(ans))

date <- paste(ans$TYEAR, ans$TDAY, ans$THOUR, sep = "-")
date <- as.POSIXct(strptime(date, format = "%Y-%j-%H"), "GMT")
if(drop.input.dates==TRUE){
    ans <- ans[,!names(ans) %in% c("TYEAR", "TDAY", "THOUR")]
}

if(drop.delim==TRUE){
    ans <- ans[,!names(ans) %in% c("PROCESSED_DATA", "INPUT_DATA")]
} 
ans <- cbind(date=date,ans)

if(drop.case==TRUE) {  
    names(ans) <- tolower(names(ans))
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
