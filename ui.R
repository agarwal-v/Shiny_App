library(shiny)
library(plotly)
library(leaflet)

shinyUI(fluidPage(
  titlePanel("Visualize Bank Failures"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("Years", "Range of years", 2002, 2018, value = c(2004, 2015))
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Description", br(), textOutput("summary"), textOutput("desc"), textOutput("mapdesc")),
                  tabPanel("Histogram", br(), plotlyOutput("histOut")), 
                  tabPanel("Map", br(), leafletOutput("mapOut"))
      ))
    )
))