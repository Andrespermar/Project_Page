library(shiny)
library(plotly)
library(dplyr)
#library(rsconnect)

#setwd("C:/Users/User/Documents/R Scripts/ShinnyApp")

df = read.csv("MPC Thinning (Renovans).csv")


#Dataset contains various 0s so we get rid of those rows
df = df %>%
  filter(longitude != 0)

df = df %>%
  filter(latitude != 0)



# #Filter so we only get 2023 and 2024 observations
# Convert the date column to Date type
df$date = as.Date(df$date)
df$year = as.numeric(format(df$date, "%Y"))

# Define UI
ui <- fluidPage(
  titlePanel("Dynamic MPC Thinning Map with Filters"),
  sidebarLayout(
    sidebarPanel(
      selectInput("yearFilter", "Select Year:", choices = c("All", unique(df$year)), selected = "All"),
      selectInput("commodityFilter", "Select Commodity:", choices = c("All", unique(df$commodity)), selected = "All"),
      selectInput("varietyFilter", "Select Variety:", choices = c("All", unique(df$variety)), selected = "All"),
      selectInput("blockidFilter", "Select Block ID:", choices = c("All", unique(df$blockid)), selected = "All")
    ),
    mainPanel(
      plotlyOutput("mapPlot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  output$mapPlot <- renderPlotly({
    # Filter data based on selection
    filteredData <- df %>%
      filter((input$yearFilter == "All") | (year == as.numeric(input$yearFilter))) %>%
      filter((input$commodityFilter == "All") | (commodity == input$commodityFilter)) %>%
      filter((input$varietyFilter == "All") | (variety == input$varietyFilter)) %>%
      filter((input$blockidFilter == "All") | (blockid == as.numeric(input$blockidFilter)))
    
    #Generate hover text
    filteredData$hovertext <- paste("Commodity: ", filteredData$commodity,
                                    "<br>Variety: ", filteredData$variety,
                                    "<br>Block ID: ", filteredData$blockid,
                                    "<br>Year: ", filteredData$year)
    
    # Plot
    p <- plot_ly(
      data = filteredData,
      lat = ~latitude,
      lon = ~longitude,
      type = 'scattermapbox',
      mode = 'markers',
      marker = list(size = 9),
      text = ~hovertext,
      hoverinfo = 'text'
    ) %>%
      layout(mapbox = list(
        style = 'white-bg',
        zoom = 3,
        center = list(lon = -93 ,lat= 41),
        layers = list(list(
          below = 'traces',
          sourcetype = "raster",
          source = list("https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}")))))
             #showlegend = FALSE)
  
    p
  })
  
}

# Run the app
shinyApp(ui, server)


