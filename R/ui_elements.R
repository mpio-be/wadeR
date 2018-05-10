
#' Messages
#' @export
UI <- function() {
  bootstrapPage(theme = NULL,

    # navbar
    includeHTML( system.file("vNavBar", 'navbar.html', package = "DataEntry") ) ,
    jquery_change_by_id('TABLE_NAME', tableName),

    # table
    rHandsontableOutput("table",  width = "99%"),

    # ui output
    uiOutput("run_save"),

    # modals
    shinyBS::bsModal("help", "Columns definition", "helpButton", size = "large", tableOutput("column_comments") ),
    shinyBS::bsModal("smry", "Data summary", "tableInfoButton", size = "large", tableOutput("data_summary") ),
    shinyBS::bsModal("cheatsheet", "Cheat sheet", "cheatsheetButton", size = "large", tableOutput("cheatsheet_show") ),

    # elements
    useNavbar(),
    useToastr(),
    shinyjs::useShinyjs(),
    shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(true); }"),

    js_insertMySQLTimeStamp()

  
   )



} 


#' sysinfo
#' @export
sysinfo <- function() {

    o1 = paste(badge('Keyboard shortcut'), '</span> <kbd>/</kbd> Expands  to current time-stamp' )
    o2 = paste(badge('Current site location'), ip() )

    lastbk = try(lastdbBackup(), silent = TRUE)


    if( inherits(lastbk, 'try-error') || lastbk > 30) Wrn("Please check BACKUP system !!")


    o3 = paste(badge('Last DB backup'), paste(lastbk, 'minutes ago') )

    o4 = paste(badge('Package version'), paste('wader', packageVersion('wader') ) )
    o5 = paste(badge('Package version'), paste('rhandsontable', packageVersion('rhandsontable') ) )
    o6 = paste(badge('Package version'), paste('DataEntry', packageVersion('DataEntry') ) )


    O =
    paste(
    '<ul class="list-group">',
        paste(o1%>%li,
              o2%>%li,
              o3%>%li,
              o4%>%li,
              o5%>%li,
              o6%>%li
              ),
     '</ul>' )

    HTML(O)


}



#' Messages
#' @export
#' @examples
#' Msg('hi!')
Msg <- function(x, ...) {
    message(x)
    try(toastr_success(x, timeOut = 10000, preventDuplicates = TRUE, ...), silent = TRUE)
  }

#' Warnings
#' @export
#' @examples
#' Wrn('hmm!')
Wrn <- function(x, ...) {
    message(x)
    try(toastr_warning(x, timeOut = 10000, preventDuplicates = TRUE, position = "top-right", ...), silent = TRUE)
  }

#' Warnings
#' @export
#' @examples
#' Err('oops!')
Err <- function(x, ...) {
    message(x)
    try(toastr_error(x, timeOut = 20000,closeButton = TRUE,
                    position = "top-right", preventDuplicates = TRUE, ...), silent = TRUE)
  }


#' badge
#' @export
 badge <- function(x) {
paste('<span class="badge">',x,'</span>')

 }



#' li
#' @export
 li <- function(x) {
paste('<li class="list-group-item">',x,'</li>')

 }


#' sysinfo
#' @export
sysinfo <- function() {

    o1 = paste(badge('Keyboard shortcut'), '</span> <kbd>/</kbd> Expands  to current time-stamp' )
    o2 = paste(badge('Current site location'), ip() )

    lastbk = try(lastdbBackup(), silent = TRUE)


    if( inherits(lastbk, 'try-error') || lastbk > 30) Wrn("Please check BACKUP system !!")


    o3 = paste(badge('Last DB backup'), paste(lastbk, 'minutes ago') )

    o4 = paste(badge('Package version'), paste('wader', packageVersion('wader') ) )
    o5 = paste(badge('Package version'), paste('rhandsontable', packageVersion('rhandsontable') ) )
    o6 = paste(badge('Package version'), paste('DataEntry', packageVersion('DataEntry') ) )


    O =
    paste(
    '<ul class="list-group">',
        paste(o1%>%li,
              o2%>%li,
              o3%>%li,
              o4%>%li,
              o5%>%li,
              o6%>%li
              ),
     '</ul>' )

    HTML(O)


}




#' textInputMini
#' @export

textInputMini <-function(..., divWidth = 50) {
  div(style= 
    paste("display: inline-block;vertical-align:top; width:", divWidth, ";")  ,textInput(...) )
}
