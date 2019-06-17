
#' @name maps
#' @title  maps
NULL

#' @export
#' @rdname maps
theme_wader  <- function() {
  theme(
    axis.line = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),

    panel.background = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    panel.spacing = unit(0, "lines"),

    legend.justification = c(0, 1),
    legend.position      = c(0,1) ,

    plot.title = element_text(color="grey"),

    plot.background = element_blank(),
    plot.margin = unit(c(0,0,0,0), "in")
    )
  }

#' @export
#' @rdname maps
#' @examples
#' data("map_layers")
#' x = map_layers
#' coord_wader(x)
coord_wader  <- function(x = map_layers) {
    coord_equal(
      xlim = x[name == 'boundary', .(min(lon), max(lon))] %>% t%>% as.vector,
      ylim = x[name == 'boundary', .(min(lat), max(lat))] %>% t%>% as.vector

      )
  }

#' @export
#' @rdname maps
#' @examples
#' map_empty()
map_empty <- function(m = map_layers ) {

  ggplot() +
    ggtitle(format(Sys.time(), "%a, %d %b %y %H:%M")) +
    theme_wader() +
    coord_wader(m) +
    scale_x_continuous(expand = c(0,0)) +
    scale_y_continuous(expand = c(0,0)) +

    geom_polygon(data = m[name == 'narl'] ,      aes(x=lon, y=lat, group=group), size = .2, fill = 'grey80', col = 'grey60' ) +
    geom_polygon(data = m[name == 'buildings'] , aes(x=lon, y=lat, group=group), col = 'grey30') +
    geom_polygon(data = m[name == 'lakes'] , aes(x=lon, y=lat, group=group),
        col = 'grey60', size = .1, fill = '#deebf7', alpha = .5) +
    geom_polygon(data = m[name == 'bog'] , aes(x=lon, y=lat, group=group),
        col = 'grey60', size = .1, fill = '#99d8c9', alpha = .5) +
    geom_point(data = m[name == 'powerline'] , aes(x=lon, y=lat), col = 'grey60', size = .1, alpha = .5)


  }

#' @export
#' @rdname maps
#' @examples
#' n = NESTS()[species == 'REPH']
#' map_nests(n)
map_nests <- function(n, size = 2.5) {

  map_empty() +
  geom_point( data = n, aes(lon, lat,  color = nest_state) , size = size) +
  geom_point( data = n[!is.na(IN)], aes(lon, lat) , size = size, pch = 14) +
  geom_text_repel( data = n, aes(lon, lat, label = nest), size = size ) +
  coord_wader() +
  labs(subtitle = paste('N nests:' , nrow(n), "; Collected clutches:", nrow( n[!is.na(IN)] )) )


  }


#' @export
#' @rdname maps
#' @examples
#' map_tracks()
map_tracks <- function(x = fetch_GPS_tracks(48) ) {


  map_empty() +
  geom_path(data = x, aes(x=lon, y=lat, group = gps_id, color = gps_id), size = 1, alpha = .7 ) +
  scale_color_manual(values = c(brewer.pal(8, "Dark2"), 'black', 'red', 'navy')  ) +
  coord_wader()


  }


#' @export
#' @rdname maps
#' @examples
#' x = RESIGHTINGS()
#' map_resights(x, daysAgo = 1)
map_resights <- function(x, size = 2.5, daysAgo = 5) {

  if(!missing(daysAgo) && daysAgo > 0 )
    x = x[seenDaysAgo <= daysAgo]
  x[, lab := paste(combo, seenDaysAgo,sep = '-')]
  x = x[combo != "|"]

    map_empty() +
    geom_point(      data = x, aes(lon, lat) , size = 1, color = 'grey') +
    geom_label_repel( data = x, aes(lon, lat, label = lab, color = sex),  size = size) +
    coord_wader() +
    scale_colour_manual(values = c("red", "blue", "grey") )


  }


#' @export
#' @rdname maps
#' @examples
#' x = RESIGHTINGS_BY_ID('DB,Y', 'Y')
#' map_resights_by_id(x)
#'
map_resights_by_id <- function(x, size = 2.5) {

    map_empty() +
    geom_point( data = x, aes(lon, lat, color = seenDaysAgo) , size = size) +
    scale_colour_gradient(low = "red", high = "navy") +
    coord_wader()


  }



#' @export
#' @rdname maps
#' @examples
#' x = RESIGHTINGS_BY_DAY()
#' n = NESTS()
#' n = n[nest2species(nest) == 'REPH']
#' map_resights_by_day(x)
#' map_resights_by_day(x, n)
#'
map_resights_by_day <- function(x, n, size = 2.5) {

    g =
    map_empty() +
    geom_point(      data = x, aes(lon, lat) , size = 1, color = 'grey') +
    geom_text_repel( data = x, aes(lon, lat, label = combo, color = sex),   size = size ) +
    coord_wader()


    if(!missing(n)) {
      g = g +
      geom_point( data = n, aes(lon, lat) , size = size, color = 'red') +
      geom_text_repel( data = n, aes(lon, lat, label = nest), size = size )
    }


    g

  }












