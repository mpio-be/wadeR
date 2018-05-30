#' Data police
#'
#' inspectors are a collection of validators
#'
#' @title data inspector
#' @param x numeric number
#' @param ... other arguments
#' @examples
#' 1 # TODO
#'
#'
#' @export
inspector <- function (x) {
  UseMethod("inspector", x)
}


# @method inspector CAPTURES
# @S3method inspector CAPTURES
#' @export
inspector.CAPTURES <- function(x){
  # Mandatory to enter
  v1  = is.na_validator(x[, .(date_, form_id, author, gps_id, gps_point, ID, start_capture, recapture,
                              capture_meth, weight, blood_dna)])
  v2  = is.na_validator(x[species == "REPH", .(LL, LR, UL, UR, cam_id, haema, behav)])
  v3  = is.na_validator(x[recapture == 0, .(tarsus, culmen, total_head, wing)], "Mandatory at first capture")
  v4  = is.na_validator(x[sex == 2 & species == "REPH", .(carries_egg)], "Mandatory for females")

  # Correct format?
  v5  = POSIXct_validator(x[, .(date_)] )
  v6  = hhmm_validator(x[, .(caught_time, released_time)] )
  v7  = hhmm_validator(x[species == "REPH", .(bled_time)] )
  v8  = is.element_validator(x[ , .(author)], v = data.table(variable = "author", set = list(c("AW", "BK", "JK", "KB", "LC", "MC", "MV", "PD", "PS", "SK", "SS"))  ))
  v9 = is.element_validator(x[ , .(sex)], v = data.table(variable = "sex", set = list(c("M", "F"))  ))

  v10 = is.element_validator( x[species == "REPH", .(ID)], v = data.table(variable = "ID", set = list(c(70001:71000, 45001:46000)) ), "Metal band not existing for REPH" )


  # Entry should be within specific interval
  v11  = interval_validator( x[species == "REPH", .(tarsus)],      v = data.table(variable = "tarsus",     lq = 20, uq = 24 ),   "Measurement out of typical range" )
  v12  = interval_validator( x[species == "REPH", .(culmen)],      v = data.table(variable = "culmen",     lq = 20, uq = 25 ),   "Measurement out of typical range" )
  v13  = interval_validator( x[species == "REPH", .(total_head)],  v = data.table(variable = "total_head", lq = 43.5, uq = 50 ), "Measurement out of typical range" )
  v14 = interval_validator( x[species == "REPH", .(wing)],        v = data.table(variable = "wing",       lq = 128, uq = 145 ), "Measurement out of typical range" )
  v15 = interval_validator( x[species == "REPH", .(weight)],      v = data.table(variable = "weight",     lq = 40, uq = 72 ),   "Measurement out of typical range" )

  v16 = interval_validator( x[species == "REPH", .(gps_id)],      v = data.table(variable = "gps_id",    lq = 1, uq = 13),         "GPS ID is not existing?" )
  v17 = interval_validator( x[species == "REPH", .(gps_point)],   v = data.table(variable = "gps_point", lq = 1, uq = 999),        "GPS waypoint is over 999?" )

  # Entry would be duplicate
  v18 = is.duplicate_validator(x[recapture == 0 & !is.na(ID), .(ID)],
                               v = data.table(variable = "ID", set = list( c(str_sub(idbq("SELECT ID FROM CAPTURES")$ID, -5), getOption('wader.IDs'))  ) ), "Metal band already in use! Recapture?" )

  v19 = combo_validator(x[!LR %in% c("", NA), .( UL, LL, UR, LR)] , include = TRUE,
                        validSet  = c(idbq('select CONCAT(UL, "-", LL, "|",UR, "-", LR) combo FROM CAPTURES' )$combo,
                                      idbq('select CONCAT(UL, "-", LL, "|",UR, "-", LR) combo FROM FIELD_2017_REPHatBARROW.CAPTURES' )$combo),
                                      "Color Combo already in use (in CAPTURES)! Recapture?")

  # RC are not existing or in wrong format
  v20  = combo_validator(x[, .( UL, LL, UR, LR)] , include = FALSE, validSet = colorCombos() )

  # Entry is impossible
  v21 = time_order_validator(x[, .(start_capture, caught_time)], time1 = 'start_capture', time2 = 'caught_time', time_max = 60)
  v22 = time_order_validator(x[, .(caught_time, bled_time)], time1 = 'caught_time', time2 = 'bled_time', time_max = 60)
  v23 = time_order_validator(x[, .(bled_time, released_time)], time1 = 'bled_time', time2 = 'released_time', time_max = 60)
  v24 = is.element_validator(x[!is.na(nest), .(nest)],
                             v = data.table(variable = "nest", set = list(idbq("SELECT * FROM NESTS")$nest  ) ), "Nest not found in NESTS!" )


  o = list(v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v19, v20, v21, v22, v23, v24) %>% rbindlist
  o[, .(rowid = paste(rowid, collapse = ",")), by = .(variable, reason)]

}


