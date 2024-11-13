library(shiny)
library(ggplot2)
library(readxl)

# Load the dataset (update path if necessary)
poke <- read_excel("data/TB_Burden_Country.xlsx", sheet = 1)

# Assuming your dataset has a column 'Year' and 'Estimated_TB_population'
# Modify the column names if necessary based on your dataset
pokePts <- poke[, c("Year", "Estimated_TB_population")]

# Define UI
ui <- fluidPage(
  titlePanel("TB Impact by Year"),
  
  sidebarLayout(
    sidebarPanel(
      # User can select the year
      selectInput(inputId = 'year', label = "Select Year", choices = unique(pokePts$Year))
    ),
    
    mainPanel(
      plotOutput(outputId = 'linePlot', width = "100%", height = "500px")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  output$linePlot <- renderPlot({
    # Filter data for selected year
    year_data <- subset(pokePts, Year == input$year)
    
    # Create the line plot using ggplot2
    ggplot(year_data, aes(x = Year, y = Estimated_TB_population)) +
      geom_line(color = "blue") +
      geom_point(color = "red") +  # Add points to the line graph
      labs(
        title = paste("TB Prevalence in", input$year),
        x = "Year",
        y = "Estimated TB Population"
      ) +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)