import.ADMS <- function(file=file.choose(), ...) { import.adms(...) }

import.adms <- function(file=file.choose(), file.type="unknown", ...){

if(file.type=="unknown"){
  file.type <- tolower(substr(file, nchar(file)-3, nchar(file)))
  if(substr(file.type,1,1)=="."){
    file.type <- substr(file.type,2,4)
  } else {
    stop("File extension not recognised\n       [If valid ADMS file, try setting file.type to one of: bgd, mop or met]", 
                call. = FALSE) 
  }
}

if(file.type=="bgd") { return(import.adms.bgd(file=file, ...)) }
if(file.type=="mop") { return(import.adms.mop(file=file, ...)) }
if(file.type=="met") { return(import.adms.met(file=file, ...)) }

stop("File extension not recognised\n       [If valid ADMS file, try setting file.type to one of: bgd, mop or met]", 
  call. = FALSE) 
}
