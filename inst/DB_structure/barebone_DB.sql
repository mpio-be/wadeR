
# DROP 
  DROP TABLE IF EXISTS AUTHORS;
  DROP TABLE IF EXISTS CAPTURES;
  DROP TABLE IF EXISTS DEVICES;
  DROP TABLE IF EXISTS EGGS_CHICKS;
  DROP TABLE IF EXISTS GPS_POINTS;
  DROP TABLE IF EXISTS GPS_TRACKS;
  DROP TABLE IF EXISTS NESTS;
  DROP TABLE IF EXISTS RESIGHTINGS;
  DROP TABLE IF EXISTS validators;

CREATE TABLE IF NOT EXISTS AUTHORS (
  year_ int(11)                     DEFAULT NULL,
  name char(50)                     DEFAULT NULL,
  surname char(50)                  DEFAULT NULL,
  initials varchar(2)               DEFAULT NULL,
  START datetime                    DEFAULT NULL COMMENT 'Start of work in BRW',
  STOP datetime                     DEFAULT NULL COMMENT 'End of work in BRW',
  fieldwork int(1)                  DEFAULT NULL COMMENT '1 = yes, 0 = no',
  labwork int(1)                    DEFAULT NULL COMMENT '1 = yes, 0 = no',
  gps_id int(2)                     DEFAULT NULL COMMENT 'Personal GPS ID',
  field_camara_id int(2)            DEFAULT NULL,
  private_camara_prefix varchar(50) DEFAULT NULL,
  transponder varchar(50)           DEFAULT NULL COMMENT 'Test transponder ID for RFID reader',
  remarks varchar(50)               DEFAULT NULL
) ENGINE=InnoDB                     ;



