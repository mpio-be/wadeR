

#' @title 		wader
#' @description Mapping and field work organizer
#' @docType 	package
#' @name 		wader
.onLoad <- function(libname, pkgname){
    dcf <- read.dcf(file=system.file('DESCRIPTION', package=pkgname) )
    packageStartupMessage(paste('This is', pkgname, dcf[, 'Version'] ))
    # options(wader.host = sdb::probeDB() )
    options(wader.user = 'wader')
    options(wader.freshdata = 60) # days
    options(wader.dbbackup = '~/ownCloud/BACKUPS/db/') # days
    
    }

