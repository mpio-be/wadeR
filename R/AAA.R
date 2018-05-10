

#' @title 		wadeR
#' @description Mapping and field work organizer
#' @docType 	package
#' @name 		wadeR
.onLoad <- function(libname, pkgname){
    dcf <- read.dcf(file=system.file('DESCRIPTION', package=pkgname) )
    packageStartupMessage(paste('This is', pkgname, dcf[, 'Version'] ))
    
    options(wader.host = "127.0.0.1")
    options(wader.db = "REPHatBARROW")
    options(wader.user = 'wader')
    options(wader.freshdata = 20) # days TODO move to validators
    options(wader.dbbackup = '~/ownCloud/BACKUPS/db/')
    
   
    }

