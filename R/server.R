# Copyright (C) 2016 Genome Research Ltd.
# Author: Howard Lightfoot <howard.lightfoot@sanger.ac.uk>
# MIT License
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# This file is part of gdscDataViewR

library(shiny)
library(dplyr)
library(gdscDataR)
library(ggplot2)

shinyServer(function(input, output, session) {

  datadir <- "set_the_path_to_your_shiny_gdsc_dataset"
  
  datasets <- list.files(datadir, pattern = "*.rds")
  
  updateRadioButtons(session, inputId = "dataset_choice", choices = datasets)
  output$dataset_choice_text <- renderText(input$dataset_choice)
  
  model_stats <- reactive({ 
    model_stats <- readRDS(paste(datadir, input$dataset_choice, sep = ""))
    model_stats
    })
  
  model_results <- reactive({
    results.dat <- model_stats() %>% select(CL,
                                            CELL_LINE_NAME,
                                            drug,
                                            DRUG_ID,
                                            maxc,
                                            DRUGSET_ID,
                                            lib_drug,
                                            IC50,
                                            auc,
                                            AUCtrap,
                                            RMSE
    ) %>% distinct()
  })
  
  
  output$mytable1 <- DT::renderDataTable(
    DT::datatable(
      model_results(),
      filter = 'top',
      options = list(searching = F)
    )
  )
  
  output$downloadTable1 <- downloadHandler(
    filename = function() {
      paste('Fitted_dataset_',
            format(Sys.time(), "%d%b%y_%H%M"),
            '.csv', sep='')
    },
    content = function(file) {
      write.csv(model_results(), file, row.names = F)
    }
  )
  
  output$drug_spec_text <- renderText({
    drug_spec_text <- model_stats() %>% select(drug_spec) %>% distinct()
    unlist(drug_spec_text)
  })
  
  CL_filtered_input <- reactive({
    model_stats_data <- model_stats()
    if(!is.null(model_stats_data)){
      filtered_data <- model_stats_data %>% filter(CL == input$cl_spec)
    }
    return(filtered_data)
  })
  
  CL_drug_filtered_input <- reactive({
    result.dat <- CL_filtered_input() %>%  filter(drug == input$drug_spec)
  })
  
  # Drop-down selection box for which cell line
  output$choose_cell_line <- renderUI({
    cell_lines <- model_results() %>% select(CL) %>% distinct()
    selectInput("cl_spec", "CL specifier:", as.list(as.character(cell_lines$CL)))
  })
  
#   output$cosmic_id_text <- renderText({
#     cosmic_id <- CL_filtered_input() %>% select(COSMIC_ID) %>% distinct()
#     as.character(cosmic_id$COSMIC_ID)
#   })
  cell_line_name_text <- reactive({
    cl_name <- CL_filtered_input() %>% select(CELL_LINE_NAME) %>% distinct()
    unlist(cl_name)
  })
  
  output$cell_line_name_text <- renderText({
    cell_line_name_text()
  })
  
  output$choose_drug <- renderUI({
    drugs <- CL_filtered_input() %>% select(drug) %>% distinct()
    selectInput("drug_spec", "Drug specifier:", as.list(as.character(drugs$drug)))
  })

  drug_id_text <- reactive({
    drug_id <- CL_drug_filtered_input() %>% select(DRUG_ID) %>% distinct()
    return(drug_id$DRUG_ID)
  })
  
  drug_text <- reactive({
    drug <- CL_drug_filtered_input() %>% select(drug) %>% distinct()
    return(drug$drug)
  })
  
  xmid_text <- reactive({
    xmid <- CL_drug_filtered_input() %>% select(xmid) %>% distinct()
    return(xmid$xmid)
  })
  
  scal_text <- reactive({
    scal <- CL_drug_filtered_input() %>% select(scal) %>% distinct()
    return(scal$scal)
  })
  
  output$drug_id_text <- renderText({
    drug_id_text()
  })
  
  output$mytable2 = DT::renderDataTable({
    # model_results[, input$show_vars, drop = FALSE]
    CL_drug_filtered_input() %>% 
      select(
        x,
        x_micromol, 
        y,
        yhat,
        yres
      )
  })
  
  output$selected_cell_line_name_text <- renderText({
    cell_line_name_text()
  })
  
  output$selected_drug_id_text <- renderText({
    drug_id_text()
  })
  
  output$selected_drug_text <- renderText({
    drug_text()
  })
  
  output$selected_xmid_text <- renderText({
    xmid_text()
  })
  
  output$selected_scal_text <- renderText({
    scal_text()
  })
  
  output$selected_drug_id_text <- renderText({
    drug_id <- CL_drug_filtered_input() %>% select(DRUG_ID) %>% distinct()
    drug_id_text()
  })
  
  output$downloadTable2 <- downloadHandler(
    filename = function() {
      paste('Fitted_data_',
            format(Sys.time(), "%d%b%y_%H%M"),
                   '.csv', sep='')
    },
    content = function(file) {
      write.csv(CL_drug_filtered_input(), filerow.names = F)
    }
  )
  
  dr_plot_gg <- reactive({
    p <- plotResponse(CL_drug_filtered_input(), input$cl_spec, input$drug_spec)
  })

  output$plot_dr_plot  <- renderPlot({
    p <- dr_plot_gg()
    (p)
  })
  
  output$downloadDrPlot <- downloadHandler(
    filename = function() {
      paste('dose_response_',
            format(Sys.time(), "%d%b%y_%H%M"),
            '.pdf', sep='')
    },
    content = function(file) {
      p <- dr_plot_gg()
      ggsave(file, paper = "a4r", width = 8, height = 5)
    }
  )
  
})

