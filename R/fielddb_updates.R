
#' @title          nanotag txt to database
#' @return        TRUE if new data are updated, error on no new files
#' @author        MV
#' @export
#' @examples
#' \dontrun{
#'  require(wader)
#'
#'  nanotag2db()
#' }
#'
nanotag2db <- function(dir =  "~/ownCloud/RAW_DATA/NANO_TAG_DATA/", db) {
  if(missing(db)) db = yy2dbnam(data.table::year(Sys.Date()))

  allff  = data.table( f = list.files(dir, pattern = ".csv") )
  doneff = idbq(q = "select distinct filename f from NANO_TAGS")[, done := 1]
  newff = merge(allff, doneff, byx = 'f', all.x = TRUE)[is.na(done)]

    con =  dbConnect(RMySQL::MySQL(), host = ip(), user = getOption('wader.user'), db = db,password = pwd())
    on.exit(  dbDisconnect (con)  )




  # fetch new data
  O = foreach(i = 1: nrow(newff)  , .combine = rbind, .errorhandling = 'remove')  %do% {
    di = fread( paste( dir, newff[i, f] , sep = "/"  ))
    setnames(di, make.names(names(di)))
    di = di[, .(Device.ID,Timestamp, Latitude.decimal, Longitude.decimal,Altitude,Speed,Battery.voltage)]
    di[, Timestamp := anytime(Timestamp, asUTC = TRUE ,tz = "UTC") ]
    di[, filenam := newff[i, f] ]
    di

    }

  # upload to db
  if( inherits(O, 'data.table')) {
    O[, pk := NA]

    O[, Device.ID := as.integer(Device.ID) - 967000]

    dbnam = idbq(q = "select * from NANO_TAGS where false") %>% names
    setnames(O, dbnam)

    out= dbWriteTable(con,'NANO_TAGS', O, append = TRUE, row.names = FALSE)

    return(out)
  } else FALSE


}



#' NESTS2EGGS_CHICKS
#' populate  table
#' @export
#' @examples
#' NESTS2EGGS_CHICKS()
#' NESTS2EGGS_CHICKS(c('PESA', 'RNPH'), table = 'EGGS_CHICKS_field')

NESTS2EGGS_CHICKS <- function( table = 'EGGS_CHICKS', db ) {
    
    if(missing(db)) db = yy2dbnam(data.table::year(Sys.Date()))

    con =  dbConnect(RMySQL::MySQL(), host = ip(), user = getOption('wader.user'), db = db, password = pwd())
    on.exit(  dbDisconnect (con)  )


    e = dbGetQuery(con, 'select nest, max(clutch_size) clutch from NESTS
                 WHERE nest_state = "C" AND nest not in (SELECT distinct nest from EGGS_CHICKS)
                group by nest') %>% data.table

    if(nrow(e) == 0)
      Wrn(paste( "No new collected eggs found in ", table, "!" ) )

    if(nrow(e) > 0) {
   
        e[, species := nest2species(nest)]
        e = e[, .(pk = rep(NA, each = clutch) ) , by = nest]
        e[, egg_id := 1:.N, by = nest]



        if(nrow(e) == 0)
          Wrn(paste( "No new collected eggs found in ", table, "!" ) )

        if(nrow(e) > 0) {
          
          Msg(paste(nrow(e), "new rows added to the", table, "table"))
          dbWriteTable(con, table, e, row.names = FALSE, append = TRUE)

        }


     }



}



#' EGGS_CHICKS_updateHatchDate
#' @return 0 on success
#' @export
#' @examples
#' EGGS_CHICKS_updateHatchDate()

EGGS_CHICKS_updateHatchDate <- function(table = 'EGGS_CHICKS', db) {

  if(missing(db)) db = yy2dbnam(data.table::year(Sys.Date()))

  EC = idbq( paste("SELECT nest,arrival_datetime,float_angle,float_height,pk FROM",  table) )
  n = NESTS()


  h = hatch_est(x = EC, y = n)

  # update table
  con =  dbConnect(RMySQL::MySQL(), host = ip(), user = getOption('wader.user'), db = db, password = pwd())
  on.exit(  dbDisconnect (con)  )


  dbExecute(con, 'DROP TABLE IF EXISTS TEMP')


  writeTMP = dbWriteTable(con, 'TEMP', h, row.names = FALSE)

  if(writeTMP) {

  out = dbExecute(con, paste('UPDATE', table ,' e, TEMP t
   SET e.est_hatch_date = t.hatch_date
  WHERE e.pk = t.pk') )


  dbExecute(con, 'DROP TABLE TEMP')

  }

  out
 

 }
