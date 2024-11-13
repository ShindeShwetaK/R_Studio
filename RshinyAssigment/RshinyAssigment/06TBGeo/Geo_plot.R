library(shiny)
library(rworldmap)

# Load dataset
tb_data <- read.csv("data/TB_Burden_Country.csv")

# Aggregate data for the most recent year available
latest_year <- max(tb_data$Year)
tb_latest <- subset(tb_data, Year == latest_year)

# Shiny app
ui <- fluidPage(
  titlePanel("Geospatial Map of TB Prevalence by Country"),
  mainPanel(
    plotOutput("mapPlot")
  )
)

server <- function(input, output) {
  output$mapPlot <- renderPlot({
    # Ensure that column names are correct
    # Join the TB dataset to the map using the ISO3 country code
    worldMap <- joinCountryData2Map(tb_latest,
                                    joinCode = "ISO3",               # Use ISO3 country codes
                                    nameJoinColumn = "ISO.3.character.country.territory.code")  # Correct column name for ISO3
    
    # Plot the map with the TB prevalence data
    mapCountryData(worldMap, 
                   nameColumnToPlot = "Estimated_TB_population", 
                   mapTitle = paste("TB Prevalence per 100,000 Population in", latest_year),
                   colourPalette = "heat",        # Color palette for the map
                   catMethod = "fixedWidth",      # Method for color categorization
                   addLegend = TRUE)             # Add legend to the map
  })
}

shinyApp(ui = ui, server = server)
