# shiny::runApp('inst/UI/imap', launch.browser = TRUE)



# settings
    sapply(c('wader', 'knitr', 'ggplot2', 'ggthemes',
            'shiny','shinyjs','shinydashboard','shinyBS','shinytoastr', 'leaflet'),
      function(x) suppressPackageStartupMessages( require(x, character.only = TRUE, quietly = TRUE) ))
    options(stringsAsFactors = FALSE)

    pos = round(seq(15, 255, length.out = 5))  

