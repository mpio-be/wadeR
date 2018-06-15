
#' @title          nanotag txt to database
#' @return        TRUE if new data are updated, error on no new files
#' @author        MV
#' @export
#' @examples
#' \dontrun{
#'  require(wader)
#'
#'  nanotag2db ()
#' }
#'
nanotag2db <- function(dir =  "~/ownCloud/RAW_DATA/NANO_TAG_DATA/" ) {

  allff  = data.table( f = list.files(dir, pattern = ".csv") )

  doneff = idbq(q = "select distinct filename f from NANO_TAGS")[, done := 1]

  newff = merge(allff, doneff, byx = 'f', all.x = TRUE)[is.na(done)]

  if( nrow(newff) == 0 ) {
    stop ('-------- NO NEW FILES FOUND -------- ')
   }

  # fetch new data
  O = foreach(i = 1: nrow(newff)  , .combine = rbind, .errorhandling = 'remove')  %do% {
    di = fread( paste( dir, newff[i, f] , sep = "/"  ))
    setnames(di, make.names(names(di)))
    di = di[, .(Device.ID,Timestamp, Latitude.decimal, Longitude.decimal,Altitude,Battery.voltage)]
    di[, Timestamp := anytime(Timestamp, asUTC = TRUE ,tz = "UTC") ]
    di[, filenam := newff[i, f] ]
    di

    }

  # upload to b
  O[, pk := NA]
  dbnam = idbq(q = "select * from NANO_TAGS where false") %>% names
  setnames(O, dbnam)
  con = dbcon(user = getOption("wader.user"), host =  getOption("wader.host"), db = yy2dbnam(data.table::year(Sys.Date())))
  out= dbWriteTable(con,'NANO_TAGS', O, append = TRUE, row.names = FALSE)
  dbDisconnect(con)
  out

}



