

#' projp
#' @export
data.tableTransform <- function(DT, proj = '+proj=omerc +lat_0=71.3332703512554 +lonc=-156.654269449915 +alpha=-41.5 +gamma=0.0 +k=1.000000 +x_0=0.000 +y_0=0.000 +ellps=WGS84 +units=m') {

  if(nrow(DT) > 0) {
    pp = SpatialPoints(DT[, .(lon, lat)], proj4string = CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs') )
    pp = spTransform(pp, proj) %>% coordinates
    } else pp = cbind(numeric(0), numeric(0))

  DT[, ':=' (lon =  pp[, 1], lat =  pp[, 2]) ]


  }



#' NESTS
#' @export
#' @examples
#' n = NESTS()[species == 'REPH']


NESTS <- function(project = TRUE) {
    # last state
      n = idbq('SELECT nest, max(CONCAT_WS(" ",date_,time_appr)) datetime_, nest_state
                      FROM NESTS
                          GROUP BY nest, nest_state')
      n[, datetime_      := anytime(datetime_, asUTC = TRUE, tz = 'AKDT')]



      n[, species := nest2species(nest)]

      setorder(n, nest)
      n[, lastd := max(datetime_), by = .(nest)]
      n = n[datetime_ == lastd ][,lastd := NULL]
      n[, lastCheck := difftime(Sys.time(), datetime_, units = 'days') %>% as.numeric %>% round(., 1)  ]

    # lat, lon for F state, species
      g = idbq('SELECT n.gps_id, n.gps_point, CONCAT_WS(" ",n.date_,n.time_appr) datetime_found, n.nest, lat, lon
                  FROM NESTS n JOIN GPS_POINTS g on n.gps_id = g.gps_id AND n.gps_point = g.gps_point
                    WHERE n.gps_id is not NULL and n.nest_state = "F"')
      g[, datetime_ := anytime(datetime_found  , asUTC = TRUE, tz = 'AKDT')]

      n = merge(n, g[, .(nest, lat, lon, datetime_found)], by = c("nest"), all.x = TRUE)
      n[, datetime_found := anytime(datetime_found, asUTC = TRUE, tz = 'AKDT')]

      nopos = nrow( n[is.na(lat)] )
      if(nopos > 0) Err(paste(nopos, 'nests without coordinates; Are all GPS units uploaded?'))

      n = n[!is.na(lat)]



    # clutch size
      cs = idbq("SELECT  nest, min(clutch_size) iniClutch, max(clutch_size) clutch FROM NESTS GROUP BY nest")

    # collected, days till hatching
      e = idbq("select distinct nest from NESTS where nest_state = 'C' ")
      e[, IN := "*"]

    # last msr_state
      m = idbq('SELECT nest, max(CONCAT_WS(" ",date_,time_appr)) datetime_, msr_state
                      FROM NESTS
                          GROUP BY nest, msr_state')
      m = m[msr_state == 'ON' | msr_state == 'OFF' | msr_state == 'DD']
      m[, lastd := max(datetime_), by = .(nest)]
      m = m[datetime_ == lastd ][, c('lastd', 'datetime_') := NULL]
      setnames(m, 'msr_state', 'MSR')

    # male confirmed identity
      idm = idbq("SELECT distinct n.nest,c.LL, c.LR
                from NESTS n
                 left join CAPTURES c on c.ID = n.male_id
                   where male_ID is not NULL")
      idm[, m_sure := combo(LL, LR)]
      idm = idm[, .(nest, m_sure)] %>% unique
      idm[m_sure == '|', m_sure := NA ]
      idm = idm[!is.na(m_sure)]

    # female confirmed identity
      idf = idbq("SELECT distinct n.nest,c.LL, c.LR
                from NESTS n
                 left join CAPTURES c on c.ID = n.female_id
                   where female_ID is not NULL")
      idf[, f_sure := combo(LL, LR)]
      idf = idf[, .(nest, f_sure)] %>% unique
      idf[f_sure == '|', f_sure := NA ]
      idf = idf[!is.na(f_sure)]

    # final set
      o = merge(n, cs, by = 'nest', all.x = TRUE)
      o = merge(o, e,  by = 'nest', all.x = TRUE)
      o = merge(o, m,  by = 'nest', all.x = TRUE)
      o = merge(o, idm,  by = 'nest', all.x = TRUE)
      o = merge(o, idf,  by = 'nest', all.x = TRUE)


    # coords transformations
      if(project)
      data.tableTransform(o)

    o

  }

#' NESTS_SUMMARY
#' @export
NESTS_SUMMARY <- function(f= tempfile(fileext = '.pdf')) {

  rmarkdown::render(system.file('VIEWS', 'summary_NESTS.Rmd', package = 'wadeR'), output_file = f)
  Sys.chmod(f)

  f

  }


#' RESIGHTINGS
#' @export
#'
RESIGHTINGS <- function() {
   x = idbq('SELECT r.UR, r.UL, r.LR, r.LL, lat, lon, datetime_ - interval 8  hour  datetime_ , c.sex from
                GPS_POINTS g
                JOIN
                    RESIGHTINGS r ON
                        g.gps_id = r.gps_id AND g.gps_point = r.gps_point
                JOIN CAPTURES c ON
                c.UL = r.UL AND c.LL = r.LL AND c.UR = r.UR AND c.LR = r.LR
                    ', enhance = FALSE)
   x[, datetime_ := anytime(datetime_, asUTC = TRUE, tz = 'AKDT')]

   x[, combo := paste(LL, LR, sep = '|')]

   x[,lastSeen := max(datetime_), by = .(combo, sex) ]
   x = x[lastSeen == datetime_]

   x[, seenDaysAgo := difftime(Sys.time(), lastSeen, units = 'days') %>% as.numeric %>% round(., 1)  ]


   data.tableTransform(x)

   x

  }


#' RESIGHTINGS_BY_ID
#' @export
#' @examples
#'
#' RESIGHTINGS_BY_ID('DB,Y', 'Y')
#'
RESIGHTINGS_BY_ID <- function(LL, LR) {
   x = idbq(paste('SELECT UL, LL, UR, LR, lat, lon, datetime_ - interval 8  hour  datetime_ from
                GPS_POINTS g
                JOIN
                    RESIGHTINGS r ON
                        g.gps_id = r.gps_id AND g.gps_point = r.gps_point
                  WHERE LL =',shQuote(LL) , "AND LR = ", shQuote(LR))
                    )

   x[, seenDaysAgo := difftime(datetime_, Sys.time(), units = 'days') %>% as.numeric %>% round(., 1) %>% abs  ]

   data.tableTransform(x)

   x

  }


#' RESIGHTINGS_BY_DAY
#' @export
#'
RESIGHTINGS_BY_DAY <- function(day = Sys.Date() ) {
   x = idbq('SELECT r.LR, r.LL, lat, lon, datetime_ - interval 8  hour  datetime_ , c.sex from
                GPS_POINTS g
                JOIN
                    RESIGHTINGS r ON
                        g.gps_id = r.gps_id AND g.gps_point = r.gps_point
                LEFT JOIN CAPTURES c ON
                c.UL = r.UL AND c.LL = r.LL AND c.UR = r.UR AND c.LR = r.LR')

   x = x[datetime_ >= day]

   x[LR != 'NOBA' | LL != 'NOBA', combo := paste(LL, LR, sep = '|')]

   x[LR == 'NOBA' | LL == 'NOBA', combo := 'noba']


   x = x[!is.na(LR) | !is.na(LL)]

   data.tableTransform(x)

   x

  }



#' fetch_GPS_points
#' @export
#' @examples
#' x = fetch_GPS_points()
fetch_GPS_points <- function(gpsid = 0, gpspoints = 0) {

 dummy = data.table(gps_point = 0, lat = 71.3249297, lon = -156.6739807, datetime_ = '')

 if(nchar(gpsid) == 0)     gpsid = 0
 if(nchar(gpspoints) == 0) gpspoints = 0

  o = try(idbq(q = paste('
        SELECT gps_point, datetime_ datetimeUTC, datetime_ - interval 8  hour  datetime_, lat, lon
          FROM GPS_POINTS
            WHERE gps_id = ',gpsid, 'and gps_point in (', gpspoints, ')')), silent = TRUE)
  if(inherits(o, 'try-error') || nrow(o) == 0 )
    o = dummy



  o
  }


#' fetchTracks
#' @export
#' @examples
#' x = fetch_GPS_tracks(48)
fetch_GPS_tracks <- function(lastNhours = 48)  {

 if(is.null(lastNhours)) lastNhours = 48

 o = idbq(
    paste('
    SELECT gps_id, seg_id, lat, lon
        FROM GPS_TRACKS
            WHERE datetime_ > DATE_SUB(CURDATE(), INTERVAL', lastNhours, 'HOUR)
              ORDER BY gps_id, datetime_')
    )

 o[, gps_id := factor(gps_id) ]

 data.tableTransform(o)
 o
}
























