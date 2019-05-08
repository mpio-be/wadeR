

#' sysinfo
#' @export
sysinfo <- function(ip) {

    o1 = paste(badge('Current site location'), ip)

    o4 = paste(badge('Shared folder [copy/paste in windows explorer]'), paste0('\\\\', ip ) )

    lastbk = try(lastdbBackup(), silent = TRUE)

    if( !inherits(lastbk, 'difftime') || lastbk > 180) Wrn("Please check BACKUP system !!")

    o2 = paste(badge('Last DB backup (minutes ago)'), lastbk )

    o3 = paste(badge('Package version'), paste('wader', packageVersion('wadeR') ) )



    O =
    paste(
    '<ul class="list-group">',
        paste(o1%>%li,
              o4%>% li,
              o2%>%li,
              o3%>%li
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



#' textInputMini
#' @export

textInputMini <-function(..., divWidth = 50) {
  div(style=
    paste("display: inline-block;vertical-align:top; width:", divWidth, ";")  ,textInput(...) )
}
