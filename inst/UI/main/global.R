

# shiny::runApp('inst/UI/main', launch.browser = TRUE)


# settings
    sapply(c('wader', 'knitr', 'ggplot2', 'ggthemes',
            'shiny','shinyjs','shinydashboard','shinyBS','shinytoastr'),
      function(x) suppressPackageStartupMessages( require(x, character.only = TRUE, quietly = TRUE) ))
    options(stringsAsFactors = FALSE)


tags = shiny::tags
 
