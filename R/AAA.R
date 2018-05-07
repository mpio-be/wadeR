

#' @title 		wadeR
#' @description Mapping and field work organizer
#' @docType 	package
#' @name 		wadeR
.onLoad <- function(libname, pkgname){
    dcf <- read.dcf(file=system.file('DESCRIPTION', package=pkgname) )
    packageStartupMessage(paste('This is', pkgname, dcf[, 'Version'] ))
    
    options(wader.host = "scidb.mpio.orn.mpg.de")
    options(wader.db = "REPHatBARROW")
    options(wader.user = 'wader')
    options(wader.freshdata = 60) # days
    options(wader.dbbackup = '~/ownCloud/BACKUPS/db/')


    
    }

