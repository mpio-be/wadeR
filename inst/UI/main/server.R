

shinyServer(function(input, output, session) {
observe( on.exit( assign('input', reactiveValuesToList(input) , envir = .GlobalEnv)) )

# main board
  output$overview_show <- renderTable({
    invalidateLater(60000)
    dbTablesStatus()

  })

  output$sys_show <- renderUI({
    invalidateLater(2000)

    sysinfo(ip = IP)

  })

# ARGOS table
  output$argos_show <- renderDataTable({
    invalidateLater(240000)
    # dbTablesStatus()

    # o = readRDS('~/.wader/lastArgos.RDS')

    # Msg( paste( "Last Argos update:", as.character(attr(o, 'lastrun') ) ) )

    # lostTags = attr(o, 'lost_platforms')
    # if(lostTags > 0) Err( paste( lostTags, 'tags most likely lost.') )

    o = data.table(info = 'waiting for tags')


  }, options = list(pageLength = 40))

  output$sys_show <- renderUI({
    invalidateLater(2000)

    sysinfo(ip = IP)

  })

# GPS data
 # observeEvent(input$menubar, {
 #     Wrn('Plug in your GPS (it will behave like an USB pen)
 #         and ONLY select directory Garmin within your  e.g. E:\\GARMIN.
 #         Selecting the entire disk works but it will select its recycle bin too.')
 #    }, once = TRUE, ignoreInit = TRUE)

  df <- reactive({
         if(!is.null(input$fileIn)) {
        allff  = data.table(input$fileIn)
        gpxff = allff[grep('\\.gpx$', name)][!grepl('NESTS.gpx$', name)]$datapath
        gpsid = allff[grep('startup.txt$', name)]$datapath %>% read_gpsID

        upload_gps(gpxff, gpsid)

        }
   })

  output$gps_files <- renderDataTable({

          df()
   })

  output$download_NESTS <- downloadHandler(
      filename = 'NESTS.gpx',
      content = function(file) {
        Msg('download the NESTS.gpx and copy/overwrite the file to the /Garmin/GPX folder on your GARMIN')
        o = download_nests()
        file.copy(o, file)
      })

# NESTS map
  N <- reactive({
    if(input$menubar == 'nestsmap_tab') {
    NESTS()

    }

    })

  output$nestsmap_show <- renderPlot({

    n = N()
    if(length(input$nest_state) > 0 )
      n =  n[nest_state %in% input$nest_state]
    if(length(input$species) > 0 )
      n =  n[species %in% input$species]


    map_nests(n, size = input$font_size)


    })

  output$nestsmap_pdf <- downloadHandler(
  filename = 'nestsmap.pdf',
  content = function(file) {
    n = N()
    if(length(input$nest_state) > 0 )
      n =  n[nest_state %in% input$nest_state]
    if(length(input$species) > 0 )
      n =  n[species %in% input$species]

    m = map_nests(n, size = input$font_size)
    cairo_pdf(file = file, width = 11, height = 8.5)
    print(m)
    dev.off()
  })

# NESTS data
  output$nestsdata_show <- renderDataTable({
    idbq('select * from NESTS')

    }, options = list(scrollX = TRUE) )

# NESTS DASHBOARD
  output$download_nestsSummary <- downloadHandler(
  filename = 'nests_summary.pdf',
  content = function(file) {
    f = NESTS_SUMMARY()
    file.copy(f, file)
  })

  # hatch update estimation
    Hatch_Update <- eventReactive(input$update_hatching, {
      EGGS_CHICKS_updateHatchDate()
      paste("Updated on", Sys.time() )

    })

    output$update_hatchingOut <- renderUI({
     o = Hatch_Update()

     HTML(o)

    })

  # hatching date show
    output$hatching_show <- renderPlot({
      x = idbq('select min(est_hatch_date) est_hatch_date  from EGGS_CHICKS group by nest')
      x[, est_hatch_date := as.Date(est_hatch_date)]

      ggplot(x[est_hatch_date > as.Date('2017-06-28')], aes(est_hatch_date)) + geom_bar() +
      theme_gdocs()



    } )

# RESIGHTINGS map
  output$resightsmap_show <- renderPlot({

    x = RESIGHTINGS()
    map_resights(x, size = input$font_size, daysAgo = input$daysAgo)

    })

  output$resightsmap_pdf <- downloadHandler(
  filename = 'resightsmap.pdf',
  content = function(file) {

    x = RESIGHTINGS()

    m = map_resights(x, size = input$font_size)

    cairo_pdf(file = file, width = 11, height = 8.5)
    print(m)
    dev.off()
  })

# RESIGHTS BY ID map
  output$resightsbyidmap_show <- renderPlot({

  x = RESIGHTINGS_BY_ID(input$LL, input$LR)
  map_resights_by_id(x)

  })

# TRACKS map
  output$tracksmap_show <- renderPlot({

  x = fetch_GPS_tracks(input$trackshour)
  map_tracks(x)

  })

# RESIGHTINGS data
  output$resightsdata_show <- renderDataTable({
    idbq('select * from RESIGHTINGS')

    }, options = list(scrollX = TRUE) )

# CAPTURES data
  output$capturesdata_show <- renderDataTable({
    idbq('select * from CAPTURES')

    } )


})



