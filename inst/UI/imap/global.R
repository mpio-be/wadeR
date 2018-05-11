# shiny::runApp('inst/UI/imap', launch.browser = TRUE,port = 1111)




# settings
    sapply(c('wadeR', 'leaflet', 'shinydashboard'),
      function(x) suppressPackageStartupMessages( require(x, character.only = TRUE, quietly = TRUE) ))
    options(stringsAsFactors = FALSE)

    pos = round(seq(15, 255, length.out = 5))

    Y = year(Sys.Date())
