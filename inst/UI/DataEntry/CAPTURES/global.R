
# shiny::runApp('inst/UI/DataEntry/CAPTURES')


# settings
  sapply(c('sdb', 'wader', 'DataEntry','shiny','shinyjs','rhandsontable','miniUI','shinyBS','shinytoastr','knitr'),
    require, character.only = TRUE, quietly = TRUE)
  tags = shiny::tags
 

  user           = getOption('wader.user')
  host           = getOption('wader.host')
  db             = yy2dbnam(year(Sys.Date()))
  table          = 'CAPTURES'
  excludeColumns = c('pk', 'PC')
  sqlInspector   = 'select script from validators where table_name = "CAPTURES"'


  comments = column_comment(user, host, db, table,excludeColumns)



