

#' reprojectBarrow
#' @examples
#' require(wadeR)
#' data("Barrow")
#' x = reprojectBarrow(Barrow)
#' @export
reprojectBarrow <- function(x, LAT = "lat", LON = "lon") {
  omerc <- getOption("barrow.proj ")
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
