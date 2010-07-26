simplify.names.adms <- function(names=NULL){

#simplify.names lookup table for import.adms functions
#v0.1 kr

#handles as inputs (don't use after drop.case option)
#names=NULL returns simplification operation summary

if(is.null(names)) {
    message("Simplification operation summary")
    message("[ADMS => R => OPENAIR]:")
    fun.temp <- function(x,y,z){
        temp <- c(y, make.names(y), z)
        message(paste("\t", paste(temp, collapse=" => "), sep=""))
        temp <- data.frame(cbind(adms.input = temp[1], r.handling = temp[2], simplify.names = temp[3]),
                stringsAsFactors = FALSE)
        x <- rbind(x,temp)
        x 
    }
} else {
    names <- make.names(names)
    fun.temp <- function(x,y,z){
        x[which(x == make.names(y))] <- z
        x
    }
}

############
#update list
############

#1/LMO
    names <- fun.temp(names, "1/LMO", "RECIP.LMO")
#1/MONIN-OBUKHOV LENGTH
    names <- fun.temp(names, "1/MONIN-OBUKHOV LENGTH", "RECIP.LMO")
#ALBEDO(D)
    names <- fun.temp(names, "ALBEDO(D)", "ALBEDO.DISP")
    names <- fun.temp(names, "ALBEDO (D)", "ALBEDO.DISP")
#ALBEDO(DISP)
    names <- fun.temp(names, "ALBEDO(DISP)", "ALBEDO.DISP")
    names <- fun.temp(names, "ALBEDO (DISP)", "ALBEDO.DISP")
#ALBEDO (DISPERSION AREA)
    names <- fun.temp(names, "ALBEDO (DISPERSION AREA)", "ALBEDO.DISP")
#ALBEDO(M)
    names <- fun.temp(names, "ALBEDO(M)", "ALBEDO.MET")
    names <- fun.temp(names, "ALBEDO (M)", "ALBEDO.MET")
#ALBEDO(MET)
    names <- fun.temp(names, "ALBEDO(MET)", "ALBEDO.MET")
    names <- fun.temp(names, "ALBEDO (MET)", "ALBEDO.MET")
#ALBEDO (MET SITE)
    names <- fun.temp(names, "ALBEDO (MET SITE)", "ALBEDO.MET")

#ALPHA
##########
##conflict
##########
##both alpha.disp and alpha.met seem to have been abbrev. to alpha

#ALPHA(D)
    names <- fun.temp(names, "ALPHA(D)", "ALPHA.DISP")
    names <- fun.temp(names, "ALPHA (D)", "ALPHA.DISP")
#ALPHA(DISP)
    names <- fun.temp(names, "ALPHA(DISP)", "ALPHA.DISP")
    names <- fun.temp(names, "ALPHA (DISP)", "ALPHA.DISP")
#ALPHA(M)
    names <- fun.temp(names, "ALPHA(M)", "ALPHA.MET")
    names <- fun.temp(names, "ALPHA (M)", "ALPHA.MET")
#ALPHA(MET)
    names <- fun.temp(names, "ALPHA(MET)", "ALPHA.MET")
    names <- fun.temp(names, "ALPHA (MET)", "ALPHA.MET")
#BL DEPTH
    names <- fun.temp(names, "BL DEPTH", "H")
#BOUNDARY LAYER DEPTH
    names <- fun.temp(names, "BOUNDARY LAYER DEPTH", "H")
#BUOYANCY FREQUENCY ABOVE BOUNDARY LAYER
    names <- fun.temp(names, "BUOYANCY FREQUENCY ABOVE BOUNDARY LAYER", "NU")
#BUTADIENE
#CL
#CLOUD
    names <- fun.temp(names, "CLOUD", "CL")
#CLOUD AMOUNT (OKTAS)
    names <- fun.temp(names, "CLOUD AMOUNT (OKTAS)", "CL")
#D(RELATIVE HUMIDITY)/DZ ABOVE BOUNDARY LAYER (PERCENT/M)
    names <- fun.temp(names, "D(RELATIVE HUMIDITY)/DZ ABOVE BOUNDARY LAYER (PERCENT/M)", "DRHDZU")
#DAY
#DELTAPHI
    names <- fun.temp(names, "DELTAPHI", "DELTA.WD")
#DELTAT
    names <- fun.temp(names, "DELTAT", "DELTA.T")
    names <- fun.temp(names, "DELTA T", "DELTA.T")
#DELTATHETA 
    names <- fun.temp(names, "DELTATHETA", "DELTA.THETA")
    names <- fun.temp(names, "DELTA THETA", "DELTA.THETA")
#DIRN CHANGE
    names <- fun.temp(names, "DIRN CHANGE", "DELTA.WD")
#DRH/DZ
    names <- fun.temp(names, "DRH/DZ", "DRHDZU")
#DRHDZU
#FR
#FREQUENCY
#FTHETA0
#GEOSTROPHIC MINUS SURFACE WIND DIRECTION (DEGREES)
    names <- fun.temp(names, "GEOSTROPHIC MINUS SURFACE WIND DIRECTION (DEGREES)", "DELTA.WD")
#H
#HEAT FLUX
    names <- fun.temp(names, "HEAT FLUX", "FTHETA0")
#HOUR
#HOURS
#INCOMING SOLAR RADIATION
    names <- fun.temp(names, "INCOMING SOLAR RADIATION", "K")
#INPUT_DATA:
#K
#LAMBDAE
#LATENT HEAT FLUX
    names <- fun.temp(names, "LATENT HEAT FLUX", "LAMBDAE")
#LAT HT FLUX
    names <- fun.temp(names, "LAT HT FLUX", "LAMBDAE")
#MODIFIED PRIESTLEY-TAYLOR PARAMETER (DISPERSION AREA)
    names <- fun.temp(names, "MODIFIED PRIESTLEY-TAYLOR PARAMETER (DISPERSION AREA)", "ALPHA.DISP")
#MODIFIED PRIESTLEY-TAYLOR PARAMETER (MET SITE)
    names <- fun.temp(names, "MODIFIED PRIESTLEY-TAYLOR PARAMETER (MET SITE)", "ALPHA.MET")
#MONTHS
#N ABOVE BL
    names <- fun.temp(names, "N ABOVE BL", "NU")
#NO2
#NOx
#NU
#P
#PM10
#PM2.5
#O3
#Q0
#PHI
    names <- fun.temp(names, "PHI", "WD")
#PHI0
    names <- fun.temp(names, "PHI0", "WD.0")
#PHIG
    names <- fun.temp(names, "PHIG", "WD.G")
#PHISEC
    names <- fun.temp(names, "PHISEC", "WD.SEC")
#PRECIP
    names <- fun.temp(names, "PRECIP", "P")
#PRECIPITATION RATE (MM/HOUR)
    names <- fun.temp(names, "PRECIPITATION RATE (MM/HOUR)", "P")
#PROCESSED_DATA:
#R
    names <- fun.temp(names, "R", "ALBEDO.MET")
#RECIPLMO
    names <- fun.temp(names, "RECIPLMO", "RECIP.LMO")
#RELATIVE HUMIDITY ABOVE BOUNDARY LAYER (PERCENT)
    names <- fun.temp(names, "RELATIVE HUMIDITY ABOVE BOUNDARY LAYER (PERCENT)", "RHU")
#RH ABOVE BL
    names <- fun.temp(names, "RH ABOVE BL", "RHU")
#RHU
#RHUM
    names <- fun.temp(names, "RHUM", "RHU")
#ROUGHNESS LENGTH (DISPERSION AREA)
    names <- fun.temp(names, "ROUGHNESS LENGTH (DISPERSION AREA)", "Z0.DISP")
#ROUGHNESS LENGTH (MET SITE)
    names <- fun.temp(names, "ROUGHNESS LENGTH (MET SITE)", "Z0.MET")
#RUN
#S HUMIDITY
   names <- fun.temp(names, "S HUMIDITY", "SHU") 
#SEA SURFACE TEMPERATURE (C)
    names <- fun.temp(names, "SEA SURFACE TEMPERATURE (C)", "TSEA")
#SEA TEMP
    names <- fun.temp(names, "SEA TEMP", "TSEA")
#SENSIBLE HEAT FLUX
    names <- fun.temp(names, "SENSIBLE HEAT FLUX", "FTHETA0")
#SIGMATHETA
   names <- fun.temp(names, "SIGMATHETA", "SIGMA.THETA") 
   names <- fun.temp(names, "SIGMA THETA", "SIGMA.THETA") 
#SIGMA THETA (DEGREES)
   names <- fun.temp(names, "SIGMA THETA (DEGREES)", "SIGMA.THETA") 
#SO2
#SOLAR RAD
   names <- fun.temp(names, "SOLAR RAD", "K") 
#SPECIFIC HUMIDITY
   names <- fun.temp(names, "SPECIFIC HUMIDITY", "SHU") 
#T0C
   names <- fun.temp(names, "T0C", "TEMP") 
#TDAY
#TEMPERATURE
    names <- fun.temp(names, "TEMPERATURE", "TEMP") 
#TEMPERATURE (C)
    names <- fun.temp(names, "TEMPERATURE (C)", "TEMP") 
#TEMPERATURE JUMP ACROSS BOUNDARY LAYER TOP
    names <- fun.temp(names, "TEMPERATURE JUMP ACROSS BOUNDARY LAYER TOP", "DELTA.THETA") 
#THOUR
#TEMPERATURE OVER LAND MINUS SEA SURFACE TEMPERATURE
    names <- fun.temp(names, "TEMPERATURE OVER LAND MINUS SEA SURFACE TEMPERATURE", "DELTA.T")
#TSEA
#TYEAR
#U
    names <- fun.temp(names, "U", "WS")
#UG
    names <- fun.temp(names, "UG", "WS.G")
#UGSTAR
    names <- fun.temp(names, "UGSTAR", "WS.GSTAR")
#USTAR
    names <- fun.temp(names, "USTAR", "WS.STAR")
#WIND DIRN
    names <- fun.temp(names, "WIND DIRN", "WD")
#WIND DIRECTION (DEGREES)
    names <- fun.temp(names, "WIND DIRECTION (DEGREES)", "WD")
#WIND HEIGHT
    names <- fun.temp(names, "WIND HEIGHT", "WIND.HEIGHT")
#WIND MEASUREMENT HEIGHT
    names <- fun.temp(names, "WIND MEASUREMENT HEIGHT", "WIND.HEIGHT")
#WIND SPEED
    names <- fun.temp(names, "WIND SPEED", "WS")
#WSTAR
#YEAR
#Z0(D)
    names <- fun.temp(names, "Z0(D)", "Z0.DISP")
    names <- fun.temp(names, "Z0 (D)", "Z0.DISP")
#Z0(DISP)
    names <- fun.temp(names, "Z0(DISP)", "Z0.DISP")
    names <- fun.temp(names, "Z0 (DISP)", "Z0.DISP")
#Z0(M)
    names <- fun.temp(names, "Z0(M)", "Z0.MET")
    names <- fun.temp(names, "Z0 (M)", "Z0.MET")
#Z0(MET)
    names <- fun.temp(names, "Z0(MET)", "Z0.MET")
    names <- fun.temp(names, "Z0 (MET)", "Z0.MET")

########
#outputs
########

invisible(names)
}
