

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
    options(wader.freshdata = 120) # for GPS import
    options(wader.dbbackup  = path.expand('~/ownCloud/BACKUPS/db/') )
    options(wader.species   = c("REPH",  "LBDO", "PESA" , "SESA", "AMGP", "BASA", "DUNL", "RNPH") )

    options(xtable.comment = FALSE)

    }

#' @import  utils  methods magrittr stringr  anytime glue xtable
#' @import  data.table DataEntry
#' @import  sp rgdal ggplot2 ggthemes ggrepel mapproj foreach RColorBrewer V8 
#' @importFrom  stats binomial time

NULL
# no visible global function definitions
utils::globalVariables(
c(
'.',
'.N',
':=',
'Altitude',
'Battery.voltage',
'Device.ID',
'HTML',
'IN',
'LL',
'LR',
'Latitude.decimal',
'Longitude.decimal',
'MSR',
'Speed',
'Timestamp',
'a1',
'a2',
'arrival_datetime',
'author',
'b1',
'b2',
'binomial',
'c2',
'clutch',
'coords.x1',
'coords.x2',
'copy',
'ctime',
'data.table',
'datetime_',
'datetime_found',
'dbConnect',
'dbDisconnect',
'dbExecute',
'dbGetQuery',
'dbWriteTable',
'div',
'done',
'dtime',
'dupl',
'ele',
'f',
'f_sure',
'filenam',
'float_angle',
'float_height',
'fn',
'fread',
'gps_id',
'gps_point',
'group',
'hatch_date',
'hatch_date_dir',
'i',
'iniClutch',
'lab',
'lastCheck',
'lastSeen',
'last_update',
'lastd',
'lat',
'lay_date',
'll',
'lon',
'm_sure',
'map_layers',
'msr_state',
'name',
'nest',
'nest_state',
'p',
'pk',
'rbindlist',
'seenDaysAgo',
'setcolorder',
'setnames',
'setorder',
'sex',
'species',
'textInput',
'time',
'tmpid',
'toastr_error',
'toastr_success',
'toastr_warning',
'track_seg_id',
'track_seg_point_id'
))