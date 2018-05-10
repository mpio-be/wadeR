
# ==========================================================================
# CRONTAB
# ==========================================================================

    #  cronR::cron_rscript(system.file(package = "wader", "cronjobs.R"))
    # */5 * * * * /usr/lib/R/bin/Rscript '/home/wader/R/x86_64-pc-linux-gnu-library/3.4/wader/cronjobs.R'

    require(wader)
    o = lastArgosTransmission()
    dir.create('~/.wader', showWarnings = FALSE)
    saveRDS(o, '~/.wader/lastArgos.RDS')

# ==========================================================================
# INSTALL WEB UI
# ==========================================================================
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

