



#' nest attendance based on gps tags data
#'
#' @param last_datetime  last datetime. default to Sys.time() - 3600*6
#' @param project  when TRUE, the default, data.tableTransform is called
#' @param buffer   meters. passed to st_buffer(dist = )
#'
#' @return DT with nest, ....
#' @export
#'
#'
#' @examples
nest_attendance_gps_tag <- function(last_datetime = Sys.time() - 3600*24*5,buffer = 2) {

    # nests
        n = idbq('SELECT n.nest, lat, lon
                    FROM NESTS n JOIN GPS_POINTS g on n.gps_id = g.gps_id AND n.gps_point = g.gps_point
                        WHERE n.gps_id is not NULL and n.nest_state = "F"')


        n = st_as_sf(n, coords = c('lon', 'lat'), crs = '+proj=longlat +datum=WGS84 +no_defs'  )
        n = lwgeom::st_transform_proj(n, crs = getOption('wader.proj') )
        n = st_buffer(n, buffer)


    # gps tags
        gps = idbq(
            glue('
            SELECT DeviceID, datetime_, latit lat, longit lon FROM NANO_TAGS
                    WHERE datetime_ > "{last_datetime}"
                    AND latit IS NOT NULL
            ')
            )

        gps = st_as_sf(gps, coords = c('lon', 'lat'), crs = '+proj=longlat +datum=WGS84 +no_defs'  )
        gps = lwgeom::st_transform_proj(gps, crs = getOption('wader.proj') )



    # nests with gps points in their buffer zone
        o = st_join(n, gps, join = st_intersects)
        o = data.table(o)

    # last record
        o = o[, min_datetime := min(datetime_, na.rm = TRUE), by = .(nest, DeviceID)]



}
