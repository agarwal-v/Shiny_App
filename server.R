library(shiny)
library(plotly)
library(leaflet)

shinyServer(function(input, output) {
  # Read the bank data and predownloaded city location data
  bankData <- read.csv("banklist.csv")
  cityLocData <- read.csv("cityloc.csv")
  # Get year of closing for the bank
  bankData$Closing.Date <- as.Date(bankData$Closing.Date, "%d-%b-%y")
  bankData$Year <- as.numeric(format(bankData$Closing.Date, "%Y"))
  # merge cities and bank data base to add locations
  bankData$Cities <- paste(as.character(bankData$City), as.character(bankData$ST), sep = ", ")
  cityLocData$Cities <- as.character(cityLocData$Cities)
  bankData <- merge(bankData, cityLocData)  

  output$summary <- renderText("Select the duration using the left slider")
  output$desc <- renderText("Histogram displays the number of failed banks in US by year")
  output$mapdesc <- renderText("Maps displays the geographical distribution of failed banks in US")
  
  # Render the histogram using plotly
  output$histOut <- renderPlotly({
    minY <- input$Years[1]
    maxY <- input$Years[2]
    failedBank = bankData[bankData$Year <= maxY & bankData$Year >= minY,]
    plot_ly(x = as.character(failedBank$Year), type = "histogram")
  })
  
  # Display the failed locations using leaflet
  output$mapOut <- renderLeaflet({
    minY <- input$Years[1]
    maxY <- input$Years[2]
    failedBank = bankData[bankData$Year <= maxY & bankData$Year >= minY,]
    suppressMessages(failedBank %>% leaflet() %>% addTiles()  %>%
      addCircleMarkers(popup = paste(failedBank$Bank.Name, failedBank$Cities, sep = ', '), 
                       clusterOptions = markerClusterOptions()))
  })
  
  
})