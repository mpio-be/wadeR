


bootstrapPage(
	tags$style(type = "text/css", "html, body {width:100%;height:100%}"),

	tags$style(type='text/css',
		".selectize-input{
		height: 20px;
		width: 120px;
		}"), 

	tags$style(type='text/css',
		".shiny-bound-input{
		height: 20px;
		width: 120px;
		}"), 


	leafletOutput("map", width = "100%", height = "100%"), 


	absolutePanel(draggable = TRUE, top = 0, right = 0, width='130px',

		selectInput(  "task", "Show",   c('GPS points', 'Nests') ,  multiple = FALSE),

		 conditionalPanel( condition = "input.task == 'GPS points'",
		 	selectInput("gpsid", "GPS ID", 1:15 ,  multiple = FALSE),
		 	textAreaInput("gpspts", "GPS points", placeholder = "1,2,3 ... comma separated", value = '1,2,3,4')
		 	), 

		 conditionalPanel(condition = "input.task == 'Nests'",
		 	   selectInput("species", "Species:",multiple = TRUE, selectize = FALSE, 
		 	   	selected = c('REPH', 'LBDO'),
              	c("RNPH", "LBDO", "PESA", "REPH", "SESA", "AMGP", "BASA", "DUNL") )
		 	)





	)

  )


