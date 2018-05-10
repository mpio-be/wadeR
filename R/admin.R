#' @export
ip = function() {
  system('hostname -I', intern = TRUE) %>% str_split(pattern = ' ', simplify = TRUE ) %>% .[1]
  }



#' @export
index.html <- function(IP = ip() ) {

x = paste0('<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="refresh" content="1;url=http://',IP,':3838/wadeR/main/">
        <script type="text/javascript">
            window.location.href = "http://',IP,':3838/wadeR/main/"
        </script>
        <title>Page Redirection</title>
    </head>
    <body>
        If you are not redirected automatically, follow the <a href="http://',IP,':3838/wadeR/main/">this link</a>
    </body>
</html>')

f = paste0(tempdir(), '/index.html')
cat(x, file = f)

return(f)


}



#' Install UI-s on localhost
#' @param root default to "/srv/shiny-server"
#' @param pwd root pwd
#' @export
#' @return NULL
#' @examples
#' install_ui() 
#'
install_ui <- function(pwd, root = "/srv/shiny-server", IP = ip() ) {

  u = system.file('UI', package = 'wadeR')
  uisrc = paste0(system.file('UI', package = 'wadeR'),'/*')
  uipath = paste0(root, '/', 'wadeR')

  # ui-s
  cat('Install user interfaces...')
  system( paste('echo', shQuote(pwd), '| sudo -S rm -R', uipath ),
      wait = TRUE,ignore.stderr = TRUE )
 

  system( paste('echo', shQuote(pwd), '| sudo -S mkdir -p', uipath),
      wait = TRUE,ignore.stderr = TRUE )


  system( paste('echo', shQuote(pwd), '| sudo -S cp -a', uisrc, uipath) ,  
    wait = TRUE,ignore.stderr = TRUE )


  # index
  f = index.html()

  system( paste('echo', shQuote(pwd), '| sudo -S cp -rf', f, '/var/www/html/'),wait = TRUE,ignore.stderr = TRUE  )


  # restart server

  cat('done\n')

  cat('Restarting web server...')
  system( paste('echo', shQuote(pwd), '| sudo -S systemctl restart shiny-server') ,  
    wait = TRUE,ignore.stderr = TRUE )
  cat('done\n')



  }




