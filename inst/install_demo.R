
# the GPS should contain 10 points taken around Seewiesen 


require(wader)
require(sdb)

options(wader.demo = TRUE)

# create db and user
    db = yy2dbnam(2017)
    con = dbcon('mihai', host = getOption('wader.host'))

    dbq(con, paste('DROP DATABASE IF EXISTS', db))
    dbq(con, paste('CREATE DATABASE', db))

    dbq(con, paste0("GRANT ALL PRIVILEGES ON `%",db,"%`.* TO ", 
        paste0(getOption('wader.user'), "@'%' IDENTIFIED BY "), 
        shQuote(getOption('wader.user')) ) )

    dbq(con, paste("GRANT SELECT  ON `mysql`.* TO", paste0(getOption('wader.user'), "@'%'")) )
    dbq(con, 'FLUSH PRIVILEGES;')



    saveCredentials(getOption('wader.user'), user = , getOption('wader.user'), getOption('wader.host'))

# restore db
    mysqlrestore(file = system.file('DB_structure', 'barebone_DB.sql', package= 'wader'), db = db , user = getOption('wader.user'), host = getOption('wader.host') )
    


  dbq(con, paste('USE', db))

# NESTS data
    # found (F) nests
    N = fread(
        "gps_id,gps_point,author,nest,  datetime_,    nest_state,clutch_size,   comments
          1,       1,       MV,   r101, 2017-04-18 13:05, F ,     4    ,       a comment
          1,       2,       MV,   r102, 2017-04-18 13:05, F ,     4    ,
          1,       3,       MV,   r103, 2017-04-18 13:05, F ,     4    ,
          1,       4,       MV,   r104, 2017-04-18 13:05, F ,     3    ,
          1,       5,       MV,   r105, 2017-04-18 13:05, F ,     4    ,
          1,       6,       MV,   p106, 2017-04-18 13:05, F ,     4    ,     other comment
          1,       7,       MV,   n107, 2017-04-18 13:05, F ,     2    ,      other comment
          1,       8,       MV,   r108, 2017-04-18 13:05, F ,     4    ,      other comment
          1,       9,       MV,   r109, 2017-04-18 13:05, F ,     4    ,      other comment
          1,       10,      MV,   p110, 2017-04-18 13:05, F ,     4    ,      other comment
          1,       99,      MV,   p111, 2017-04-20 13:05, F ,     4    ,      no gps point
          ", colClasses=list(character=c("nest_state"))  )
    dbWriteTable(con, 'NESTS', N, row.names = FALSE, append = TRUE)

    # post-found nest data
    N = fread(
        "author, nest,    datetime_,   nest_state
          MV,    r101, 2017-04-19 12:00, I
          MV,    r101, 2017-04-20 12:00, C
          MV,    r102, 2017-04-30 12:00, H
          MV,    r103, 2017-04-20 12:00, P
          MV,    r105, 2017-04-20 12:00, pD
          MV,    p106, 2017-04-21 12:00, D
          ", 


          colClasses=list(character=c("nest_state")) )

    dbWriteTable(con, 'NESTS', N, row.names = FALSE, append = TRUE)



