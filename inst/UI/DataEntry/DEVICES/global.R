
# shiny::runApp('inst/UI/DataEntry/DEVICES')


# settings
  sapply(c('sdb', 'wader', 'DataEntry','shiny','shinyjs','rhandsontable','miniUI','shinyBS','shinytoastr','knitr'),
    require, character.only = TRUE, quietly = TRUE)
  tags = shiny::tags
 

  user           = getOption('wader.user')
  host           = getOption('wader.host')
  db             = yy2dbnam(year(Sys.Date()))
  table          = 'DEVICES'
  sqlInspector   = 'select script from validators where table_name = "DEVICES"'

 
  comments = column_comment(user, host, db, table, 'pk')


  getTable <- function() {
   H = idbq(paste('SELECT * FROM', table), user = user, host = host, db = db, enhance = FALSE)
    
    if(nrow(H) == 0) 

    H = rbind(H, data.table(device =  NA ) , fill = TRUE) 

    H



  }

