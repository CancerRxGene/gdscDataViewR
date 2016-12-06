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

shinyUI(
  navbarPage(
    "Fit dose response curves",
    tabPanel(
      "Select dataset",
      radioButtons("dataset_choice",
                   label = "Available datasets",
                   choices = as.list("Waiting to load datasets"), 
                   width= '100pc'
                   ),
      verbatimTextOutput("dataset_choice_text")
    ),
    tabPanel(
      "Screen data",
      sidebarLayout(
        sidebarPanel(
          "The drug in the model fit is specified by components:",
          verbatimTextOutput("drug_spec_text"),
          uiOutput("choose_cell_line"),
          "Cell line name",
          verbatimTextOutput("cell_line_name_text"),
          uiOutput("choose_drug"),
          "Drug id:",
          verbatimTextOutput("drug_id_text")
        ),
        mainPanel(
          DT::dataTableOutput("mytable1"),
          downloadButton('downloadTable1', 'Download csv')
        )
      )
    ),
    tabPanel('Selected model to plot',
             sidebarLayout(
               sidebarPanel(
                 "Cell line name",
                  verbatimTextOutput("selected_cell_line_name_text"),
                  "drug",
                  verbatimTextOutput("selected_drug_text"),
                 "Drug_id",
                  verbatimTextOutput("selected_drug_id_text"),
                 "Model parameters:\n",
                 "xmid",
                  verbatimTextOutput("selected_xmid_text"),
                 "scal",
                  verbatimTextOutput("selected_scal_text")
               ),
               mainPanel(
                 DT::dataTableOutput("mytable2"),
                 downloadButton('downloadTable2', 'Download csv')
               )
             )
    ),
    tabPanel('Dose reponse plot',
             plotOutput("plot_dr_plot"),
             downloadButton('downloadDrPlot', 'Download PDF')
    )
  )
)
    
    
