

shinyUI(

bootstrapPage(
  shiny::tags$style(type = "text/css", "html, body {width:100%;height:100%}"),

  leafletOutput("map", width = "100%", height = "100%"),


  absolutePanel(top = pos[1] ,  right = 10,
  	selectInput("gpsid", "GPS ID", 1:15 ,  multiple = FALSE) ),

  absolutePanel(top = pos[2] ,  right = 10,
  	textAreaInput("gpspts", "GPS points", placeholder = "1,2,3 ... comma separated", value = '1,2,3,4')
     )


)

)