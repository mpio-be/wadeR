function(input, output,session) {

  observe( on.exit( assign('input', reactiveValuesToList(input) , envir = .GlobalEnv)) )

  observeEvent(input$refresh, {
        shinyjs::js$refresh()
      })

  Save <- eventReactive(input$saveButton, {

    return(hot_to_r(input$table))

   })

  output$run_save <- renderUI({
    x = Save() %>% data.table
    x = cleaner(x)


    isolate(ignore_validators <- input$ignore_checks )

    # inspector
      cc = inspector(sqlInspector, x, user, db, host)
      #cc<<- cc

      if(nrow(cc) > 0 & !ignore_validators) {
          toastr_error( boostrap_table(cc),
            title = HTML('<p>Data entry errors. Check <q>Ignore warnings</q> to by-pass this filter and save the data as it is.<br> WRITE IN THE COMMENTS WHY DID YOU IGNORE WARNINGS!</p>') ,
            timeOut = 100000, closeButton = TRUE, position = 'top-full-width')
       }

    # db update
      if(   nrow(cc) == 0 | (nrow(cc) > 0 & ignore_validators ) ) {

        con = dbcon(user = user,  host = host)
        dbq(con, paste('USE', db) )
        saved_set = dbWriteTable(con, table, x, append = TRUE, row.names = FALSE)

        if(saved_set) {
          toastr_success( paste(nrow(x), "rows saved to database.") )
          toastr_warning('Refreshing in 5 secs ...', progressBar = TRUE, timeOut = 5000) 
          Sys.sleep(6)
           shinyjs::js$refresh()
          }

        dbDisconnect(con)

        cat('-------')

        }

    })



  output$table  <- renderRHandsontable({

  H = emptyFrame(user, host, db, table, n = 10, excludeColumns, 
        preFilled = list( UL = 'M', UR = 'Y') )



    rhandsontable(H) %>%
      hot_cols(columnSorting = FALSE, manualColumnResize = TRUE) %>%
      hot_rows(fixedRowsTop = 1)  %>%
      hot_col(col = "author",     type = "dropdown", 
        source = c('', 'GB', 'MB', 'MC', 'CG', 'BK', 'JK', 'P3', 'KT', 'MV', 'AW') ) %>%
      hot_col(col = "behav_cat",  type = "dropdown", source = c('', 'R', 'C') ) %>%                                          
      hot_col(col = "habitat",    type = "dropdown", source = c('', 'W', 'G') ) %>%                                          
      hot_col(col = "sex",        type = "dropdown", source = c('', 'M', 'F') ) %>%                                          
      hot_col(col = "aggres",     type = "dropdown", 
        source = c('', 'D', 'D0', 'D1', 'F', 'F0', 'F1', 'B', 'B0', 'B1', 'O', 'O0', 'O1') ) %>%
      
      hot_col(col = "displ",      type = "dropdown", source = c('', "K", "K0", "K1", "F", "F0", "F1", "P", "P0", "P1") ) %>%
      
      hot_col(col = "cop",        type = "dropdown", source = c("", "S", "S0", "S1", "A", "A0", "A1") ) %>%
      
      hot_col(col = "flight",     type = "dropdown", source = c('', 'F', 'F0', 'F1', 'C', 'C0', 'C1', 'CF') ) %>%
      
      hot_col(col = "voc",        type = "dropdown", source = c('', 'Y', 'N') ) %>%
      
      hot_col(col = "maint",      type = "dropdown", source = c('', 'F', 'R', 'P', 'A') ) %>%
      
      hot_col(col = "spin",       type = "dropdown", source = c('', 'C', 'AC', 'B') )

   })


  output$column_comments <- renderTable({
      comments
  })

 }

