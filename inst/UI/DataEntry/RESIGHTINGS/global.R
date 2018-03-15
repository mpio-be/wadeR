
# shiny::runApp('inst/UI/DataEntry/RESIGHTINGS')


# settings
  sapply(c('sdb', 'wader', 'DataEntry','shiny','shinyjs','rhandsontable','miniUI','shinyBS','shinytoastr','knitr'),
    require, character.only = TRUE, quietly = TRUE)
  tags = shiny::tags
 

  user           = getOption('wader.user')
  host           = getOption('wader.host')
  db             = yy2dbnam(year(Sys.Date()))
  table          = 'RESIGHTINGS'
  excludeColumns = c('PC', 'pk')
  sqlInspector   = 'select script from validators where table_name = "RESIGHTINGS"'



  H = emptyFrame(user, host, db, table, n = 15, excludeColumns, 
        preFilled = list(UL = 'M', UR = 'Y') 
        )
  
  comments = column_comment(user, host, db, table,excludeColumns)





