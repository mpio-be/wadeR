

shinyUI(

dashboardPage(
    dashboardHeader(title = paste('BARROW', Y)   ),

dashboardSidebar(
    selectInput("gpsid", "GPS ID", 1:15 ,  multiple = FALSE),

    textAreaInput("gpspts", "GPS points", placeholder = "1,2,3 ... comma separated", value = '1,2,3,4')
  ), 

dashboardBody(
    
  # shiny::tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%")
)


)

)