CREATE TABLE IF NOT EXISTS CAPTURES (
  date_ date                        DEFAULT NULL COMMENT 'Date caught YYYY-MM-DD',
  form_id int(3)                    DEFAULT NULL COMMENT 'Capture form ID',
  author varchar(2)                 DEFAULT NULL COMMENT 'GB, MB, MC, CG, BK, JK, P3, KT, MV, AW (see authors file)',
  gps_id int(2)                     DEFAULT NULL COMMENT 'GPS ID (1-11)',
  gps_point int(4)                  DEFAULT NULL COMMENT 'XXX=Waypoint number',
  nest varchar(5)                   DEFAULT NULL COMMENT 'Nest ID (if caught on nest)',
  ID int(6)                         DEFAULT NULL COMMENT 'Metal ring number (without prefix 2701-) band spans: 70001 - 71000',
  UL varchar(10)                    DEFAULT NULL COMMENT 'Probably NA',
  LL varchar(10)                    DEFAULT NULL COMMENT 'Y,M: yellow=2017, M=metal',
  UR varchar(10)                    DEFAULT NULL COMMENT 'Probably NA',
  LR varchar(10)                    DEFAULT NULL COMMENT 'Above,Middle,Down: R=Red, Y=Yellow, Lower-Right: DB=Dark Blue, W=White, P=Pink, O=Orange, LB=Light Blue',
  PC varchar(10)                    DEFAULT NULL COMMENT 'Paint combo = Left,Middle,Right (same colors as LR)',
  sat_tag int(10)                   DEFAULT NULL COMMENT 'Satellite tag ID',
  pit_tag varchar(50)               DEFAULT NULL COMMENT 'PIT-tag ID',
  sex int(1)                        DEFAULT NULL COMMENT 'Observed sex: 1=male, 2=female',
  behav int(1)                      DEFAULT NULL COMMENT 'Observed:1=yes, 0=no (note in Resightings)',
  start_capture time                DEFAULT NULL COMMENT 'HH:MM Time bird seen and capture initiated',
  caught_time time                  DEFAULT NULL COMMENT 'HH:MM Time bird was caught',
  bled_time time                    DEFAULT NULL COMMENT 'HH:MM Time blood samples for hormones are taken',
  released_time time                DEFAULT NULL COMMENT 'HH:MM Time bird was released',
  recapture int(1)                  DEFAULT NULL COMMENT '1=yes, 0=no',
  capture_meth varchar(10)          DEFAULT NULL COMMENT 'Capture method: M=Mistnet, T=Trap or H=Hoop',
  tarsus float                      DEFAULT NULL COMMENT 'Length (mm)',
  culmen float                      DEFAULT NULL COMMENT 'Length (mm)',
  total_head float                  DEFAULT NULL COMMENT 'Length (mm)',
  wing float                        DEFAULT NULL COMMENT 'Length (mm)',
  weight float                      DEFAULT NULL COMMENT 'Body mass (g)',
  ect_par int(1)                    DEFAULT NULL COMMENT 'Ectoparasites:  1=yes, 0=no',
  bp int(1)                         DEFAULT NULL COMMENT 'Brood patch: 1=yes, 0=no',
  carries_egg int(1)                DEFAULT NULL COMMENT 'Female carries visible egg: 1=yes, 0=no',
  molt int(1)                       DEFAULT NULL COMMENT 'Body molt: 0=none, 1=some (~20 feathers), 2=many (>20 feathers)',
  age varchar(3)                    DEFAULT NULL COMMENT 'Age: SY = second year, ASY = after-second year, NA',
  cloaca_l float                    DEFAULT NULL COMMENT 'Cloaca length (mm)',
  cloaca_w float                    DEFAULT NULL COMMENT 'Cloaca width (mm)',
  blood_dna int(1)                  DEFAULT NULL COMMENT 'Sample taken: 1=yes, 0=no',
  haema varchar(50)                 DEFAULT NULL COMMENT 'Percentage of mean haematocrit, comma separated',
  cam_id int(10)                    DEFAULT NULL COMMENT 'Camera ID',
  head_t varchar(50)                DEFAULT NULL COMMENT 'Picture Number - top head',
  head_l varchar(50)                DEFAULT NULL COMMENT 'Picture Number - left head',
  wing_l varchar(50)                DEFAULT NULL COMMENT 'Picture Number - left wing',
  front varchar(50)                 DEFAULT NULL COMMENT 'Picture Number - front',
  dead int(1)                       DEFAULT NULL COMMENT '1=yes, 0=no',
  comments varchar(255)             DEFAULT NULL COMMENT 'Comments: Keep it short. ',
  pk int(10) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (pk),
  KEY ID (ID),
  KEY tagID (sat_tag),
  KEY COMBO (UL,LL,UR,LR),
  KEY gps (gps_id,gps_point)
) ENGINE=InnoDB ;



CREATE TABLE IF NOT EXISTS DEVICES (
  device char(50)                   DEFAULT NULL COMMENT 'Type of the device: MSR = Temperature logger, RFID = Pit-tag reader',
  device_id char(50)                DEFAULT NULL COMMENT 'ID of the device (written on the device)',
  internal_rfid_id char(50)         DEFAULT NULL COMMENT 'Internal ID of the RFID (see SD card)',
  pc_id char(50)                    DEFAULT NULL COMMENT 'PC where time calibration was done (should be PC "wader")',
  start datetime                    DEFAULT NULL COMMENT 'YYYY-MM-DD HH:MM:SS Calibration datetime based on dip of transponder - i.e. the device time was started',
  end datetime                      DEFAULT NULL COMMENT 'YYYY-MM-DD HH:MM:SS Calibration datetime based on transponder dip - i.e. the device was stopped ',
  time_diff char(50)                DEFAULT NULL COMMENT ' HH:MM:SS Difference of time between PC wader and device (shown in MSR)'
) ENGINE=InnoDB  ;