# @method inspector RESIGHTINGS
# @S3method inspector RESIGHTINGS
#' @export
inspector.RESIGHTINGS <- function(x){
  # Mandatory to enter
  v1  = is.na_validator(x[, .(author, gps_id, gps_point)])
  v2  = is.na_validator(x[, .(LR)], "Ring combo, NOBA or COBA mandatory")
  v3  = is.na_validator(x[, .(habitat)], "No habitat? Please remember to note it")
  v4  = is.na_validator(x[, .(behav_cat)], "Resighting or capture?")
  v5  = is.na_validator(x[, .(sex)], "Sex not identified?")

  # Correct format?
  v6  = is.element_validator(x[ , .(author)],         v = data.table(variable = "author",
                                                                     set = list(c("AW", "BK", "JK", "KB", "LC", "MC", "MV", "PD", "PS", "SK", "SS"))  ))
  v7  = is.element_validator(x[ , .(behav_cat)],      v = data.table(variable = "behav_cat",     set = list(c("R", "C"))  ))
  v8  = is.element_validator(x[ , .(sex)],            v = data.table(variable = "sex",           set = list(c("M", "F"))  ))
  v9  = is.element_validator(x[ , .(habitat)],        v = data.table(variable = "habitat",       set = list(c("W", "G"))  ))
  v10 = is.element_validator(x[ , .(aggres)],         v = data.table(variable = "aggres",        set = list(c("D", "D0", "D1", "F","F0", "F1", "B", "B0", "B1", "O", "O0","O1", NA, ""))  ))
  v11 = is.element_validator(x[ , .(displ)],          v = data.table(variable = "displ",         set = list(c("K", "K0", "K1", "F", "F0", "F1", "P", "P0", "P1", NA, ""))  ))
  v12 = is.element_validator(x[ , .(cop)],            v = data.table(variable = "cop",           set = list(c("S", "S0", "S1", "A", "A0", "A1", NA, ""))  ))
  v13 = is.element_validator(x[ , .(flight)],         v = data.table(variable = "flight",        set = list(c("F", "F0", "F1","C", "C0", "C1", "CF", "CF0", "CF1", NA, ""))  ))
  v14 = is.element_validator(x[ , .(voc)],            v = data.table(variable = "voc",           set = list(c("Y", "N", NA, ""))  ))
  v15 = is.element_validator(x[ , .(maint)],          v = data.table(variable = "maint",         set = list(c("F", "R", "P", "A", "BW", NA, "", "F,P", "P,F", "F,R", "F,A", "P,A"))  ))
  v16 = is.element_validator(x[ , .(spin)],           v = data.table(variable = "spin",          set = list(c("C", "AC", "B", NA, ""))  ))

  # Entry should be within specific interval
  v17 = interval_validator( x[, .(gps_id)],                       v = data.table(variable = "gps_id",     lq = 1, uq = 20),  "GPS ID not found?" )
  v18 = interval_validator( x[, .(gps_point)],                    v = data.table(variable = "gps_point",  lq = 1, uq = 999), "GPS waypoint is over 999?" )
  v19 = interval_validator( x[!is.na(min_dist), .(min_dist)],     v = data.table(variable = "min_dist",   lq = 0, uq = 25 ),
                            "Other individuals more than 25 m away? - Individuals really together?" )
  # Combo not existing in CAPTURES
  v20 = combo_validator(x[!LR %in% c("NOBA", "NOBA1", "NOBA2", "NOBA3", "NOBA4", "COBA", "M, ,Y,COBA", "M, ,W,COBA", NA), .( UL, LL, UR, LR)] ,  include = TRUE,
                        validSet  = c(idbq('select CONCAT(UL, "-", LL, "|",UR, "-", LR) combo FROM CAPTURES' )$combo,
                                      idbq('select CONCAT(UL, "-", LL, "|",UR, "-", LR) combo FROM FIELD_2017_REPHatBARROW.CAPTURES' )$combo),
                                      "Color combo does not exist in CAPTURES" )


  o = list(v1, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20) %>% rbindlist
  o[, .(rowid = paste(rowid, collapse = ",")), by = .(variable, reason)]



}


