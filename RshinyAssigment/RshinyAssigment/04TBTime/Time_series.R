# app1.R

library(shiny)
library(ggplot2)
install.packages("shiny")
install.packages("ggplot2")

# Load dataset
tb_data <- read.csv("data/TB_Burden_Country.csv")

# Shiny app
ui <- fluidPage(
  titlePanel("Time Series of TB Prevalence Over Time"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Country", "Select Country", choices = unique(tb_data$Country))
    ),
    mainPanel(
      plotOutput("timeSeriesPlot")
    )
  )
)

server <- function(input, output) {
  output$timeSeriesPlot <- renderPlot({
    country_data <- subset(tb_data, Country == input$Country)
    ggplot(country_data, aes(x = Year, y = Estimated_TB_population)) +
      geom_line(color = "blue") +
      labs(
        title = paste("TB Prevalence Over Time in", input$Country),
        x = "Year",
        y = "Prevalence per 100,000 Population"
      ) +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)
