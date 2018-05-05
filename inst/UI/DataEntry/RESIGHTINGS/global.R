
# shiny::runApp('inst/UI/DataEntry/RESIGHTINGS')


# settings
  sapply(c('waderR','DataEntry', 'data.table', 'shinyjs', 'shinyBS'),
    require, character.only = TRUE, quietly = TRUE)

  tags = shiny::tags
 

  user           = getOption('wader.user')
  host           = getOption('wader.host')
  db             = yy2dbnam(year(Sys.Date()))
  table          = 'RESIGHTINGS'
  excludeColumns = c('pk', 'PC')
  
  # todo: 
  inspector <- wadeR::inspector.captures


  comments = column_comment(user, host, db, table,excludeColumns)



# table summary function
    table_smry <- function() {
      data.table(a = 'TODO')

    }
