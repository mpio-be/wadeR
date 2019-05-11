
shinyServer(function(input, output, session) {
 observe( on.exit( assign('input', reactiveValuesToList(input) , envir = .GlobalEnv)) )

  # reactive data
  rGPS <- reactive({
    fetch_GPS_points(input$gpsid, input$gpspts)
    
  })

  rNESTS <- reactive({
    NESTS(project = FALSE)
    
  })



  output$map <- renderLeaflet({
    leaflet()
  })



  observe({

    if(input$task== "GPS points") {
      d = rGPS()
   
      leafletProxy("map") %>%
      fitBounds(min(d$lon), min(d$lat), max(d$lon), max(d$lat)) %>%
      addProviderTiles(providers$Esri.WorldImagery) %>%

      clearMarkers() %>%
      addCircleMarkers(lng = d$lon, lat = d$lat , radius = 4, color = 'red', weight = 1, 
                      opacity = 0.6, fillColor = 'red', fillOpacity = 0.6, 
                      popup  = paste(d$gps_point, d$datetime_, sep = '<br>' )  )
      }

    if(input$task== "Nests") {
      
      d = rNESTS()[species %in% input$species]

      leafletProxy("map") %>%
      fitBounds(min(d$lon), min(d$lat), max(d$lon), max(d$lat)) %>%
      addTiles() %>%
      clearMarkers() %>%
      addCircleMarkers(lng = d$lon, lat = d$lat , radius = 4, color = 'red', weight = 3, 
                      opacity = 0.6, fillColor = 'red', fillOpacity = 0.6) %>%
      addLabelOnlyMarkers(lng = d$lon, lat = d$lat , label =  d$nest, 
                      labelOptions = labelOptions(noHide = TRUE, direction = 'top', 
                        textOnly = TRUE) )

      }


  })

 })