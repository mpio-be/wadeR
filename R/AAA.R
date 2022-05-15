

#' @title 		wadeR
#' @description Wader field work files
#' @docType 	package
#' @name 		wadeR
NULL


.onAttach <- function(libname, pkgname){

    options(wadeR.proj = '+proj=omerc +lat_0=71.3332703512554 +lonc=-156.654269449915 +alpha=-41.5 +gamma=0.0 +k=1.000000 +x_0=0.000 +y_0=0.000 +ellps=WGS84 +units=m')
    
    }

#' @import  utils data.table  methods stringr  glue
#' @import  ggplot2 ggthemes ggrepel
#' @import  sf lwgeom
NULL
