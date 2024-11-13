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
    # Map data
    worldMap <- joinCountryData2Map(tb_latest,
                                    joinCode = "ISO3",
                                    nameJoinColumn = "ISO 3-character country/territory code")
    mapCountryData(worldMap, nameColumnToPlot = "Estimated prevalence of TB (all forms) per 100 000 population",
                   mapTitle = paste("TB Prevalence per 100,000 Population in", latest_year),
                   colourPalette = "heat",
                   catMethod = "fixedWidth",
                   addLegend = TRUE)
  })
}

shinyApp(ui = ui, server = server)