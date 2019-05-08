# shiny::runApp('inst/UI/DataEntry/DEVICES' , launch.browser =  TRUE)


# settings
  source(system.file('UI', 'global_settings.R', package = 'wadeR'))


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


