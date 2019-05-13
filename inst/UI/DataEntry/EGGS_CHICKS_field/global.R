# shiny::runApp('inst/UI/DataEntry/EGGS_CHICKS_field' , launch.browser =  TRUE)


# settings
  source(system.file('UI', 'global_settings.R', package = 'wadeR'))

  tableName       = 'EGGS_CHICKS_field1'
  package         = 'wadeR'
  excludeColumns  = c('pk', 'nov', 'est_hatch_date')
  n_empty_lines   =  16
  
# table summary function
  describeTable <- function() {
    x = idbq('select * from EGGS_CHICKS_field ')

    data.table(
        N_entries = nrow(x)
           )
  }


  comments = column_comment(user, host, db, pwd, tableName,excludeColumns)


# Define UI table  
  uitable = emptyFrame(user, host, db, pwd, tableName, n = n_empty_lines, excludeColumns) %>% 
    rhandsontable %>% 
    hot_cols(columnSorting = FALSE, manualColumnResize = TRUE) %>%
    hot_rows(fixedRowsTop = 1) 


