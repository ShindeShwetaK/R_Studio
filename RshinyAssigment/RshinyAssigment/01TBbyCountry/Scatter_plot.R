library(shiny)
library(ggplot2)

# Load dataset
tb_data <- read.csv("data/TB_Burden_Country.csv")

# Clean column names to be syntactically valid for R
colnames(tb_data) <- make.names(colnames(tb_data))

# Shiny app UI
ui <- fluidPage(
  titlePanel("Scatter Plot of TB Prevalence vs. Mortality Rate"),
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Select Year", choices = unique(tb_data$Year))
    ),
    mainPanel(
      plotOutput("scatterPlot")
    )
  )
)

# Shiny app server
server <- function(input, output) {
  output$scatterPlot <- renderPlot({
    # Filter data based on the selected year
    year_data <- subset(tb_data, Year == input$year)
    
    # Plot using ggplot with column names referenced dynamically
    ggplot(year_data, aes(x = .data$Estimated.prevalence.of.TB..all.forms..per.100.000.population,
                          y = .data$Estimated.mortality.of.TB.cases..all.forms..excluding.HIV..per.100.000.population)) +
      geom_point(color = "darkred", alpha = 0.6) +
      geom_smooth(method = "lm", se = TRUE, color = "blue") +
      labs(
        title = paste("TB Prevalence vs. Mortality Rate in", input$year),
        x = "TB Prevalence per 100,000",
        y = "TB Mortality Rate per 100,000"
      ) +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)