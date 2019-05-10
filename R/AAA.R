

#' @title 		wadeR
#' @description Mapping and field work organizer
#' @docType 	package
#' @name 		wadeR
NULL


.onAttach <- function(libname, pkgname){
    dcf <- read.dcf(file=system.file('DESCRIPTION', package=pkgname) )
    packageStartupMessage(paste('This is', pkgname, dcf[, 'Version'] ))


    options(wader.db        = "REPHatBARROW")
    options(wader.user      = 'wader')
    options(wader.freshdata = 60) # for GPS import
    options(wader.dbbackup  = path.expand('~/ownCloud/BACKUPS/db/') )



    }

#' @import  utils  methods magrittr stringr  anytime glue
#' @import  rgdal ggplot2 ggthemes ggrepel mapproj lubridate foreach RColorBrewer V8 

NULL
