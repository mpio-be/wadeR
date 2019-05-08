

# shiny::runApp('inst/UI/main', launch.browser =  TRUE)

# settings
    sapply(c('wadeR', 'knitr', 'ggplot2', 'ggthemes',
            'shiny','shinyjs','shinydashboard','shinyBS','shinytoastr'),
      function(x) suppressPackageStartupMessages( require(x, character.only = TRUE, quietly = TRUE) ))
    options(stringsAsFactors = FALSE)

Y = year(Sys.Date())

tags = shiny::tags
 
IP = ip() 

