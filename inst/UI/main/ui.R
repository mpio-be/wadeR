
shinyUI(

dashboardPage(skin = 'black',
  dashboardHeader(title = paste('BARROW', Y)   ),

  dashboardSidebar(
    sidebarMenu(id = 'menubar',
      # dateInput("date", "Date:", value = Sys.Date(), min = '2016-05-20', max =  Sys.Date() + 6 ),

      menuItem("Overview",         tabName  = "overview_tab",  icon = icon("clone") ),


      menuItem("GPS management",   tabName  = "gps_tab",   icon = icon("hdd-o") ),

      menuItem("Nests dashboard",  tabName  = "nestsDashSummary_tab",      icon = icon("sun-o") ),

      menuItem("Data viewer",  icon = icon("binoculars") ,
        menuSubItem("Captures",    tabName  = "capturesdata_tab",   icon = icon("caret-right") ),
        menuSubItem("Resightings", tabName  = "resightsdata_tab",   icon = icon("caret-right") ),
        menuItem("Nests",          tabName  = "nestsdata_tab",      icon = icon("caret-right") )
        ),

      menuItem("Static maps",  icon = icon("map") ,
        menuSubItem("Nests",           tabName  = "nestsmap_tab",         icon = icon("caret-right") ),
        menuSubItem("Resightings",     tabName  = "resightsmap_tab",      icon = icon("caret-right") ),
        menuSubItem("Resights by id",  tabName  = "resightsbyidmap_tab",  icon = icon("caret-right") ),
        menuSubItem("Tracks",          tabName  = "tracksmap_tab",  icon = icon("caret-right") )
     
        ),
      
      menuItem("Dynamic maps",  icon = icon("map") ,
        menuSubItem('Nests',     href     = '/wadeR/imap',        newtab = TRUE),
        menuSubItem('gps points',     href     = '/wadeR/imap',        newtab = TRUE)
     
        ),

      menuItem("Data entry",  icon = icon("database"),
        menuSubItem('CAPTURES',   href = '/wadeR/DataEntry/CAPTURES',     newtab = TRUE),
        menuSubItem('NESTS',      href = '/wadeR/DataEntry/NESTS',        newtab = TRUE),
        menuSubItem('EGGS_CHICKS_field',href = '/wadeR/DataEntry/EGGS_CHICKS_field', newtab = TRUE),
        menuSubItem('RESIGHTINGS',href = '/wadeR/DataEntry/RESIGHTINGS',  newtab = TRUE),
        menuSubItem('DEVICES',    href = '/wadeR/DataEntry/DEVICES',      newtab = TRUE),
        menuSubItem('phpmyadmin', href = paste0('http://', ip() ,'/phpmyadmin/'),newtab = TRUE)
        ),

      # CONDITIONAL PANNELS
      # all maps
        div(class = "col-sm-12 text-center",
        conditionalPanel(
          condition = "input.menubar == 'nestsmap_tab' |
                       input.menubar == 'resightsmap_tab'",
          sliderInput("font_size", "Text and symbol size:", min = 1, max = 7,step = 0.2, value = 4)

          ) ) ,

      # NESTS
        div(class = "col-sm-12 text-center",
        conditionalPanel(
          condition = "input.menubar == 'nestsmap_tab'",
          selectInput("species", "Species:",multiple = TRUE, selected = 'REPH',
              c("AMGP", "BASA", "DUNL", "RNPH", "PESA", "REPH", "SESA", "LBDO") ),

          selectInput("nest_state", "Nest state:",multiple = TRUE,
              c("Found"             = "F",
                "Collected"         = "C",
                "Incubated"         = "I",
                "possibly Predated" = "pP",
                "possibly Deserted" = "pD",
                "Hatched"           = "H"
                )),

          downloadButton('nestsmap_pdf', 'PDF map', style="font-size:25px;" )
          ) ),

      # RESIGHTINGS
        div(class = "col-sm-12 text-center",
        conditionalPanel(
          condition = "input.menubar == 'resightsmap_tab'",
          downloadButton('resightsmap_pdf', 'PDF map', style="font-size:25px;" )
          ),
        conditionalPanel(
          condition = "input.menubar == 'resightsmap_tab'",
          numericInput('daysAgo', HTML('Seen in the last<br>N days:'), value = 3)

        )

        ) ,

      # RESIGHTINGS BY ID
        div(class = "col-sm-6 text-center",

        conditionalPanel(
          condition = "input.menubar == 'resightsbyidmap_tab'",
          div(style="display:inline-block", textInput('LL', 'LL', width = '100') ),
          div(style="display:inline-block", textInput('LR', 'LR', width = '100') )

          )
        ),


      # RESIGHTINGS BY ID
        div(class = "col-sm-12 text-center",

        conditionalPanel(
          condition = "input.menubar == 'tracksmap_tab'",

          numericInput('trackshour', HTML('Last N hours<br>(since last entry)'), value = 48)

          )
        )



  )),

 dashboardBody(
  useToastr(),
  useShinyjs(),
  includeScript("../www/text.js"),

tabItems(
    tabItem(tabName = "overview_tab",

      box(title = 'Info',
        uiOutput('sys_show')
        ),

      box(title = 'DB state',
        tableOutput('overview_show'))


      ),


    # GPS
      tabItem(tabName = "gps_tab",
        box(  includeMarkdown( system.file('UI', 'docs', 'garmin_oregon_450.md', package = 'wadeR')),
              title = 'Initial GPS Settings.', collapsible = TRUE, collapsed = FALSE,
                footer = 'Before using your GPS for the first time make sure the settings are correct.'),

      box(title = 'GPS Upload - Download',
             shiny::tags$div(class="form-group shiny-input-container",
              shiny::tags$div(shiny::tags$label("Upload GPS", class="btn btn-danger",
                                  shiny::tags$input(id = "fileIn", webkitdirectory = TRUE, type = "file", style="display: none;", onchange="pressed()"))),
              shiny::tags$label("Select the GARMIN directory only!", id = "noFile"),
              shiny::tags$div(id="fileIn_progress", class="progress progress-striped active shiny-file-input-progress",
                       shiny::tags$div(class="progress-bar")
              )
             ),

       dataTableOutput("gps_files"),

       downloadButton("download_NESTS", label="Download NESTS", class = "dbutt"),
          tags$head(tags$style(".dbutt{background-color:#E6991C;} .dbutt{color: white;}"))


      ),
      HTML("<script type='text/javascript' src='getFolders.js'></script>")


     ),

    # NESTS
      tabItem(tabName = "nestsmap_tab",
        shiny::tags$style(type = "text/css", "#nestsmap_show {height: calc(93vh - 1px) !important;}"),
        plotOutput('nestsmap_show')
        ),

      tabItem(tabName = "nestsdata_tab",
        dataTableOutput('nestsdata_show')
        ),

      tabItem(tabName = "nestsDashSummary_tab",
        box(title = 'NESTS',
          downloadButton("download_nestsSummary", label="Download Nest Summary  PDF"),

          actionButton("update_hatching", "UPDATE hatching estimation"),
          uiOutput("update_hatchingOut")
          ),

        box(title = 'Hatching',
          plotOutput('hatching_show')
          )

        ),




    # RESIGHTINGS
      tabItem(tabName = "resightsmap_tab",
        shiny::tags$style(type = "text/css", "#resightsmap_show {height: calc(93vh - 1px) !important;}"),
        plotOutput('resightsmap_show')
        ),

      tabItem(tabName = "resightsdata_tab",
        dataTableOutput('resightsdata_show')
        ),

    # RESIGHTINGS by ID
      tabItem(tabName = "resightsbyidmap_tab",
        shiny::tags$style(type = "text/css", "#resightsbyidmap_show {height: calc(93vh - 1px) !important;}"),
        plotOutput('resightsbyidmap_show')
        ),

    # TRACKS
      tabItem(tabName = "tracksmap_tab",
        shiny::tags$style(type = "text/css", "#tracksmap_show {height: calc(93vh - 1px) !important;}"),
        plotOutput('tracksmap_show')
        ),


    # CAPTURES
      tabItem(tabName = "capturesdata_tab",
        dataTableOutput('capturesdata_show')
        )





  )

)))

