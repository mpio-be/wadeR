

    require(rgdal)
    require(data.table)
    require(magrittr)
    require(ggplot2)
    require(stringr)
    require(wader)
    p4sold = "+proj=utm +zone=4 +datum=WGS84"
    p4sll = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'

    rotateProj = function(spobj, angle) {
        # adapted from https://rpubs.com/geospacedman/rotatespatial
        boxpts = SpatialPoints(t(bbox(spobj)), proj4string = CRS(proj4string(spobj)))
        llc = apply( bbox(boxpts), 1, mean)
        prj = paste0("+proj=omerc +lat_0=", llc[2], " +lonc=", llc[1], " +alpha=",
            angle, " +gamma=0.0 +k=1.000000 +x_0=0.000 +y_0=0.000 +ellps=WGS84 +units=m ")
        CRS(prj)
    }


    # map layers
        narl      = readOGR('./inst/map_src/', 'NARL_area', p4s = p4sold, verbose = FALSE) %>% spTransform(CRS(p4sll))
        lakes     = readOGR('./inst/map_src/', 'lakes',    p4s = p4sold, verbose = FALSE) %>% spTransform(CRS(p4sll))
        buildings = readOGR('./inst/map_src/', 'buildings',    p4s = p4sold, verbose = FALSE) %>% spTransform(CRS(p4sll))
        bog       = readOGR('./inst/map_src/', 'SE_bog_area',    p4s = p4sold, verbose = FALSE) %>% spTransform(CRS(p4sll))
        powerline = readOGR('./inst/map_src/', 'power_line',    p4s = p4sold, verbose = FALSE) %>% spTransform(CRS(p4sll))
        powerline = powerline[!powerline$remarks %in% c('Parabolspider', 'Parabolspider Est'), ]
        boundary = readOGR('./inst/map_src/', 'boundary')

        plot(lakes, axes = TRUE)
        plot(narl, add = TRUE, col = 'grey')
        plot(buildings, add = TRUE, col = 'red', border = 'red')
        plot(bog, add = TRUE)
        plot(powerline, add = TRUE, cex = .5, pch = 1)
        plot(boundary, add = TRUE, cex = .5, pch = 1)


    # find the best  rotation projection
        plot(spTransform(narl, rotateProj(narl, - 41.5)) , axes = TRUE)
        prj = '+proj=omerc +lat_0=71.3332703512554 +lonc=-156.654269449915 +alpha=-41.5 +gamma=0.0 +k=1.000000 +x_0=0.000 +y_0=0.000 +ellps=WGS84 +units=m'
        narl      =  spTransform (narl     , CRS(prj))
        lakes     =  spTransform(lakes    , CRS(prj))
        buildings =  spTransform(buildings, CRS(prj))
        bog       =  spTransform(bog      , CRS(prj))
        powerline =  spTransform(powerline, CRS(prj))
        boundary =  spTransform(boundary, CRS(prj))


        plot(lakes, axes = TRUE)
        plot(narl, add = TRUE, col = 'grey')
        plot(buildings, add = TRUE, col = 'red', border = 'red')
        plot(bog, add = TRUE)
        plot(powerline, add = TRUE, cex = .5, pch = 1)
        plot(boundary, add = TRUE)



     # convert to DT
        narl      =  narl      %>% fortify %>% data.table %>% .[, .(long, lat, group)]%>% .[, name := 'narl'      ]
        lakes     =  lakes     %>% fortify %>% data.table %>% .[, .(long, lat, group)]%>% .[, name := 'lakes'     ]
        buildings =  buildings %>% fortify %>% data.table %>% .[, .(long, lat, group)]%>% .[, name := 'buildings' ]
        bog       =  bog       %>% fortify %>% data.table %>% .[, .(long, lat, group)]%>% .[, name := 'bog'       ]
        powerline =  powerline %>% data.frame %>% data.table %>% .[, name := 'powerline'] %>% .[, optional := NULL] %>% .[, ID := NULL]
        setnames(powerline, c('remarks', 'coords.x1' , 'coords.x2', 'name') , c('group', 'long', 'lat',  'name') )
        powerline[, group := 'p']
        setcolorder(powerline, names(narl))

        boundary       =  boundary       %>% fortify %>% data.table %>% .[, .(long, lat, group)]%>% .[, name := 'boundary'       ]


        map_layers = rbindlist(list(narl     ,lakes    ,buildings,bog      ,powerline, boundary))
        setcolorder(map_layers, c('long', 'lat', 'group', 'name'))
        setnames(map_layers, "long", "lon")


    # save
        file.remove('./data/map_layers.RData')
        save(map_layers, file = './data/map_layers.RData')





