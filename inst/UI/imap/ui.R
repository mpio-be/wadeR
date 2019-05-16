


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

		pickerInput(  "task", "Show on map:",   
			multiple = FALSE, 
			choices = c('GPS points', 'Nests') ,  
			selected = 'GPS points',
   			choicesOpt = list(
      		content = sprintf("<span class='label label-%s'>%s</span>", 
      			c("success", "danger"), c('GPS points', 'Nests')
        ) )),


		 conditionalPanel( condition = "input.task == 'GPS points'",
		 	selectInput("gpsid", "GPS ID", 1:15 ,  multiple = FALSE),
		 	textAreaInput("gpspts", "GPS points", placeholder = "1,2,3 ... comma separated", value = '1,2,3,4')
		 	), 

		 conditionalPanel(condition = "input.task == 'Nests'",
		 	   selectInput("species", "Species:",multiple = TRUE, selectize = FALSE, 
		 	   	selected = getOption('wader.species')[1:2],
              	getOption('wader.species')  )
		 	)





	)

  )


