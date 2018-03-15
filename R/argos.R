


#' lastArgosTransmission
#' @export

lastArgosTransmission <- function(ndays = 1, username, password) {
    require(geotag)
    
    cap = idbq("SELECT sat_tag tagID, LL, LR, ID, CONCAT_WS(' ', date_, caught_time) captureDate FROM CAPTURES 
                    where sat_tag BETWEEN 169878 AND 169917")
    cap[, combo := paste(LL, LR, sep = '|')] 
    cap[, caught_daysAgo := difftime(Sys.time(), captureDate, units = 'days' ) %>% as.numeric %>% round %>% abs]
    cap = cap[, .(tagID, combo, caught_daysAgo)]

    res =RESIGHTINGS()

    d = merge(cap, res[, .(combo, seenDaysAgo) ], by = 'combo', all.x = TRUE)


    A = d[, soapPlatformId(username = username, 
                            password = password , 
                            platformId = tagID, nbDaysFromNow = ndays) , by = tagID]

    lastA = A[, .(lastArgos= max(locationDate), N_locs = .N ), by = tagID ]
    lastA[, lastArgos  := force_tz(lastArgos, "GMT")  ]
    lastA[, lastArgosAKDT := with_tz(lastArgos, "AKDT")  ]
    lastA[, lastArgosPos_hoursAgo := difftime(Sys.time(), lastArgosAKDT, units = 'hours' ) %>% abs]
    lastA = lastA[, .(tagID, lastArgosPos_hoursAgo, N_locs)]
    lastA[, lastArgosPos_hoursAgo := round(lastArgosPos_hoursAgo, 1) %>% as.numeric]


    o = merge(d, lastA, by = 'tagID', all.x = TRUE)
    setorder(o, lastArgosPos_hoursAgo, na.last= TRUE)
    o[is.na(lastArgosPos_hoursAgo), lastArgosPos_hoursAgo := 24]

    o = unique(o)

    setattr(o,"lastrun",Sys.time()  )
    setattr(o,"lost_platforms", o[lastArgosPos_hoursAgo == 24, .N] )

    o
    
    }
