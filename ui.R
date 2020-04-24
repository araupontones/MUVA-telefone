library(leaflet)
library(tidyverse)
library(shiny)
library(shinycssloaders)



#start ui

navbarPage("Llamadas telefonicas", id = "nav",
           
           
           tabPanel("Lista", heigth="100%",
                    
                    tags$head(
                      tags$style(
                        HTML(
                          'body{padding:30px}
                          
                          #map {height: calc(100vh - 180px) !important;}"
                          
                          #Chart_title {margin-top: -20px !important;}
                          '
                        )
                        
                      )
                    ),
                    
                    

                      withSpinner(DT::dataTableOutput("table"))
                    
           )
)


