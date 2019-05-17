
#' @title        Calculates the estimated hatching date
#' @name         hatch_est
#' @param         x   a data.table containing
#'                  nest,
#'                  arrival_datetime (POSIXct),
#'                  float_angle (angle with which the egg is floating in degree (must be >20 and <90) ),
#'                  float_height (only if egg is floating) float height in mm
#'                  pk (row id)
#' @param        y a data.table containing
#'                  nest,
#'                  iniCLutch (initial clutch),
#'                  clutch (final clutch),
#'                  datetime_found
#' @description  This function calculates the estimated hatching date based on Liebezeit et al. (2007)
#'               "Assessing the development of shorebird eggs using the flotation method:
#'               Species-specific and generalized regression models." Condor 109(1): 32-47.
#' @return       an estimated hatching date (as POSIXct)
#' @export
#' @examples
#'  #----------------------------------------------------#
#' x = data.table(
#'   nest = c('R101', 'N102', 'P101', 'X102', 'R103', 'R104'),
#'   arrival_datetime =as.POSIXct(c('2017-06-01 10:00','2017-06-03 11:00','2017-06-13 09:00','2017-06-13 09:00',NA,NA)),
#'   float_angle = c(21, 80, 85, 20,NA,NA),
#'   float_height = c(0, NA, 2, NA,NA,NA), pk = 1:6 )
#'
#' y = data.table(nest = c('R103', 'R104'), datetime_found = as.POSIXct(c('2017-06-01 10:00', '2017-06-01 13:00')),
#'     iniClutch = c(1,2), clutch = c(4,4) )
#'
#' hatch_est(x,y)



hatch_est <- function(x, y) {
  d = copy(x)
  d[, tmpid := 1:nrow(d)]

  y = y[iniClutch < clutch]

  logit = binomial()$linkfun

  d[, species := nest2species(nest) ]


  parm = data.table(species   = c('REPH',  'RNPH',  'PESA', 'LBDO'),
                         a1   = c(-15.29,  -16.61,  -17.47, -17.2),
                         b1   = c(0.73,    1.08,     0.82,   1.4),
                         a2   = c(-3.03,   -12.99,  -7.29,  -4.7),
                         b2   = c(1.41,    2.51,     1.23,   1.06),
                         c2   = c(-0.10,   0.02,    -0.06,  -0.1) )

   d = merge(d, parm, by = 'species', sort = FALSE, all.x = TRUE)

  # sinking eggs
    d[ float_height <= 0 | is.na(float_height),
      hatch_date := arrival_datetime + 24*60*60 * abs(a1 + b1 * logit((float_angle - 20) / 70) ) ]

  # floating eggs
    d[ float_height > 0,
       hatch_date := arrival_datetime + 19*24*60*60 - 24*60*60 * abs(a2 + b2 * float_height + c2 * float_angle) ]

  # direct estimation
    if(nrow(y) > 0) {
      y[, lay_date       := datetime_found -  (iniClutch*3600*24)]
      y[, hatch_date_dir := lay_date  + clutch*3600*24 +  (19*3600*24)]

      o = merge(d, y[, .(nest, hatch_date_dir)], by = 'nest', sort = FALSE, all.x = TRUE)


      o[!is.na(hatch_date_dir), hatch_date := hatch_date_dir]
    } else o = d


  o[, .(hatch_date, pk)]

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
















