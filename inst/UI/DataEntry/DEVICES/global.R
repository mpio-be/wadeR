# shiny::runApp('inst/UI/DataEntry/DEVICES' , launch.browser =  TRUE)


# settings
  sapply(c('wadeR','DataEntry', 'data.table', 'shinyjs', 'tableHTML', 'glue'),
    require, character.only = TRUE, quietly = TRUE)
  tags = shiny::tags
 
  host            = getOption('wader.host')
  db              = yy2dbnam(year(Sys.Date()))
  user            = getOption('wader.user')
  pwd             = sdb::getCredentials(user, db, host )$pwd
  
  tableName       = 'DEVICES'
  excludeColumns  = c('pk', 'nov')
  n_empty_lines   =  30
  
# table summary function
  describeTable <- function() {
    x = idbq('select * from DEVICES ')

    data.table(
        N_entries = nrow(x)
           )
  }


  comments = column_comment(user, host, db, pwd, tableName,excludeColumns)

  inspector= getS3method('inspector', tableName)

# Define UI table  
  uitable = emptyFrame(user, host, db, pwd, tableName, n = n_empty_lines, excludeColumns) %>% 
    rhandsontable %>% 
    hot_cols(columnSorting = FALSE, manualColumnResize = TRUE) %>%
    hot_rows(fixedRowsTop = 1) 


