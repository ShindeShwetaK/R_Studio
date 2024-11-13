# Required libraries
library(shiny)
library(rworldmap)
library(randomForest)

# Load dataset
tb_data <- read.csv("data/TB_Burden_Country.csv")

# Clean or process the data as needed
# For example, ensure no missing values for the features used in the model:
tb_data <- na.omit(tb_data)


colnames(tb_data)


model <- randomForest(Estimated_TB_population ~ GDP + Region, data = tb_data, importance = TRUE)

# Shiny app UI
ui <- fluidPage(
  titlePanel("Geospatial Map of Predicted TB Prevalence by Country"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Select Year:", choices = unique(tb_data$Year), selected = max(tb_data$Year)),
      actionButton("predict_btn", "Predict TB Prevalence")
    ),
    mainPanel(
      plotOutput("mapPlot")
    )
  )
)

# Shiny server function
server <- function(input, output) {
  
  # Reactive expression to filter data based on selected year
  filtered_data <- reactive({
    subset(tb_data, Year == input$year)
  })
  
  # Render the map plot
  output$mapPlot <- renderPlot({
    
    # Wait for prediction button click
    input$predict_btn
    
    # Predict TB prevalence for the selected year using the random forest model
    predicted_data <- filtered_data()
    predicted_data$predicted_TB_prevalence <- predict(model, newdata = predicted_data)
    
    # Join predicted data to world map using ISO3 country code
    worldMap <- joinCountryData2Map(predicted_data,
                                    joinCode = "ISO3",
                                    nameJoinColumn = "ISO.3.character.country.territory.code")
    
    # Plot the map with predicted TB prevalence
    mapCountryData(worldMap, 
                   nameColumnToPlot = "predicted_TB_prevalence", 
                   mapTitle = paste("Predicted TB Prevalence per 100,000 Population in", input$year),
                   colourPalette = "heat",        # Color palette for the map
                   catMethod = "fixedWidth",      # Method for color categorization
                   addLegend = TRUE)             # Add legend to the map
  })
}
