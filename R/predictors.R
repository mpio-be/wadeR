
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

   if ( nrow( d[ (float_height <= 0 | is.na(float_height)) & is.na(float_angle) ] > 0 ) )
    Wrn("Are all the floating data entered?")

  # sinking eggs
    d[ float_height <= 0 | is.na(float_height),
      hatch_date := arrival_datetime + 24*60*60 * abs(a1 + b1 * logit((float_angle - 20) / 70) ) ]

  # floating eggs
    d[ float_height > 0,
       hatch_date := arrival_datetime + 24*60*60 * abs(a2 + b2 * float_height + c2 * float_angle) ]

  # direct estimation
    if(nrow(y) > 0) {
      y[, lay_date       := datetime_found -  (iniClutch*3600*24)]
      y[, hatch_date_dir := lay_date  + clutch*3600*24 +  (19*3600*24)]

      o = merge(d, y[, .(nest, hatch_date_dir)], by = 'nest', sort = FALSE, all.x = TRUE)


      o[!is.na(hatch_date_dir), hatch_date := hatch_date_dir]
    } else o = d


  o[, .(hatch_date, pk)]

  }


#' Estimated hatching date based on Liebezeit (2007) database version
#'
#' @param species Species (Red Phalarope = 'REPH', Red-necked Phalarope = 'RNPH', Pectoral Sandpiper = 'PESA')
#' @param float_time Datetime eggs were floated
#' @param float_angle Float angle (must be >= 21 and <89)
#' @param float_height If egg breaks the surface give the mm above it
#' @param found_datetime Datetime when the nest was found
#' @param found_clutch Clutch size when found
#' @param final_clutch Clutch size when complete
#'
#' @return Estimated hatching datetime
#' @export
#'
#' @examples
#' hatch_est_db(found_datetime = as.POSIXct('2017-06-01 12:00'), found_clutch = 2, final_clutch = 4)
#' hatch_est_db(float_time = as.POSIXct('2017-06-02 00:00'), float_angle = 30, float_height = NA)

hatch_est_db <- function(species = 'REPH', float_time, float_angle, float_height, found_datetime = NA, found_clutch = 4, final_clutch = 4) {

  parm = data.table(spec = c('REPH',  'RNPH',  'PESA', 'LBDO'),
                    a1   = c(-15.29,  -16.61,  -17.47, -17.15),
                    b1   = c(0.73,     1.08,    0.82,  1.44),
                    a2   = c(-3.03,   -12.99,  -7.29,  -4.66),
                    b2   = c(1.41,     2.51,    1.23,  1.06),
                    c2   = c(-0.10,    0.02,   -0.06,  -0.08),
                    inc  = c(20,       20,      22,    21))

  p = parm[spec == species]

  if(found_clutch < final_clutch){

    # estimated hatching date based on incomplete clutch when found
    lay_date   = if(found_clutch == 1){found_datetime}else{found_datetime - (found_clutch*3600*24 - 3600*24)}
    hatch_date = if(final_clutch == 1){found_datetime}else{lay_date + (final_clutch*3600*24 - 3600*24) + (p$inc*3600*24)}

  }else{

    # estimated hatching date after Liebezeit et al. (2007)

    if(float_height <= 0 | is.na(float_height)) {

      # sinking eggs
      logit = binomial()$linkfun
      hatch_date = float_time + 24*60*60 * abs(p$a1 + p$b1 * logit((float_angle - 20) / 70) )

    }else{

      # floating eggs
      hatch_date = float_time + 24*60*60 * abs(p$a2 + p$b2 * float_height + p$c2 * float_angle)

    }

  }

  hatch_date

}


#' Initiation date
#'
#' Calculate the inititaion date based on
#' 1. initial incomplete clutch size
#' 2. hatching datetime (adjusted if eggs where in incubator)
#' 3. estimated hatching datetime
#'
#' @param found_datetime Datetime when the nest was found
#' @param found_clutch Clutch size when found
#' @param final_clutch Clutch size when complete
#' @param hatching_datetime Datetime hatching (clutch mean)
#' @param est_hatching_datetime Estimated hatching time
#' @param incubator If eggs where incubated in incubator = TRUE (default = FALSE)
#'
#' @return Nest initiation datetime
#' @export
#'
#' @examples
#' initiation(found_datetime = as.POSIXct('2017-06-26 12:00'), found_clutch = 2, final_clutch = 3)
#' initiation(found_datetime = as.POSIXct('2017-06-06 10:00'), found_clutch = 3, final_clutch = 3,
#'            hatching_datetime = as.POSIXct('2017-06-26 10:00'))
#' initiation(found_datetime = as.POSIXct('2017-06-06 10:00'), found_clutch = 3, final_clutch = 3,
#'            hatching_datetime = as.POSIXct('2017-06-26 10:00'), incubator = TRUE)
#' initiation(found_datetime = as.POSIXct('2017-06-06 12:00'), found_clutch = 3, final_clutch = 3,
#'            hatching_datetime = NA, est_hatching_datetime = as.POSIXct('2017-06-26 12:00'))

initiation = function(found_datetime, found_clutch, final_clutch, hatching_datetime, est_hatching_datetime, incubation_period, incubator = FALSE){

  if(found_clutch < final_clutch){

    # 1. calculate based on initial incomplete clutch size
    initi = if(found_clutch == 1){found_datetime}else{found_datetime - (found_clutch*3600*24 - 3600*24)}

  }else{

    if(!is.na(hatching_datetime)){

      # 2. calculate based on hatching datetime
      initi = hatching_datetime - (incubation_period*3600*24 + final_clutch*3600*24 - 3600*24) # Assuming an incubation period of 20 days

      # adjust days based on faster incubation in the incubator
      if(incubator == TRUE) initi = initi + 3600*12 # incubation is in average half a day faster (based on 2017 & 2018)

    }else{

      # 3. calculate based on estimated hatching datetime
      initi = est_hatching_datetime - (incubation_period*3600*24 + final_clutch*3600*24 - 3600*24) # Assuming an incubation period of 20 days

    }
  }

  initi
}

















