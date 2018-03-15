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

        dbq(con, 'DROP TABLE IF EXISTS TEMP')
        dbq(con, paste('CREATE TABLE TEMP LIKE', table) )

        update_ok = dbWriteTable(con, 'TEMP', x, append = TRUE, row.names = FALSE)

        if(update_ok) {
          
          dbq(con, paste('DROP TABLE', table) )
          dbq(con, paste('RENAME TABLE TEMP to', table) )

          toastr_success('Table updated successfully.')


          }

        dbDisconnect(con)

        cat('-------')

        }

    })


   # title
    output$title <- renderText({
      paste(table, db, sep = '.')
        })



  output$table  <- renderRHandsontable({
    
    H = getTable()
  
    rhandsontable(H)

    # %>%
      #hot_table(highlightCol = TRUE, highlightRow = TRUE) %>% 
      #hot_cols(columnSorting = FALSE, manualColumnResize = TRUE) 


       


   })

   output$column_comments <- renderTable({
      comments
  })

 }

