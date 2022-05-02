

#' @title 		wadeR
#' @description Mapping and field work organizer
#' @docType 	package
#' @name 		wadeR
NULL


.onAttach <- function(libname, pkgname){
    dcf <- read.dcf(file=system.file('DESCRIPTION', package=pkgname) )
    packageStartupMessage(paste('This is', pkgname, dcf[, 'Version'] ))


    options(wader.db        = "FIELD_CHARADRIIatBARROW")
    options(wader.user      = 'wader')
    options(wader.freshdata = 120) # for GPS import

    options(wader.proj = '+proj=omerc +lat_0=71.3332703512554 +lonc=-156.654269449915 +alpha=-41.5 +gamma=0.0 +k=1.000000 +x_0=0.000 +y_0=0.000 +ellps=WGS84 +units=m')
    
    options(xtable.comment = FALSE)

    }

#' @import  utils  methods magrittr stringr  anytime glue xtable
#' @import  data.table DataEntry
#' @import  sp sf rgdal ggplot2 ggthemes ggrepel mapproj foreach RColorBrewer V8
#' @importFrom  stats binomial time
