


#' @examples
#' require(wadeR)
#' data("map_layers")
#' x = reprojectBarrow(map_layers)
#' @export
reprojectBarrow <- function(x, LAT = "lat", LON = "lon") {
  omerc <- getOption("wadeR.proj")
  ll <- 4326

  if (median(x[, ..LAT][[1]]) < 0) {
    from <- omerc
    to <- ll
  }
  if (median(x[, ..LAT][[1]]) > 0) {
    from <- ll
    to <- omerc
  }


  d <- st_as_sf(x, coords = c(LON, LAT), crs = st_crs(from)) |>
    st_transform(st_crs(to))
  d <- cbind(x, st_coordinates(d))
  d[, ":="(lon = X, lat = Y)][, ":="(X = NULL, Y = NULL)]

  d
}
