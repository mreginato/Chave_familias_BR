library(shiny)
library(shinyjs)
library(shinyTree)
library(shinyWidgets)
library(shinythemes)

#setwd("C:/Users/Marcelo/Desktop/Chave online/chave_familias")

# Run the application 
shinyApp(ui = "ui.R", server = "server.R")
