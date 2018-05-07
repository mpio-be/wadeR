
# shiny::runApp('inst/UI/DataEntry/CAPTURES')


# settings
  sapply(c('wadeR','DataEntry', 'data.table', 'shinyjs', 'shinyBS'),
    require, character.only = TRUE, quietly = TRUE)

  tags = shiny::tags
 

  user           = getOption('wader.user')
  host           = getOption('wader.host')
  db             = yy2dbnam(year(Sys.Date()))
  tableName       = 'CAPTURES'
  excludeColumns = c('pk', 'PC')
  
  # todo: 
  inspector <- wadeR::inspector.CAPTURES


  comments = column_comment(user, host, db, tableName,excludeColumns)



# table summary function
    table_smry <- function() {
      data.table(a = 'TODO')

    }