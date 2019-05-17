

# shiny::runApp('inst/UI/main', launch.browser =  TRUE)

# settings
    sapply(c('wadeR', 'knitr', 'ggplot2', 'ggthemes','glue', 
            'shiny','shinyjs','shinydashboard','shinytoastr', 'shinyWidgets'),
      function(x) suppressPackageStartupMessages( require(x, 
      	character.only = TRUE, quietly = TRUE) ))
    options(stringsAsFactors = FALSE)

Y = year(Sys.Date())

tags = shiny::tags
 
