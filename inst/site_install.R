
# ==========================================================================
# INSTALL UI-s
# ==========================================================================

  require(wadeR)
  wadeR::install_ui(pwd = 'w ....')



# ==========================================================================
# CRONTAB
# ==========================================================================

    #  cronR::cron_rscript(system.file(package = "wader", "cronjobs.R"))
    # */5 * * * * /usr/lib/R/bin/Rscript '/home/wadeR/R/x86_64-pc-linux-gnu-library/3.4/wadeR/cronjobs.R'

   # require(wader)
   # o = lastArgosTransmission()
   # dir.create('~/.wadeR', showWarnings = FALSE)
   # saveRDS(o, '~/.wadeR/lastArgos.RDS')
