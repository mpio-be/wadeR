
shinyServer(function(input, output, session) {
 observe( on.exit( assign('input', reactiveValuesToList(input) , envir = .GlobalEnv)) )

  filteredData <- reactive({
    fetch_GPS_points(input$gpsid, input$gpspts)
    
  })

  output$map <- renderLeaflet({
    leaflet()
  })



  observe({

    d = filteredData()
 
    leafletProxy("map") %>%
    fitBounds(min(d$lon), min(d$lat), max(d$lon), max(d$lat)) %>%
    addTiles() %>%
    clearMarkers() %>%
    addCircleMarkers(lng = d$lon, lat = d$lat , radius = 4, color = 'red', weight = 1, opacity = 0.6, fillColor = 'red', fillOpacity = 0.6, popup  = paste(d$gps_point, d$datetime_, sep = '<br>' )  )


  })

 })