CREATE TABLE IF NOT EXISTS EGGS_CHICKS (
  nest varchar(10) NOT NULL COMMENT 'Nest ID: SXYY(S = R – REPH, N-RNPH, P-PESA, X = your GPS number, YY = your running nest number',
  egg_id int(10)                    DEFAULT NULL COMMENT 'Egg ID (usually 1-4)',
  arrival_datetime datetime         DEFAULT NULL COMMENT 'Date and time when eggs arrived in the lab: YYYY-MM-DD HH:MM',
  egg_weight float                  DEFAULT NULL COMMENT 'Weight of the egg (g)',
  cam_id int(10)                    DEFAULT NULL COMMENT 'Camera ID',
  photo_id int(10)                  DEFAULT NULL COMMENT 'Picture ID',
  float_angle float                 DEFAULT NULL COMMENT 'Floating angle',
  float_height float                DEFAULT NULL COMMENT 'Floating height',
  est_hatch_date date               DEFAULT NULL COMMENT 'Automatically calculated estimated hatching date',
  hatch_start datetime              DEFAULT NULL COMMENT 'Date and time hatching might have started',
  eggs_in_hatcher datetime          DEFAULT NULL COMMENT 'Date and time eggs were put in hatcher',
  hatching_date_time datetime       DEFAULT NULL COMMENT 'Date and time hatching',
  ID int(11)                        DEFAULT NULL COMMENT 'Metal band ID',
  measure_date_time datetime        DEFAULT NULL COMMENT 'Date and time chick was measured',
  author varchar(2)                 DEFAULT NULL COMMENT 'Who measured the chicks',
  culmen float                      DEFAULT NULL COMMENT 'Length (mm)',
  tarsus float                      DEFAULT NULL COMMENT 'Length (mm)',
  weight float                      DEFAULT NULL COMMENT 'Body mass (g)',
  blood int(1)                      DEFAULT NULL COMMENT 'Blood sample taken: 1=yes, 0=no',
  delivery_nest varchar(10)         DEFAULT NULL COMMENT 'Nest to which the eggs were brought',
  delivery_datetime datetime        DEFAULT NULL COMMENT 'Date and time of delivery',
  remarks varchar(255)              DEFAULT NULL COMMENT 'Remarks: keep it short. ',
  pk int(10) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (pk),
  KEY ID (hatch_start)
) ENGINE=InnoDB  ;


CREATE TABLE IF NOT EXISTS GPS_POINTS (
  gps_id int(2) NOT NULL COMMENT 'gps id',
  gps_point int(10) NOT NULL COMMENT 'gps point',
  datetime_ datetime NOT NULL COMMENT 'gps date-time',
  lat float NOT NULL COMMENT 'latitude',
  lon float NOT NULL COMMENT 'longitude',
  ele float NOT NULL COMMENT 'elevation',
  pk int(10) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (pk),
  KEY gps (gps_id,gps_point),
  KEY datetime_ (datetime_)
) ENGINE=InnoDB  ;


CREATE TABLE IF NOT EXISTS GPS_TRACKS (
  gps_id int(2) NOT NULL COMMENT 'gps id',
  seg_id int(10) NOT NULL COMMENT 'segment id',
  seg_point_id int(10) NOT NULL COMMENT 'segment point id',
  datetime_ datetime NOT NULL COMMENT 'gps date-time',
  lat float NOT NULL COMMENT 'latitude',
  lon float NOT NULL COMMENT 'longitude',
  ele float NOT NULL COMMENT 'elevation',
  pk int(10) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (pk),
  KEY gps (gps_id,seg_id),
  KEY datetime_ (datetime_)
) ENGINE=InnoDB ;


