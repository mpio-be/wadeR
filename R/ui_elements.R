
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

