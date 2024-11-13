library(shiny)
library(ggplot2)

# Load dataset
tb_data <- read.csv("data/TB_Burden_Country.csv")

# Check the structure of the data to confirm the column names
str(tb_data)

# Shiny app
ui <- fluidPage(
  titlePanel("Scatter Plot of TB Incidence vs. Mortality Rate"),
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Select Year", choices = unique(tb_data$Year))
    ),
    mainPanel(
      plotOutput("scatterPlot")
    )
  )
)

server <- function(input, output) {
  output$scatterPlot <- renderPlot({
    # Filter data based on the selected year
    year_data <- subset(tb_data, Year == input$year)
    
    # Remove rows with missing values in the relevant columns
    year_data <- na.omit(year_data[, c("Estimated_population", "Estimated_mortality_TB")])
    
    # Scatter plot of TB incidence vs. mortality rate
    ggplot(year_data, aes(x = Estimated_population, y = Estimated_mortality_TB)) +
      geom_point(color = "darkred", alpha = 0.6) +
      labs(
        title = paste("TB Incidence vs. Mortality Rate in", input$year),
        x = "TB Incidence per 100,000",
        y = "TB Mortality Rate per 100,000"
      ) +
      theme_minimal()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)