CREATE TABLE IF NOT EXISTS NESTS (
  author varchar(2)                 DEFAULT NULL COMMENT 'GB, MB, MC, CG, BK, JK, P3, KT, MV, AW (see authors file)',
  nest varchar(4)                   DEFAULT NULL COMMENT 'Nest ID: SXYY(S=R-REPH, N-RNPH, P-PESA, X=your GPS number, YY=your running nest number',
  gps_id int(2)                     DEFAULT NULL COMMENT 'GPS ID',
  gps_point int(3)                  DEFAULT NULL COMMENT 'GPS waypoint (if nest_state = F this is the position of the nest, otherwise this is the escape distance)',
  datetime_ datetime                DEFAULT NULL COMMENT 'Date and time first approached the nest: YYYY-MM-DD HH:MM',
  time_left time                    DEFAULT NULL COMMENT 'Time left the nest: HH:MM',
  nest_state varchar(2)             DEFAULT NULL COMMENT 'F=found, C=collected, I=Incubated(active  nest), (p)P=(possibly)Predated, (p)D=(possibly)Deserted, H=hatched (received hatched chicks)',
  clutch_size int(1)                DEFAULT NULL COMMENT 'Clutch size',
  id_male int(10)                   DEFAULT NULL COMMENT 'ID of incubating male (metal ID or NOBA, COBA if not sure about RC)',
  id_female int(10)                 DEFAULT NULL COMMENT 'ID of female (metal ID or NOBA, COBA if not sure about RC)',
  behav int(1)                      DEFAULT NULL COMMENT 'Observed:1=yes, 0=no (note in Resightings)',
  msr_id varchar(20)                DEFAULT NULL COMMENT 'ID of the MSR (temperature logger)',
  msr_state varchar(3)              DEFAULT NULL COMMENT 'If you install a MSR=on, if you collect it=off',
  rfid_id varchar(20)               DEFAULT NULL COMMENT 'ID of the RFID reader',
  rfid_state varchar(4)             DEFAULT NULL COMMENT 'on=If you install a RFID, off=if you collect it, dd = downloaded',
  comments varchar(255)             DEFAULT NULL COMMENT 'Comments: Keep it short. ',
  pk int(10) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (pk),
  KEY gps (gps_id,gps_point)
) ENGINE=InnoDB ;


---- RESIGHTINGS is TEMP -----


CREATE TABLE IF NOT EXISTS RESIGHTINGS (
  author varchar(2)                 DEFAULT NULL COMMENT 'author',
  gps_id int(2)                     DEFAULT NULL COMMENT 'GPS ID',
  gps_point int(3)                  DEFAULT NULL COMMENT 'XXX=GPS waypoint number',
  sex int(1)                        DEFAULT NULL COMMENT 'Observed sex: 1=Male, 2=Female',
  
  UL varchar(6)                     DEFAULT NULL COMMENT 'Upper-Left',
  LL varchar(6)                     DEFAULT NULL COMMENT 'Lower-Left',
  UR varchar(6)                     DEFAULT NULL COMMENT 'Upper-Right',
  LR varchar(6)                     DEFAULT NULL COMMENT 'Lower right',

  behav_cat varchar(1)              DEFAULT 'R'  COMMENT 'R=Resighting, C=Capture, N=Nest visit',
  nest_id varchar(9)                DEFAULT NULL COMMENT 'Nest ID if sighting around nest',
  
  habitat varchar(1)                DEFAULT NULL COMMENT 'W=Water, G=Ground, A=Air',
  
  SPIN varchar(3)               DEFAULT NULL COMMENT 'If WF and spinning: SC=Clockwise (right), SAC=Anti-Clockwise (left)',
  AGGRES varchar(10)                DEFAULT NULL COMMENT 
    'D=displaced foraging, F=fight, B=beak pointing,O=other (write in comments)',
  DISPL varchar(10)                DEFAULT NULL COMMENT 'K=kissing,P=parallel swim',
  COP varchar(255)                  DEFAULT NULL COMMENT 'Y=successful copulation,N = attempted copulation & (optionally) I=interrupted(by who) or textual description',
  FLIGHT varchar(10)                DEFAULT NULL COMMENT 'C=chase, F=flight, CF=circle flight',
  VOC varchar(255)                  DEFAULT NULL COMMENT 'Y,N or other (textual description)',
  
  min_dist float                    DEFAULT NULL COMMENT 'Minimum distance to the closest REPH (m)',
  initiator int(1)              DEFAULT NULL COMMENT 'Focal individual is: 1=Initiator (e.g. focal is chasing, displaying, etc.) or 0=Receiver of the interaction',

 
  comments varchar(255)             DEFAULT NULL COMMENT 'Comments: Keep it short. (Write Nest ID if nest visit)',
  pk int(10) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (pk),
  KEY COMBO (UL,LL,UR,LR),
  KEY gps (gps_id,gps_point)
) ENGINE=InnoDB  ;


