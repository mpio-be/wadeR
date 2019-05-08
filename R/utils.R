#' @title   Find the ip address. 
#' @return  The host external ip. It falls back to localhost on error. 
#' @note    The function is used by idbq and in global.R files
#' @export
ip = function() {
  o = try(system('hostname -I', intern = TRUE), silent = TRUE)
  if(inherits(o, 'try-error'))
    o = "127.0.0.1"
  o = str_trim(o)
  o
  }


#' @title   Password manager
#' @return  a plain text string saved by default on ~/.wader.pwd
#' @export
pwd = function(p = '~/.wader.pwd') {
  if(file.exists(p))
  scan(p, what = 'character', quiet = TRUE) else
  stop('password not set')

  }









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


#' make field database name from year
#' @export
yy2dbnam <- function(year = format(Sys.Date(), format = "%Y") , db = getOption('wader.db') ) {
  if(year == format(Sys.Date(), format = "%Y") )
     paste('FIELD', 'REPHatBARROW', sep = "_") else
     paste('FIELD', year, 'REPHatBARROW', sep = "_")

  }

#' query function
#' @export
#' @importFrom sdb enhanceOutput
idbq <- function(query, year , db  , host = getOption('wader.host') , user = getOption('wader.user'), pwd, enhance = TRUE ) {

  if(missing(year)) year = data.table::year(Sys.Date() )
  if(missing(db))   db   = yy2dbnam(year)
  if(missing(pwd))  pwd  = wadeR::pwd() 

  con =  dbConnect(RMySQL::MySQL(), host = host, user = user, db = db, password = pwd)
  on.exit(  dbDisconnect (con)  )

  o = dbGetQuery(con, query) %>% data.table
  if(enhance)
    sdb::enhanceOutput(o)
  o
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



#' lastdbBackup
#' @export
lastdbBackup <- function(path = getOption('wader.dbbackup') ) {


  if(dir.exists(path)) {
    o = data.table( p = list.files(path, full.names = TRUE))
    o = o[, file.info(p, extra_cols = FALSE), by = 1:nrow(o)]
    o = o[, difftime(Sys.time(), max(ctime), units = 'mins') %>% round]
    } else
    o = 'backup not installed!'

    o

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


#' colorCombos
#' @name      colorCombos
#' @title     create all color combinations
#' @param v   character vector containing the colors
#' @export
#' @examples
#' colorCombos()
colorCombos <- function(v = c('R', 'Y', 'W', 'DB', 'G', 'O') ) {
  setA       = gtools::permutations(length(v), 3, v, repeats=TRUE)
  L_combos17 = paste0('M', '-', setA[,1], ',', setA[,2], '|', 'Y', '-', setA[,3])
  R_combos17 = paste0('M', '-', setA[,3], '|',  'Y', '-', setA[,1], ',', setA[,2])
  L_combos18 = paste0('M', '-', setA[,1], ',', setA[,2], '|', 'W', '-', setA[,3])
  R_combos18 = paste0('M', '-', setA[,3], '|',  'W', '-', setA[,1], ',', setA[,2])
  c(L_combos17, R_combos17, L_combos18, R_combos18)
}


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


#' @export
#' @import broom
describeTable <- function(table, ...){
  o = idbq(paste('select author from', table), ...)

  rbind(data.table(author = 'ALL', N = nrow(o)),   o[, .N, author] )

  }



#' @export
index.html <- function(IP = ip() ) {

  x = paste0('<!DOCTYPE HTML>
  <html lang="en-US">
      <head>
          <meta charset="UTF-8">
          <meta http-equiv="refresh" content="1;url=http://',IP,':3838/wadeR/main/">
          <script type="text/javascript">
              window.location.href = "http://',IP,':3838/wadeR/main/"
          </script>
          <title>Page Redirection</title>
      </head>
      <body>
          If you are not redirected automatically, follow the <a href="http://',IP,':3838/wadeR/main/">this link</a>
      </body>
  </html>')

  f = paste0(tempdir(), '/index.html')
  cat(x, file = f)

  return(f)


  }



#' Install UI-s on localhost
#' @param root default to "/srv/shiny-server"
#' @param pwd root pwd
#' @export
#' @return NULL
#' @examples
#' install_ui() 
#'
install_ui <- function(pwd, install_package = TRUE, root = "/srv/shiny-server", IP = ip() ) {

  if(install_package) {
    cat('Install package...')
    devtools::install_github( "mpio-be/wadeR")
    cat('done\n')
    }

  u = system.file('UI', package = 'wadeR')
  uisrc = paste0(system.file('UI', package = 'wadeR'),'/*')
  uipath = paste0(root, '/', 'wadeR')

  # ui-s
  cat('Install user interfaces...')
  system( paste('echo', shQuote(pwd), '| sudo -S rm -R', uipath ),
      wait = TRUE,ignore.stderr = TRUE )
 

  system( paste('echo', shQuote(pwd), '| sudo -S mkdir -p', uipath),
      wait = TRUE,ignore.stderr = TRUE )


  system( paste('echo', shQuote(pwd), '| sudo -S cp -a', uisrc, uipath) ,  
    wait = TRUE,ignore.stderr = TRUE )


  # index
  f = wadeR::index.html()

  system( paste('echo', shQuote(pwd), '| sudo -S cp -rf', f, '/var/www/html/'),wait = TRUE,ignore.stderr = TRUE  )


  # restart server

  cat('done\n')

  cat('Restarting web server...')
  system( paste('echo', shQuote(pwd), '| sudo -S systemctl restart shiny-server') ,  
    wait = TRUE,ignore.stderr = TRUE )
  cat('done\n')

  cat('Go to', ip() )
  


  }