# @method inspector NESTS
# @S3method inspector NESTS
#' @export
inspector.NESTS <- function(x){

  x[, datetime_ := as.POSIXct(paste(date_, time_appr))]
  #Mandatory to enter
  v1  = is.na_validator(x[, .(author, nest, date_, time_appr,  nest_state)], "Mandatory entry is missing!")
  v2  = is.na_validator(x[, .(time_left)], "Please remember to note the time you leave the nest!")
  v3  = is.na_validator(x[nest_state == "F" | nest_state == "C", .(clutch_size)], "Clutch size is missing?")
  v4  = is.na_validator(x[!is.na(msr_id), .(msr_state)],   "MSR state is missing?")
  v5  = is.na_validator(x[!is.na(msr_state), .(msr_id)],   "MSR ID is missing!")

  # Correct format?
  v6  = is.element_validator(x[ , .(author)], v = data.table(variable = "author",
                                                             set = list(c("AW", "BK", "JK", "KB", "LC", "MC", "MV", "PD", "PS", "SK", "SS"))  ))
  v7  = POSIXct_validator(x[ , .(datetime_)] )
  v8  = datetime_validator(x[ , .(datetime_)] ) # not working
  v9  = hhmm_validator(x[ , .(time_appr)] )
  v10 = hhmm_validator(x[ , .(time_left)] )
  v11 = time_order_validator(x[, .(time_appr, time_left)], time1 = 'time_appr', time2 = 'time_left', time_max = 60)
  v12 = is.element_validator(x[ , .(nest_state)],  v = data.table(variable = "nest_state",    set = list(c("F", "C", "I", "pP", "P", "pD", "D", "H"))  ))
  v13 = is.element_validator(x[ , .(m_behav)],     v = data.table(variable = "m_behav",       set = list(c("INC", "DF", "BW", "O", "INC,DF", "INC,O", "INC,BW"))  ))
  v14 = is.element_validator(x[ , .(f_behav)],     v = data.table(variable = "f_behav",       set = list(c("INC", "DF", "BW", "O", ""))  ))
  v15 = is.element_validator(x[ , .(msr_state)],   v = data.table(variable = "msr_state",     set = list(c("ON", "OFF", "DD", NA, ""))  ))

  # Entry should be within specific interval
  v16 = interval_validator( x[, .(gps_id)],        v = data.table(variable = "gps_id",     lq = 1, uq = 13),  "GPS ID not found?" )
  v17 = interval_validator( x[, .(gps_point)],     v = data.table(variable = "gps_point",  lq = 1, uq = 999), "GPS waypoint is over 999?" )
  v18 = interval_validator( x[!is.na(clutch_size), .(clutch_size)], v = data.table(variable = "clutch_size", lq = 0, uq = 4 ),  "No eggs or more than 4?" )
  # Metal ID not found in CAPTURES
  v19 = is.element_validator(x[!is.na(male_id), .(male_id)],
                             v = data.table(variable = "male_id",   set = list(  c(str_sub(idbq("SELECT ID FROM CAPTURES")$ID, -5),
                                                                                   idbq("SELECT ID FROM FIELD_2017_REPHatBARROW.CAPTURES")$ID)  ) ), "Metal ID is not exiting in CAPTURES!" )
  v20 = is.element_validator(x[!is.na(female_id), .(female_id)],
                             v = data.table(variable = "female_id", set = list(  str_sub(idbq("SELECT ID FROM CAPTURES")$ID, -5)  ) ), "Metal ID is not exiting in CAPTURES!" )
  # Device not existing in DEVICES
  v21 = is.element_validator(x[!is.na(msr_id) | nchar(msr_id) > 0 , .(msr_id)],
                             v = data.table(variable = "msr_id",  set = list(idbq("SELECT device_id FROM DEVICES")$device_id  ) ), "MSR ID is not existing in DEVICES!" )

  # Nest can"t be entered twice if nest_state == F and should exist in data base if nest_state != F
  v22 = is.duplicate_validator(x[nest_state == "F", .(nest)],
                               v = data.table(variable = "nest", set = list(idbq("SELECT nest FROM NESTS")$nest  ) ), "Nest is already assigned! Nest number given twice or nest_state is not F?" )
  v23 = is.element_validator(x[nest_state != "F", .(nest)],
                             v = data.table(variable = "nest", set = list(idbq("SELECT nest FROM NESTS")$nest  ) ), "Nest does not exist in NESTS as found!" )
  # Nest is in wrong format
  possible_nests = rbind(paste0("R", 101:9999), paste0("N", 101:9999), paste0("P", 101:9999), paste0("S", 101:9999))

  v24  = is.element_validator(x[, .(nest)], v = data.table(variable = "nest", set = list(possible_nests)  ), "Nest ID does not exist, in wrong format or GPS ID > 13!")


  o = list(v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24) %>% rbindlist;
  o[, .(rowid = paste(rowid, collapse = ",")), by = .(variable, reason)]



}


