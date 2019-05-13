

sapply(c('DataEntry', 'DataEntry.validation', 'wadeR' , 
       'data.table', 'shinyjs', 'tableHTML', 'glue', 'stringr', 'magrittr'),
require, character.only = TRUE, quietly = TRUE)

tags   = shiny::tags
host   = ip()
db     = yy2dbnam(year(Sys.Date()))
user   = getOption('wader.user')
pwd    = wadeR::pwd()
