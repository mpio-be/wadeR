

# shiny::runApp('inst/UI/DataEntry/NESTS', port = 1111)


# settings
  sapply(c('wadeR','DataEntry', 'data.table', 'shinyjs', 'shinyBS'),
    require, character.only = TRUE, quietly = TRUE)

  tags = shiny::tags
 
  user           = getOption('wader.user')
  host           = getOption('wader.host')
  db             = yy2dbnam(year(Sys.Date()))
  
  tableName       = 'NESTS'
  excludeColumns = c('pk')
  n_empty_lines   =  30
  
  comments = column_comment(user, host, db, tableName,excludeColumns)
  authors = idbq('select initials from AUTHORS')$initials

# UI table  
  H = emptyFrame(user, host, db, tableName, n = n_empty_lines, excludeColumns, 
      preFilled = list(
          date_ = format(Sys.Date(), "%Y-%m-%d") ) )


 uitable =  
  rhandsontable(H) %>%
      hot_cols(columnSorting = FALSE, manualColumnResize = TRUE) %>%
      hot_rows(fixedRowsTop = 1) %>%
      hot_col(col = "author", type = "dropdown", source = authors )
    


