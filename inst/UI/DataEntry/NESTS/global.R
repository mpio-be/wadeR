
# shiny::runApp('inst/UI/DataEntry/NESTS')


# settings
  sapply(c('sdb', 'wader', 'DataEntry','shiny','shinyjs','rhandsontable','miniUI','shinyBS','shinytoastr','knitr'),
    require, character.only = TRUE, quietly = TRUE)
  tags = shiny::tags
 

  user           = getOption('wader.user')
  host           = getOption('wader.host')
  db             = yy2dbnam(year(Sys.Date()))
  table          = 'NESTS'
  excludeColumns = 'pk'
  sqlInspector   = 'select script from validators where table_name = "NESTS"'


  H = emptyFrame(user, host, db, table, n = 10, excludeColumns, 
        preFilled = list(
            datetime_ = as.character(Sys.Date()) ) 
        )
  comments = column_comment(user, host, db, table,excludeColumns)



