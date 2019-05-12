# shiny::runApp('inst/UI/imap', launch.browser = TRUE)





# settings
    sapply(c('wadeR', 'leaflet', 'shiny', 'shinytoastr'),
      function(x) suppressPackageStartupMessages( require(x, character.only = TRUE, quietly = TRUE) ))
    options(stringsAsFactors = FALSE)

    pos = round(seq(15, 255, length.out = 5))

    Y = year(Sys.Date())


