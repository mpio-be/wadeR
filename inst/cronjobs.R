
#  cronR::cron_rscript(system.file(package = "wader", "cronjobs.R"))
# */5 * * * * /usr/lib/R/bin/Rscript '/home/wader/R/x86_64-pc-linux-gnu-library/3.4/wader/cronjobs.R'

require(wader)
o = lastArgosTransmission()
dir.create('~/.wader', showWarnings = FALSE)
saveRDS(o, '~/.wader/lastArgos.RDS')

