
# TODO  map_layers function


#' @export
theme_wader <- function() {
  theme(
    axis.line            = element_blank(),
    axis.text            = element_blank(),
    axis.ticks           = element_blank(),
    axis.title           = element_blank(),
    panel.background     = element_blank(),
    panel.border         = element_blank(),
    panel.grid           = element_blank(),
    panel.spacing        = unit(0, "lines"),
    legend.justification = c(0, 1),
    legend.position      = c(0, 1),
    plot.title           = element_text(color = "grey"),
    plot.background      = element_blank(),
    plot.margin          = unit(c(0, 0, 0, 0), "in")
  )
}

#' @examples
#' data("map_layers")
#' x = map_layers
#' coord_wader(x)
#' @export
coord_wader <- function(x = map_layers) {
  coord_equal(
    xlim = x[name == "boundary", .(min(lon), max(lon))] |> t() |> as.vector(),
    ylim = x[name == "boundary", .(min(lat), max(lat))] |> t() |> as.vector()
  )
}


#' An empty map of the study area
#' @examples
#' map_empty()
#' @export
map_empty <- function(m = map_layers) {
  ggplot() +
    ggtitle(format(Sys.time(), "%a, %d %b %y %H:%M")) +
    theme_wader() +
    coord_wader(m) +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    geom_polygon(data = m[name == "narl"], aes(x = lon, y = lat, group = group), size = .2, fill = "grey80", col = "grey60") +
    geom_polygon(data = m[name == "buildings"], aes(x = lon, y = lat, group = group), col = "grey30") +
    geom_polygon(
      data = m[name == "lakes"], aes(x = lon, y = lat, group = group),
      col = "grey60", size = .1, fill = "#deebf7", alpha = .5
    ) +
    geom_polygon(
      data = m[name == "bog"], aes(x = lon, y = lat, group = group),
      col = "grey60", size = .1, fill = "#99d8c9", alpha = .5
    ) +
    geom_point(data = m[name == "powerline"], aes(x = lon, y = lat), col = "grey60", size = .1, alpha = .5)
}