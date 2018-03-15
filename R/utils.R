#' @title   translates nest id in species abbreviation
#' @name    nest2species
#' @param nests        nest ID in the format SXYY (S = one letter for the species, X = GPS ID, YY = running nest number)
#' @description          this function extracts the species from the nest ID (R = REPH, N = RNPH. P = PESA)
#' @return               species abbreviation (REPH, RNPH or PESA)
#' @export
#' @examples
#'  #----------------------------------------------------#
#' nest2species( nest = c('R101', 'P201', 'X102', 'N101')  )

nest2species <- function(nest){

  o = sapply(nest, function (x) { 
   n = substr(x, 1, 1)
   ifelse(n == 'R', 'REPH', 
    ifelse(n == 'N', 'RNPH', 
      ifelse(n == 'P', 'PESA', 
        ifelse(n == 'S', 'SESA', 
          ifelse(n == 'A', 'AMGP',
            ifelse(n == 'T', 'RUTU', 
             ifelse(n == 'B', 'BASA', 
               ifelse(n == 'D', 'DUNL',NA))))))))

    })

   }


#' find database name from year
#' @export
yy2dbnam <- function(year, demo = getOption('wader.demo') ) {
  if(year == format(Sys.Date(), format = "%Y") )
     db = 'FIELD_REPHatBARROW' else
     paste('FIELD', year, 'REPHatBARROW', sep = "_")
     if(demo) db = 'FIELD_REPHatBARROW_demo'
     db

  }

#' query function
#' @export
idbq <- function(query, year , db  , host = getOption('wader.host') , user = getOption('wader.user'), enhance = TRUE ) {
  require(sdb)
  if(missing(year)) year = data.table::year(Sys.Date() )
  if(missing(db)) db = yy2dbnam(year)

  con = dbcon(user = user, host = host, db = db)
  on.exit(  closeCon (con)  )

  dbq(con, query, enhance = enhance)

  }


#' dayofyear2date
#' @export
#' @examples
#' dayofyear2date(1)
dayofyear2date <- function(dayofyear, year) {
  if(missing(year)) year = data.table::year(Sys.Date())
  ans = as.Date(dayofyear - 1, origin = paste(year, "01-01", sep = "-"))
  as.POSIXct(round( as.POSIXct(ans), units = "days"))

  }

#' gpxPOSIXct
#' @export
#' @examples 
#' strptime('2017/04/18 13:05:28+00', "%Y/%m/%d %H:%M:%S+%OS")
  gpxPOSIXct <-function(x) {
    x = str_replace(x, '\\+00$', '')
    strptime(x, "%Y/%m/%d %H:%M:%S") %>% as.POSIXct 
   }


#' ip
#' @export
#' @examples 
#' ip()
ip <-function(x, expand_to_index = TRUE) {
  o = system("ip route get 8.8.8.8 | awk 'NR==1 {print $NF}'", intern = TRUE)
  o
  if( expand_to_index & length(o)> 0)

    o = paste0('http://', o , '/wader/main/') else o = 'WARNING! NO INTERNET ACCESS.'

    o

 
 }



#' lastdbBackup
#' @export
lastdbBackup <- function(path = getOption('wader.dbbackup') ) {

  o = data.table(p = list.files(path, full.names = TRUE))
  o = o[, file.info(p, extra_cols = FALSE), by = 1:nrow(o)]
  o[, difftime(Sys.time(), max(ctime), units = 'mins') %>% round]

  }


#' dbTablesStatus
#' @export
dbTablesStatus <- function() {

  o = idbq(paste("SELECT table_name, last_update, n_rows from mysql.innodb_table_stats 
              WHERE database_name =", shQuote(yy2dbnam(year(Sys.Date())))))
  o[, last_update := format(last_update, "%a, %d %b %H:%M") ]
  o
  }


#' dbTableUpdate
#' @export
dbTableUpdate <- function(user, host, db, table, newdat) {

  con = dbcon(user = user,  host = host)
  on.exit(dbDisconnect(con))

  dbq(con, paste('USE', db) )

  dbq(con, 'DROP TABLE IF EXISTS TEMP')
  dbq(con, paste('CREATE TABLE TEMP LIKE', table) )

  update_ok = dbWriteTable(con, 'TEMP', newdat, append = TRUE, row.names = FALSE)

  if(update_ok) {
    dbq(con, paste('DROP TABLE', table) )
    dbq(con, paste('RENAME TABLE TEMP to', table) )
    }

   update_ok 
        
}

#' combo
#' @export
#' @examples 
#' LL = c('W,R', 'Y,DB', NA, NA, 'NOBA'); LR = c('Y', 'DB', 'c', NA)
combo <- function(LL, LR) {
  o = paste(LL, LR, sep = '|')
  o = str_replace_all(o, 'NA', '')
  o
  }



 #' removeDuplicates

#' removeDuplicates (latest version on sdb)
#' @export
#' @examples 
#' removeDuplicates('NESTS')
removeDuplicates <- function(table, key = 'pk') {

  n0 = idbq( paste("select count(*) n from ", table),enhance= FALSE )$n

  d = idbq(paste("SELECT * FROM", table))
  k = d[, c(key), with = FALSE]
  d[, c(key) := NULL]

  k[, dupl := duplicated(d) ]
  duplk = k[(dupl), key, with = FALSE]
  
  if(nrow(duplk) > 0) {

    duplk = paste(as.matrix(duplk)[,1], collapse = ',')

    idbq(paste("DELETE FROM", table,   "WHERE",  key , "IN (",  duplk, ")" ), enhance= FALSE)

    n1 = idbq( paste("select count(*) n from ", table), enhance= FALSE )$n
    
    message(n0-n1, ' duplicates removed from ', table)
    } else  "nothing to remove"

  }