# @method inspector EGGS_CHICKS
# @S3method inspector EGGS_CHICKS
#' @export
inspector.EGGS_CHICKS <- function(x){

  # Mandatory to enter
  v1  = is.na_validator(x[, .(nest, egg_id, arrival_datetime, egg_weight, photo_id, float_angle)])
  # Correct format?
  v2  = POSIXct_validator(x[ , .(arrival_datetime)] ) # add also a validator which checks that the time is not missing!
  # Entry should be within specific interval
  v3 = interval_validator( x[, .(egg_id)],      v = data.table(variable = "egg_id",      lq = 1, uq = 4),    "More than 4 eggs?" )
  v4 = interval_validator( x[, .(egg_weight)],  v = data.table(variable = "egg_weight",  lq = 6.5, uq = 9.5),  "Weight out of typical range?" )
  v5 = interval_validator( x[, .(float_angle)], v = data.table(variable = "float_angle", lq = 21, uq = 89),  "Angle has to be between 21 and 89 for the formula" )
  # Nest is not entered
  v6 = is.element_validator(x[, .(nest)],
                            v = data.table(variable = "nest", set = list(idbq("SELECT * FROM NESTS")$nest  ) ), "Nest does not exists in NESTS!" )

  o = list(v1, v2, v3, v4, v5, v6) %>% rbindlist
  o[, .(rowid = paste(rowid, collapse = ",")), by = .(variable, reason)]



}


# @method inspector DEVICES
# @S3method inspector DEVICES
#' @export
inspector.DEVICES <- function(x){

  v1  = is.na_validator(x[, .(device, device_id)])
  o = list(v1) %>% rbindlist
  o[, .(rowid = paste(rowid, collapse = ",")), by = .(variable, reason)]


}


