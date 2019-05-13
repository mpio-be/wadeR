
# shiny::runApp('inst/UI/DataEntry/RESIGHTINGS', port = 1111)

# settings
  source(system.file('UI', 'global_settings.R', package = 'wadeR'))

 
  tableName       = 'RESIGHTINGS'
  package         = 'wadeR'
  excludeColumns  = c('pk', 'nov')
  n_empty_lines   =  30
  
# table summary function
  describeTable <- function() {
    x = idbq('select concat_ws(UL, LL, UR, LR) ID, species from RESIGHTINGS ')

    data.table(
        N_entries = nrow(x), 
        N_unique_IDs = length(unique(x$ID))
           )
  }

  comments = column_comment(user, host, db, pwd, tableName,excludeColumns)

  authors = idbq('select initials from AUTHORS')$initials



# Define UI table  
  uitable = emptyFrame(user, host, db, pwd, tableName, n = n_empty_lines, excludeColumns) %>% 
    rhandsontable %>% 
    hot_cols(columnSorting = FALSE, manualColumnResize = TRUE) %>%
    hot_rows(fixedRowsTop = 1) %>%
    hot_col(col = "author", type = "dropdown", source = authors )









