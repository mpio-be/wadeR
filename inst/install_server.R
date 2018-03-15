
# NOTES
  # shiny-server needs to be configured with 'run_as USER'
  # shiny-server restarts with sudo systemctl restart shiny-server


require(sysmanager)
push_github_all(rebuild_vignettes = FALSE, pkg = c('wader', 'DataEntry', 'geotag'))

# server install
require(sysmanager)
install_github( "valcu/DataEntry")
install_github( "valcu/geotag" )

install_github( "valcu/wader")
install_shiny_ui('wader', restartShiny = TRUE, pwd = 'wader') 

