#' read_gpsID
#' @export
#' @examples
#' read_gpsID(x ='/media/mihai/GARMIN/Garmin/startup.txt')
#' read_gpsID(x =  character(0))
read_gpsID <- function(x) {

    if(length(x) == 0) { 
        err = 'I cannot find a startup.txt, did you select the wrong location?'
        Err(err); stop(err)
         }

    o = readLines(x)
    o = o[str_detect(toupper(o), 'GPS')]

    if(length(o) == 0) { 
        err = 'I cannot find the gps number. The startup.txt on your GPS is not set properly'
        Err(err); stop(err)
        }



    str_split(o, pattern = '=', simplify = TRUE)[2] %>% as.integer

   }

#' read_waypoints
#' @export
#' @examples
#' read_waypoints(x ='/media/mihai/GARMIN/Garmin/GPX/Waypoints_18-APR-17.gpx')
read_waypoints <- function(x) {
    nl =  suppressWarnings(ogrFIDs(dsn = x, layer="waypoints"))
    if(length(nl) > 0) {
        o = readOGR(dsn = x, layer="waypoints", verbose = FALSE) %>% 
            data.frame %>%
            data.table %>%
            .[, .(name, time, coords.x2, coords.x1, ele)]
        o[, name := as.integer(name)]
        setnames(o, c('gps_point', 'datetime_', 'lat', 'lon', 'ele')  )
      
        o[, datetime_ := gpxPOSIXct(datetime_) ]
        o = o[!is.na(gps_point)]

     } else 
        o = data.table(gps_point = 1,datetime_ = as.POSIXct(NA),lat = 1,lon = 1, ele= 1)[-1]

    o    
    }

#' read_tracks
#' @export
#' @examples
#' read_tracks(x = '/media/mihai/GARMIN/Garmin/GPX/Current/Current.gpx')
read_tracks <- function(x) {
    nl =  suppressWarnings(ogrFIDs(dsn = x, layer="track_points"))
    if(length(nl) > 0) {
        o = readOGR(dsn = x, layer="track_points", verbose = FALSE) %>% 
            data.frame %>%
            data.table %>%
            .[, .(track_seg_id,track_seg_point_id, time, coords.x2, coords.x1, ele)]

        setnames(o, c('seg_id', 'seg_point_id', 'datetime_', 'lat', 'lon', 'ele')  )
      
        o[, datetime_ := gpxPOSIXct(datetime_) ]

     } else 
        o = data.table(seg_id = 1, seg_point_id =1,datetime_ = as.POSIXct(NA),lat = 1,lon = 1, ele= 1)[-1]
    o    
   }


#' upload_gps
#' @export
#' @examples
#' p = list.files('/media/mihai/GARMIN/Garmin', pattern = '.gpx$', full.names = TRUE, recursive = TRUE)
#' upload_gps(p)
upload_gps <- function(p, gps_id) {

    Msg( "Please wait for the pop-ups to appear and then safely remove your GPS." )


    con =  dbConnect(RMySQL::MySQL(), host = ip(), user = getOption('wader.user'), 
        db = yy2dbnam(data.table::year(Sys.Date() )), password = wadeR::pwd()  )
    on.exit(  dbDisconnect (con)  )




    wp = foreach(i = p, .errorhandling= 'pass') %do% {
        read_waypoints(i)
        }

    Msg('If there is an Archive directory on your GPS then the GPS is archiving tracks. It is OK to remove the content of the Archive directory (this will save time when downloading your GPS)')


    tr = foreach(i = p, .errorhandling= 'pass') %do% {
        read_tracks(i)
        }

    # find errors
    errwp = sapply(wp, FUN = inherits, what = 'error')
    errtr = sapply(tr, FUN = inherits, what = 'error')
    err = union(p[errwp], p[errtr])

    # keep good data
    wp = wp[which(!errwp)] %>% rbindlist
    tr = tr[which(!errtr)] %>% rbindlist

    # Err msg
    if(length(err) >0 )
        Err(paste('I cannot read', length(err), 'files(s)', 
            'If you downloaded your GPS daily this is not necessarily an issue.') )


    lastwp = idbq( paste('SELECT max(datetime_) x FROM GPS_POINTS WHERE gps_id =', gps_id))$x %>% as.POSIXct
    lasttr = idbq( paste('SELECT max(datetime_) x FROM GPS_TRACKS WHERE gps_id =', gps_id))$x %>% as.POSIXct

    if(!is.na(lastwp))  wp = wp[datetime_ > lastwp]
    if(!is.na(lasttr))  tr = tr[datetime_ > lasttr]

    # fresh data check
    if (wp[ , any(as.Date(datetime_) + getOption('wader.freshdata') < Sys.Date()) ] )
        stop( Wrn( paste('Slightly mouldy data (older than', getOption('wader.freshdata'), 'days). 
                    To be on the safe side I will not import those data.') ) )


    if(nrow(wp) > 0) {
        wp[, gps_id := gps_id]
        wp[, pk := NA]
        setcolorder(wp, c('gps_id','gps_point','datetime_','lat','lon','ele','pk'))

        w = dbWriteTable(con, 'GPS_POINTS', wp, row.names = FALSE, append = TRUE)
        if(!w) Wrn('I could not download the gps waypoints data. Something funny is happening, most likely the connection to the db is broken. ')

        # feedback
        fieldhours = wp[, difftime(max(datetime_), min(datetime_), units = 'hours') %>% round(., 2) ]
        Msg(  paste('You saved', nrow(wp), 'waypoints collected during', fieldhours, 'hours.') )
        } else 
            Wrn( paste('I cannot find any new waypoints on GPS', gps_id ) )

    if(nrow(tr) > 0) {
        tr[, gps_id := gps_id]
        tr[, pk := NA]
        setcolorder(tr, c('gps_id','seg_id','seg_point_id','datetime_','lat','lon','ele','pk'))

        w = dbWriteTable(con, 'GPS_TRACKS', tr, row.names = FALSE, append = TRUE)
        if(!w) Wrn('I could not download the gps track data. Something funny is happening.')

        # feedback
        fieldhours = tr[, difftime(max(datetime_), min(datetime_), units = 'hours') %>% round(., 2) ]
        Msg( paste('You saved', nrow(tr), 'track-points collected during', fieldhours, 'hours.') )
        } else 
            Wrn( paste('I cannot find any new tracks on GPS', gps_id ) )




    }



#' DT2gpx
#' @export
DT2gpx <- function(x) {
    x = NESTS(project = FALSE) 
    x = x[, .(nest, lat, lon)]

    x[, ll := paste0('lat=',shQuote(lat), ' lon=',shQuote(lon) )]
    x[, o := paste('<wpt', ll, '><name>', nest, '</name><sym>Flag, Red</sym></wpt>')]

    o = paste('<gpx>', paste(x$o, collapse = ' ')  , '</gpx>')
    o

    }



#' download_nests
#' @export
download_nests <- function(o = DT2gpx() ) {
    ff = tempfile(fileext = '.gpx')
 
    cat(o, file = ff)

    ff

    }