CREATE TABLE IF NOT EXISTS validators (
  table_name varchar(50) NOT NULL,
  script longtext NOT NULL
) ENGINE=InnoDB   ;


INSERT INTO validators (table_name, script) VALUES ("CAPTURES",'
# Mandatory to enter
v1  = is.na_validator(x[, .(date_, form_id, author, gps_id, gps_point, ID, start_capture, recapture, capture_meth, weight, 
                        PC, LR, cam_id, blood_dna, haema, behav)])
v2  = is.na_validator(x[recapture == 0, .(tarsus, culmen, total_head, wing)], "Mandatory at first capture")
v3  = is.na_validator(x[sex == 2, .(carries_egg)], "Mandatory for females")

# Correct format?
v4  = POSIXct_validator(x[ , .(date_)] )
v5  = hhmm_validator(x[ , .(caught_time, bled_time, released_time)] )
v6  = is.element_validator(x[ , .(author)], v = data.table(variable = "author", set = list(c("GB", "MB", "MC", "CG", "BK", "JK", "P3", "KT", "MV", "AW"))  ))

# Entry should be within specific interval
v7  = interval_validator( x[, .(tarsus)],      v = data.table(variable = "tarsus",     lq = 18, uq = 24 ),   "Measurement out of typical range" )
v8  = interval_validator( x[, .(culmen)],      v = data.table(variable = "culmen",     lq = 18, uq = 26 ),   "Measurement out of typical range" )
v9  = interval_validator( x[, .(total_head)],  v = data.table(variable = "total_head", lq = 20, uq = 70 ),   "Measurement out of typical range" )
v10 = interval_validator( x[, .(wing)],        v = data.table(variable = "wing",       lq = 120, uq = 145 ), "Measurement out of typical range" )
v11 = interval_validator( x[, .(weight)],      v = data.table(variable = "weight",     lq = 35, uq = 80 ),   "Measurement out of typical range" )

v12 = interval_validator( x[sex == 2, .(cloaca_w)], v = data.table(variable = "cloaca_w",  lq = 0, uq = 10 ),        "Measurement out of typical range" )
v13 = interval_validator( x[, .(ID)],               v = data.table(variable = "ID",        lq = 70001, uq = 71000 ), "Metal band not existing for REPH" )
v14 = interval_validator( x[, .(gps_id)],           v = data.table(variable = "gps_id",    lq = 1, uq = 20),         "GPS ID not found?" )
v15 = interval_validator( x[, .(gps_point)],        v = data.table(variable = "gps_point", lq = 1, uq = 999),        "GPS waypoint is over 999?" )

# Entry would be duplicate
v16 = is.duplicate_validator(x[recapture == 0 & !is.na(ID), .(ID)], 
                             v = data.table(variable = "ID", set = list(idbq("SELECT * FROM CAPTURES")$ID  ) ), "Metal band already in use! Recapture?" )
v17 = is.duplicate_validator(x[recapture == 0 & !is.na(LR), .(LR)], 
                             v = data.table(variable = "LR", set = list(idbq("SELECT * FROM CAPTURES")$LR  ) ), "Ring Combo already in use! Recapture?" )
v18 = is.duplicate_validator(x[recapture == 0 & !is.na(PC), .(PC)], 
                             v = data.table(variable = "PC", set = list(idbq("SELECT * FROM CAPTURES")$PC  ) ), "Paint Combo already in use! Recapture?" )

# RC and PC are not existing or in wrong format
require(gtools)
combo_col  = c("R", "Y", "W", "DB", "G", "P", "O", "LB") 
setA       = permutations(length(combo_col), 3, combo_col, repeats=TRUE)
col_combos = paste(setA[,1], setA[,2], setA[,3],  sep = ",")

v19  = is.element_validator(x[!is.na(LR) , .(LR)], v = data.table(variable = "LR", set = list(col_combos)  ), "Ring Combo not found or in wrong format!")
v20  = is.element_validator(x[!is.na(PC) , .(PC)], v = data.table(variable = "PC", set = list(col_combos)  ), "Paint Combo not found or in wrong format!")

# Entry is impossible
# v21 = time_order_validator(x[, .(caught_time)], v = x[!is.na(start_capture), .(start_capture)], "Caught before capture started?")
# v22 = time_order_validator(x[, .(bled_time)], v = x[!is.na(caught_time), .(caught_time)],       "Bled before captured?")
# v23 = time_order_validator(x[, .(released_time)], v = x[!is.na(bled_time), .(bled_time)],      "Bled before captured?")
# v24 = is.element_validator(x[, .(nest)], 
#                            v = data.table(variable = "nest", set = list(idbq("SELECT * FROM NESTS")$nest  ) ), "Nest not found in NESTS!" )


o = list(v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20) %>% rbindlist
o[, .(rowid = paste(rowid, collapse = ",")), by = .(variable, reason)]
') ; 



INSERT INTO validators (table_name, script) VALUES ('NESTS', '
#Mandatory to enter
v1  = is.na_validator(x[, .(author, nest, gps_id, gps_point, datetime_, time_left, nest_state, behav)])
v2  = is.na_validator(x[nest_state == "F" | nest_state == "C", .(clutch_size)], "Clutch size is missing?")
v3  = is.na_validator(x[!is.na(msr_id), .(msr_state)],   "MSR state is missing?")
v4  = is.na_validator(x[!is.na(rfid_id), .(rfid_state)], "RFID state is missing?")
v5  = is.na_validator(x[!is.na(msr_state), .(msr_id)],   "MSR ID is missing!")
v6  = is.na_validator(x[!is.na(rfid_state), .(rfid_id)], "RFID ID is missing!")
# Correct format?
v7  = is.element_validator(x[ , .(author)], v = data.table(variable = "author",  
  set = list(c("GB", "MB", "MC", "CG", "BK", "JK", "P3", "KT", "MV", "AW"))  ))
v8  = POSIXct_validator(x[ , .(datetime_)] ) 
v9  = datetime_validator(x[ , .(datetime_)] ) 
v10 = hhmm_validator(x[ , .(time_left)] )
v11 = is.element_validator(x[ , .(nest_state)],  v = data.table(variable = "nest_state",    set = list(c("F", "C", "I", "pP", "P", "pD", "D", "H"))  ))
v13 = is.element_validator(x[ , .(behav)],  v = data.table(variable = "behav",         set = list(c(0, 1))  ))
v14 = is.element_validator(x[ , .(msr_state)], v = data.table(variable = "msr_state",     set = list(c("on", "off", "dd", NA))  ))
v15 = is.element_validator(x[ , .(rfid_state)], v = data.table(variable = "rfid_state",    set = list(c("on", "off", "dd", NA))  ))
# Entry should be within specific interval
v16 = interval_validator( x[, .(gps_id)],    v = data.table(variable = "gps_id",     lq = 1, uq = 20),  "GPS ID not found?" )
v17 = interval_validator( x[, .(gps_point)], v = data.table(variable = "gps_point",  lq = 1, uq = 999), "GPS waypoint is over 999?" )
v18 = interval_validator( x[!is.na(clutch_size), .(clutch_size)], v = data.table(variable = "clutch_size", lq = 1, uq = 4 ),  "No eggs or more than 4?" )
# Metal ID not found in CAPTURES
v19 = is.element_validator(x[!is.na(id_male) | id_male != "NOBA" |  id_male != "COBA", .(id_male)], 
       v = data.table(variable = "id_male",   set = list(idbq("SELECT LR FROM CAPTURES")$LR  ) ), "Metal ID is not exiting in CAPTURES!" )
v20 = is.element_validator(x[!is.na(id_female) | id_female != "NOBA" |  id_male != "COBA", .(id_female)], 
       v = data.table(variable = "id_female", set = list(idbq("SELECT LR FROM CAPTURES")$LR  ) ), "Metal ID is not exiting in CAPTURES!" )
# Device not existing in DEVICES
v21 = is.element_validator(x[!is.na(msr_id), .(msr_id)], 
       v = data.table(variable = "msr_id",  set = list(idbq("SELECT device_id FROM DEVICES")$device_id  ) ), "MSR ID is not exiting in DEVICES!" )
v22 = is.element_validator(x[!is.na(rfid_id), .(rfid_id)], 
       v = data.table(variable = "rfid_id", set = list(idbq("SELECT device_id FROM DEVICES")$device_id  ) ), "RFID ID is not exiting in DEVICES!" )
# Nest can"t be entered twice if nest_state == F and should exist in data base if nest_state != F
v23 = is.duplicate_validator(x[nest_state == F, .(nest)], 
      v = data.table(variable = "nest", set = list(idbq("SELECT nest FROM NESTS")$nest  ) ), "Nest is already assigned! Nest number given twice or nest_state is not F?" )
v24 = is.element_validator(x[nest_state != F, .(nest)], 
      v = data.table(variable = "nest", set = list(idbq("SELECT nest FROM NESTS")$nest  ) ), "Nest does not exists in NESTS as found!" )
# Nest is in wrong format
possible_nests = rbind(paste0("R", 101:999), paste0("N", 101:999), paste0("P", 101:999))

v25  = is.element_validator(x[, .(nest)], v = data.table(variable = "nest", set = list(possible_nests)  ), "Nest ID does not exist, in wrong format or GPS ID > 9!")


o = list(v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25) %>% rbindlist;
o[, .(rowid = paste(rowid, collapse = ",")), by = .(variable, reason)]
') ; 


INSERT INTO validators (table_name, script) VALUES ('RESIGHTINGS', '
# Mandatory to enter
v1  = is.na_validator(x[, .(author, gps_id, gps_point, behav_cat, sex, LR, habitat)])
v2  = is.na_validator(x[LR != "NOBA" |  LR != "COBA", .(PC)],  "Ring combo read but no paint combo entered?")
v3  = is.na_validator(x[!is.na(interaction), .(int_initiator)],          "Interaction entered - Individual initiator or receiver?")
v4  = is.na_validator(x[interaction == "C", .(c_duration)],              "Copulation entered - c_duration is missing?")
v5  = is.na_validator(x[habitat == "W" & for_maint == "F", .(spin_dir)], "Was the REPH spinning? Remember: That is Barts major scientific query" )
# Correct format?
v6  = is.element_validator(x[ , .(author)],         v = data.table(variable = "author",  
        set = list(c("GB", "MB", "MC", "CG", "BK", "JK", "P3", "KT", "MV", "AW"))  ))
v7  = is.element_validator(x[ , .(behav_cat)],      v = data.table(variable = "behav_cat",     set = list(c("R", "C", "N"))  ))
v8  = is.element_validator(x[ , .(sex)],            v = data.table(variable = "sex",           set = list(c(1, 2))  ))
v9  = is.element_validator(x[ , .(habitat)],        v = data.table(variable = "habitat",       set = list(c("W", "G", "A"))  ))
v10 = is.element_validator(x[ , .(interaction)],    v = data.table(variable = "interaction",   set = list(c("AC", "FI", "D", "CF", "C", "CA", "V", NA))  ))
v11 = is.element_validator(x[ , .(int_initiator)],  v = data.table(variable = "int_initiator", set = list(c(0, 1, NA))  ))
v12 = is.element_validator(x[ , .(for_maint)],      v = data.table(variable = "for_maint",     set = list(c("F", "R", "P", "A", NA))  ))
v13 = is.element_validator(x[ , .(spin_dir)],       v = data.table(variable = "spin_dir",      set = list(c("SC", "SAC", NA))  ))
v14 = is.element_validator(x[ , .(nest_behav)],     v = data.table(variable = "nest_behav",    set = list(c("INC", "DF", "BW", NA))  ))
# Entry should be within specific interval
v15 = interval_validator( x[, .(gps_id)],                       v = data.table(variable = "gps_id",     lq = 1, uq = 20),  "GPS ID not found?" )
v16 = interval_validator( x[, .(gps_point)],                    v = data.table(variable = "gps_point",  lq = 1, uq = 999), "GPS waypoint is over 999?" )
v17 = interval_validator( x[!is.na(c_duration), .(c_duration)], 
    v = data.table(variable = "c_duration", lq = 0, uq = 60 ), "REPH was more than one minute copulating?" )
v18 = interval_validator( x[!is.na(min_dist), .(min_dist)],     v = data.table(variable = "min_dist",   lq = 0, uq = 25 ), 
    "Other individuals more than 25 m away? - Individuals really together?" )
# Combo not existing in CAPTURES
v19 = is.element_validator(x[!is.na(LR) | LR != "NOBA" |  LR != "COBA", .(LR)], 
    v = data.table(variable = "LR", set = list(idbq("SELECT * FROM CAPTURES")$LR  ) ), "Ring combo is not exiting in CAPTURES!" )
v20 = is.element_validator(x[!is.na(PC), .(PC)], 
    v = data.table(variable = "PC", set = list(idbq("SELECT * FROM CAPTURES")$PC  ) ), "Paint combo is not exiting in CAPTURES!" )

o = list(v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20) %>% rbindlist
o[, .(rowid = paste(rowid, collapse = ",")), by = .(variable, reason)]

') ;


INSERT INTO validators (table_name, script) VALUES ('EGGS_CHICKS', '
# Mandatory to enter
v1  = is.na_validator(x[, .(nest, egg_id, arrival_datetime, egg_weight, photo_id, float_angle)])
# Correct format?
v2  = POSIXct_validator(x[ , .(arrival_datetime)] ) # add also a validator which checks that the time is not missing!
# Entry should be within specific interval
v3 = interval_validator( x[, .(egg_id)],      v = data.table(variable = "egg_id",      lq = 1, uq = 4),    "More than 4 eggs?" )
v4 = interval_validator( x[, .(egg_weight)],  v = data.table(variable = "egg_weight",  lq = 10, uq = 50),  "Weight unrealistic?" )
v5 = interval_validator( x[, .(float_angle)], v = data.table(variable = "float_angle", lq = 21, uq = 89),  "Angle has to be between 21 and 89 for the formula" )
# Nest is not entered
v6 = is.element_validator(x[, .(nest)], 
   v = data.table(variable = "nest", set = list(idbq("SELECT * FROM NESTS")$nest  ) ), "Nest does not exists in NESTS!" )

o = list(v1, v2, v3, v4, v5, v6) %>% rbindlist
o[, .(rowid = paste(rowid, collapse = ",")), by = .(variable, reason)]
') ;



INSERT INTO validators (table_name, script) VALUES ('DEVICES', '
v1  = is.na_validator(x[, .(device, device_id)])
o = list(v1) %>% rbindlist
o[, .(rowid = paste(rowid, collapse = ",")), by = .(variable, reason)]
');





