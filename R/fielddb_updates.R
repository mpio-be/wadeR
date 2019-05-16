
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

NESTS2EGGS_CHICKS <- function(Species = 'REPH', table = 'EGGS_CHICKS', db = 'FIELD_REPHatBARROW') {

    con =  dbConnect(RMySQL::MySQL(), host = ip(), user = getOption('wader.user'), db = db, password = pwd())
    on.exit(  dbDisconnect (con)  )


    e = dbGetQuery(con, "select nest, max(clutch_size) clutch from NESTS
                 where nest not in (SELECT distinct nest from EGGS_CHICKS)
                group by nest") %>% data.table
    e[, species := nest2species(nest)]
    e = e[ species %in% Species]
    e = e[, .(pk = rep(NA, each = clutch)) , by = nest]
    Msg(paste(nrow(e), "rows added to the", table))

    dbWriteTable(con, table, e, row.names = FALSE, append = TRUE)

}
